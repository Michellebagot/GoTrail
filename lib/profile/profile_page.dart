import 'package:GoTrail/trail_blazer_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';



  MaterialPageRoute<ProfileScreen> profilePage() {
     //getting uid if user is 
    if (FirebaseAuth.instance.currentUser != null) {
    var db = FirebaseFirestore.instance;
    var userRef = db.collection("users").doc(FirebaseAuth.instance.currentUser?.uid);

     Map<String, dynamic> userData;
     userRef.get().then((doc) => {
          if (!doc.exists){
              userData = <String, dynamic>{
            "name": FirebaseAuth.instance.currentUser?.displayName,
            "pointsEarned": 0,
            "email": FirebaseAuth.instance.currentUser?.email,

            },

          db.collection("users")
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .set(userData, SetOptions(merge: true))
              .onError((e, _) => print("Error writing document: $e"))
        
        
       
          }
     }
     );
    }
  
    return MaterialPageRoute<ProfileScreen>(
      
      builder: (context) => ProfileScreen(
        appBar: AppBar(
          title: const Text('User Profile'),
        ),
      
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(2),
            child: AspectRatio(
              aspectRatio: 1,
              child:  ElevatedButton(
                onPressed: (){
                  Navigator.push(
                  context,
                  
                  MaterialPageRoute(builder: (context) => TrailBlazers()),
                );
  
                },
                child: Text('Choose trailBlazer'),
            ),
          ),
          )
  



        ],
      ),
      
      
    );
  }
