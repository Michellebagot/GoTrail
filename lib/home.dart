import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:GoTrail/header_bar/header_bar.dart';
import 'package:GoTrail/trail_search/trail_search.dart';
import 'package:GoTrail/map_view/map_page.dart';
import 'package:GoTrail/tips/tips.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
      backgroundColor: Color.fromRGBO(255, 246, 222, 1),
      body: Center(
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

            Text(
              'This is the Home Screen of the App!',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            RandomTip(),
            
            ElevatedButton(
                onPressed: () {
                  signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  );
                },
                child: Text("Sign Out",
                style: TextStyle(
                  color: Colors.black,
                ),
                )
           ),
          ],
        ),
      ),
    );
  }
}
