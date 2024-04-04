import 'package:flutter/material.dart';
import 'package:GoTrail/header_bar/header_bar.dart';
import 'package:GoTrail/tips/tips.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:GoTrail/auth_gate.dart';
import 'package:GoTrail/trail_widget_homepage/trail_widget_homepage.dart';
import 'package:share_plus/share_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool userExists = false;

  @override
  void initState() {
    super.initState();
    checkUserProfile();
  }

  Future<void> checkUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final documentReference =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      final documentSnapshot = await documentReference.get();

      if (!documentSnapshot.exists) {
        await documentReference.set({
          'email': user.email,
          'avatarUrl': '',
          'name': '',
          'pointsEarned': 0,
          'trailBlazer': '',
          'trailBlazerName': '',
        });
      }
    }
  }

  Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
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
                  0),
              Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                ),
                child: Text(
                  'Step Into Adventure',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              RandomTip(),
        
              TrailWidget(),
              // ElevatedButton(onPressed: ()=>Share.share('check out my website https://example.com', subject: 'Look what I made!'), child: null,),
              Container(
                margin: EdgeInsets.all(15),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => AuthGate()),
                      );
                      signOut();
                    },
                    child: Text("Sign Out",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    )
                             ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
