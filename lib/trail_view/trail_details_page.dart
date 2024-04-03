import 'package:flutter/material.dart';
import 'package:GoTrail/classes/trail.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:GoTrail/review_page/review_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:GoTrail/header_bar/header_bar.dart';
import 'package:GoTrail/tracking_page/tracking_page.dart';

class TrailDetailsPage extends StatefulWidget {
  final Trail trail;

  TrailDetailsPage(this.trail);

  @override
  TrailDetailsPageState createState() => TrailDetailsPageState();
}

class TrailDetailsPageState extends State<TrailDetailsPage> {
  List<QueryDocumentSnapshot> reviews = [];
  double rating = 0.0;
  bool _canReview = false;

  @override
  void initState() {
    super.initState();
    fetchTrailReviews();
    checkUserReviewedTrail();
  }

  double calculateAverageRating(List<QueryDocumentSnapshot> reviews) {
    if (reviews.isEmpty) {
      return 0.0;
    }

    int totalRating = 0;
    for (var review in reviews) {
      int rating = review['rating'].toInt();
      totalRating += rating;
    }
    double averageRating = totalRating / reviews.length;
    return averageRating;
  }

  Future<void> checkUserReviewedTrail() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('reviews')
        .where('userId', isEqualTo: userId)
        .where('trailId', isEqualTo: widget.trail.trailId)
        .get();

    setState(() {
      _canReview = querySnapshot.docs.isEmpty;
    });
  }

  Future<void> fetchTrailReviews() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('trailId', isEqualTo: widget.trail.trailId)
          .get();

      setState(() {
        reviews = querySnapshot.docs;
        rating = calculateAverageRating(reviews);
      });
    } catch (e) {
      print('error fetching reviews: $e');
    }
  }

  navigateToReviewPage(BuildContext context) async {
    final reLoadPage = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReviewPage(widget.trail)),
    );

    if (reLoadPage == true) {
      print("reloading page...");
      fetchTrailReviews();
      checkUserReviewedTrail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          header(
              context,
              BoxConstraints(
                minWidth: double.infinity,
                maxWidth: double.infinity,
                minHeight: 30,
                maxHeight: 50,
              ),
              0),
          SizedBox(height: 10),
          Text('${widget.trail.name} - ${widget.trail.description}'),
          SizedBox(height: 10),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrackingPage(widget.trail),
                  ),
                );
              },
              child: Text('Start Trail')),
          SizedBox(height: 10),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: widget.trail.coordinates[0],
                  initialZoom: 14,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: widget.trail.coordinates,
                        color: Colors.blue,
                        strokeWidth: 3,
                      ),
                    ],
                  ),
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                        onTap: () => launchUrl(
                            Uri.parse('https://openstreetmap.org/copyright')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Text('Average rating: ${rating.toStringAsFixed(1)} / 5'),
          RatingBarIndicator(
            rating: rating,
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            itemCount: 5,
            itemSize: 20.0,
            direction: Axis.horizontal,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text('Reviews (${reviews.length})'),
                SizedBox(width: 10),
                _canReview
                    ? ElevatedButton(
                        onPressed: () => navigateToReviewPage(context),
                        child: Text('Add review'))
                    : Container(),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(reviews[index]['userId']),
                  // TODO: replace with user details when user profiles are implemented
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rating: ${reviews[index]['rating']}'),
                      SizedBox(height: 8),
                      Text('${reviews[index]['comment']}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
