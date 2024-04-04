import 'package:GoTrail/classes/trail.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:GoTrail/trail_view/trail_details_page.dart';

TextStyle titleStyle = TextStyle(
  fontFamily: GoogleFonts.balooBhaina2().fontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 24, // Adjust as needed for mobile styling
  color: Colors.black,
  decoration: TextDecoration.none,
);

TextStyle detailStyle = TextStyle(
  fontFamily: GoogleFonts.lexendDeca().fontFamily,
  fontWeight: FontWeight.normal,
  fontSize: 14, // Adjust as needed for mobile styling
  color: Colors.black,
  decoration: TextDecoration.none,
);

class TrailWidget extends StatefulWidget {
  @override
  _TrailWidgetState createState() => _TrailWidgetState();
}

class _TrailWidgetState extends State<TrailWidget> {
  late Trail trail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    QuerySnapshot collection =
        await FirebaseFirestore.instance.collection('trails').get();
    var random = Random().nextInt(collection.docs.length);
    DocumentSnapshot randomTrail = collection.docs[random];
    setState(() {
      trail = Trail.fromSnapshot(randomTrail);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isLoading) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrailDetailsPage(trail),
            ),
          );
        }
      },
      child: SizedBox(
        width: 800,
        height: null,
        child: Card(
          margin: EdgeInsets.all(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Color.fromRGBO(166, 159, 119, 1),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: isLoading ? null : NetworkImage(trail.image),
                  child: isLoading ? CircularProgressIndicator() : null,
                ),
                SizedBox(height: 10),
                isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        'Your Selected Trail - ${trail.name}',
                        style: titleStyle,
                        textAlign: TextAlign.center,
                      ),
                SizedBox(height: 5),
                if (!isLoading) ...[
                  Text(
                    trail.description,
                    style: detailStyle,
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Distance: ${trail.distance}m',
                    style: detailStyle,
                  ),
                  Text(
                    'Difficulty: ${trail.difficulty}',
                    style: detailStyle,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
