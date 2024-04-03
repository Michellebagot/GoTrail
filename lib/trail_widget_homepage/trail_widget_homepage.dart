import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

TextStyle titleStyle = TextStyle(
  fontFamily: GoogleFonts.balooBhaina2().fontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 24, //needs altering to accommodate mobile styling
  color: Colors.black,
  decoration: TextDecoration.none,
);

TextStyle detailStyle = TextStyle(
  fontFamily: GoogleFonts.lexendDeca().fontFamily,
  fontWeight: FontWeight.normal,
  fontSize: 14, //needs altering to accommodate mobile styling
  color: Colors.black,
  decoration: TextDecoration.none,
);

class TrailWidget extends StatefulWidget {
  @override
  _TrailWidgetState createState() => _TrailWidgetState();
}

class _TrailWidgetState extends State<TrailWidget> {
  late String trailImage;
  late String trailTitle;
  late String trailDescription;
  late int trailDistance;
  late String trailDifficulty;
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
    DocumentSnapshot randomDoc = collection.docs[random];
    setState(() {
      trailImage = randomDoc['image'];
      trailTitle = randomDoc['name'];
      trailDescription = randomDoc['description'];
      trailDistance = randomDoc['distance'];
      trailDifficulty = randomDoc['difficulty'];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 275,
      width: 800,
      child: Card(
        margin: EdgeInsets.all(50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Color.fromRGBO(166, 159, 119, 1),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: CircleAvatar(
                  radius: 70,
                  child: ClipOval(
                    child: isLoading
                        ? CircularProgressIndicator()
                        : Image.network(
                            trailImage,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    isLoading
                        ? CircularProgressIndicator()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Selected Trail - ${trailTitle ?? 'Loading...'}',
                                style: titleStyle,
                              ),
                              SizedBox(height: 5),
                              Text(
                                trailDescription ?? 'Loading...',
                                style: detailStyle,
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Distance: ${trailDistance ?? 'Loading...'}m',
                                style: detailStyle,
                              ),
                              Text(
                                'Difficulty: ${trailDifficulty ?? 'Loading...'}',
                                style: detailStyle,
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
