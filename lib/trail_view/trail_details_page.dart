import 'package:GoTrail/profile/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:GoTrail/classes/trail.dart';
import 'package:GoTrail/header_bar/header_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:GoTrail/review_page/review_page.dart';

import 'package:GoTrail/tracking_page/tracking_page.dart';
import 'package:latlong2/latlong.dart';

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

  LatLngBounds bounds = LatLngBounds.fromPoints([LatLng(0, 0)]);

  @override
  void initState() {
    super.initState();
    bounds = LatLngBounds.fromPoints(widget.trail.coordinates);
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
    return totalRating / reviews.length;
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

  String _getDisplayName(QueryDocumentSnapshot review) {
    final userName = review['userName'];
    return (userName == null || userName.isEmpty) ? review['userId'] : userName;
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
    if (ModalRoute.of(context)?.isCurrent ?? false) {
      fetchTrailReviews();
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            header(
              context,
              BoxConstraints(
                minWidth: double.infinity,
                maxWidth: double.infinity,
                minHeight: 30,
                maxHeight: 50,
              ),
              0,
            ),
            SizedBox(height: 15),
            Text('${widget.trail.name} - ${widget.trail.description}',
              style: TextStyle(
                fontSize: 20
              ),
            ),
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
              child: Text('Start Trail', 
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 15),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: FlutterMap(
                  options: MapOptions(
                    initialCameraFit: CameraFit.bounds(
                      bounds: bounds,
                      padding: EdgeInsets.all(8.0),
                    ),
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
            SizedBox(height: 15),
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
            SizedBox(height: 8.0,),
            Center(
              child: Text('Difficulty: ${widget.trail.difficulty}')
            ),
            SizedBox(height: 8.0,),
            Center(
              child: Text('Average Time: ${widget.trail.avgTime.toString()}')
            ),
            SizedBox(height: 8.0,),
            Center(
              child: Text('Total Distance: ${widget.trail.distance}')
            ),
            SizedBox(height: 15.0,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15, top: 8, right: 8,),
                    child: Text('Reviews (${reviews.length})')
                  ),
                  _canReview
                      ? Container(
                        margin: EdgeInsets.only(left: 8, right: 8, top: 8,),
                        child: ElevatedButton(
                                            onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReviewPage(widget.trail),
                          ),
                        );
                                            },
                                            child: Text('Add review',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                                            )
                                          ),
                      )

                      : Container(),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromRGBO(166, 132, 119, 1),),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: ListTile(
                    title: Text(_getDisplayName(reviews[index])),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rating: ${reviews[index]['rating']}'),
                        SizedBox(height: 8),
                        Text('${reviews[index]['comment']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
