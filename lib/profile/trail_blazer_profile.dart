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

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  void fetchUserData() async {
    var db = FirebaseFirestore.instance;
    var data = await db.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).get();
    setState(() {
      userData = data.data();
    });
    if(userData['pointsEarned']<100){
      pointsRequired = 100-userData['pointsEarned'];
    }
    else if(userData['pointsEarned']>=100 && userData['pointsEarned']<200 ){
      pointsRequired = 200-userData['pointsEarned'];
    }
    else if (userData['pointsEarned']>=200){
      isFinalStage = true;
    }
    if(userData != null){
      fetchtrailBlazerData(userData['trailBlazer']);
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
      appBar: AppBar(
        title: Text('TrailBlazer Profile'),
      ),
      body:
       userData != null && trailBlazerData != null ? //
            Column(
            children: [
              Center(
                  child: Text('${userData['trailBlazerName']}',
                  style: TextStyle(fontSize: 40.0),),
                ),

              Container(
                decoration: BoxDecoration(
                   color: Color.fromARGB(255, 6, 124, 156),
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                margin: EdgeInsets.all(25.0),
                child: Center(
                  child: Image.asset('${trailBlazerData['path']}.gif') ,
                ),
              ),
              isFinalStage == false ? Center( 
                child: Text('Points Until Next Stage: $pointsRequired'),
              ): Text('You have fully evolved'),
              Center(
                child: Text('Current Points: ${userData['pointsEarned']}') ,
              ),
              Center(
                child: Text('Type: ${trailBlazerData['type']}') ,
              ),
              Center(
                child: Text('Stage: ${trailBlazerData['stage']}') ,
              )
            ],
          )

          : Center(child: CircularProgressIndicator()), // else Loading screen
    );
  }
}

