import 'package:GoTrail/profile/trail_blazer_profile.dart';
import 'package:GoTrail/trail_blazer_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:GoTrail/home.dart';
import 'package:GoTrail/map_view/map_page.dart';
import 'package:GoTrail/trail_search/trail_search.dart';

dynamic userData;

  MaterialPageRoute<ProfileScreen> profilePage() {
     //getting uid if user is logged in
    if (FirebaseAuth.instance.currentUser != null) {
    var db = FirebaseFirestore.instance;
    var userRef = db.collection("users").doc(FirebaseAuth.instance.currentUser?.uid);

     Map<String, dynamic> newUserData;
     userRef.get().then((doc) => {
               userData = doc,
          if (!doc.exists){
              newUserData = <String, dynamic>{
            "name": FirebaseAuth.instance.currentUser?.displayName,
            "pointsEarned": 0,
            "email": FirebaseAuth.instance.currentUser?.email,
            },

          db.collection("users")
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .set(newUserData, SetOptions(merge: true))
              .onError((e, _) => print("Error writing document: $e"))
          }
          else{
            if(doc['pointsEarned']<100){
                userRef.set({"trailBlazer": '${doc['trailBlazer'].substring(0, doc['trailBlazer'].length - 1)}1', }, SetOptions(merge: true))
            }
            else if(doc['pointsEarned']>100 && doc['pointsEarned']<200 ){
              
                userRef.set({"trailBlazer": '${doc['trailBlazer'].substring(0, doc['trailBlazer'].length - 1)}2',}, SetOptions(merge: true))   
            }
            else{
              userRef.set({"trailBlazer": '${doc['trailBlazer'].substring(0, doc['trailBlazer'].length - 1)}3',}, SetOptions(merge: true))  
            }
          }
        }
     );
    }

    return MaterialPageRoute<ProfileScreen>(
     
      builder: (context) => ProfileScreen(
        appBar:  AppBar(
            title: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
              child: Text(
                'GoTrail',
                style: GoogleFonts.balooBhaina2(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            toolbarHeight: 50,
            backgroundColor: Color.fromRGBO(166, 132, 119, 1),
            actions: [
              IconButton(
                icon: const Icon(Icons.map),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapPage(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchPage(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                    context,
                    profilePage(),
                  );
                },
              )
            ],
          ),
       
        children: [
          //  Center(
          //       child: Text('Current Points: ${userData['pointsEarned']}') ,
          //     ),

          Padding(
              padding: const EdgeInsets.all(8.0),
              
              child: ElevatedButton(
                onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrailBlazerProfile()),
                );
                  
                },
                 child: Text('View TrailBlazer'),
                 ),
            ),    
          Padding(
            padding: const EdgeInsets.all(8.0),
              child:  ElevatedButton(
                onPressed: (){
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TrailBlazers()),
                  );
                },
                child: Text('Choose trailBlazer'),
            ),
          )
        ],
      ), 
    );
  }
