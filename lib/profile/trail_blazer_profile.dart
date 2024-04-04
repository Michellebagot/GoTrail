import 'package:GoTrail/header_bar/header_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TrailBlazerProfile extends StatefulWidget {
  @override
  State<TrailBlazerProfile> createState() => _TrailBlazerProfileState();
}

class _TrailBlazerProfileState extends State<TrailBlazerProfile> {
  dynamic userData;
  dynamic trailBlazerData;
  dynamic pointsRequired;
  dynamic isFinalStage = false;
  dynamic trailBlazerStage;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchUserData();
  }

  void fetchUserData() async {
    var db = FirebaseFirestore.instance;
    try {
      var user = FirebaseAuth.instance.currentUser;
      var userRef =
          db.collection("users").doc(FirebaseAuth.instance.currentUser?.uid);
      if (user != null) {
        var db = FirebaseFirestore.instance;
        var data = await db.collection("users").doc(user.uid).get();
        if (data.exists) {
          setState(() {
            userData = data.data();
          });
        }

        if (userData['pointsEarned'] < 100) {
          pointsRequired = 100 - userData['pointsEarned'];
        } else if (userData['pointsEarned'] >= 100 &&
            userData['pointsEarned'] < 200) {
          pointsRequired = 200 - userData['pointsEarned'];
        } else if (userData['pointsEarned'] >= 200) {
          isFinalStage = true;
        }

        if (userData['pointsEarned'] < 100) {
          userRef.set({
            "trailBlazer":
                '${userData['trailBlazer'].substring(0, userData['trailBlazer'].length - 1)}1',
          }, SetOptions(merge: true));
          setState(() => trailBlazerStage =
              '${userData['trailBlazer'].substring(0, userData['trailBlazer'].length - 1)}1');
        } else if (userData['pointsEarned'] >= 100 &&
            userData['pointsEarned'] < 200) {
          userRef.set({
            "trailBlazer":
                '${userData['trailBlazer'].substring(0, userData['trailBlazer'].length - 1)}2',
          }, SetOptions(merge: true));
          setState(() => trailBlazerStage =
              '${userData['trailBlazer'].substring(0, userData['trailBlazer'].length - 1)}2');
        } else if (userData['pointsEarned'] >= 200) {
          userRef.set({
            "trailBlazer":
                '${userData['trailBlazer'].substring(0, userData['trailBlazer'].length - 1)}3',
          }, SetOptions(merge: true));
          setState(() => trailBlazerStage =
              '${userData['trailBlazer'].substring(0, userData['trailBlazer'].length - 1)}3');
        }
        fetchtrailBlazerData(trailBlazerStage);
      } else {
        print("User document not found");
      }
    } catch (e) {
      print(e);
    }
  }

  void fetchtrailBlazerData(trailBlazer) async {
    var db = FirebaseFirestore.instance;
    var data = await db.collection("trailBlazers").doc(trailBlazer).get();
    setState(() {
      trailBlazerData = data.data();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
          context,
          BoxConstraints(
            minWidth: double.infinity,
            maxWidth: double.infinity,
            minHeight: 30,
            maxHeight: 50,
          ),
          0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            userData != null && trailBlazerData != null
                ? Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Center(
                          child: Text(
                            '${userData['trailBlazerName']}',
                            style: TextStyle(fontSize: 40.0),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/background.jpg'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        margin: EdgeInsets.all(25.0),
                        child: Center(
                          child: Image.asset('${trailBlazerData['path']}.gif'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: isFinalStage == false
                            ? Center(
                                child: Text(
                                    'Points Until Next Stage: $pointsRequired'),
                              )
                            : Text('You have fully evolved'),
                      ),
                      Container(
                        margin: EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                              'Current Points: ${userData['pointsEarned']}'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10.0),
                        child: Center(
                          child: Text('Type: ${trailBlazerData['type']}'),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10.0),
                        child: Center(
                          child: Text('Stage: ${trailBlazerData['stage']}'),
                        ),
                      )
                    ],
                  )
                : Center(
                    child: CircularProgressIndicator()), // else Loading screen
          ],
        ),
      ),
    );
  }
}
