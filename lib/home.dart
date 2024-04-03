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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapPage()),
                  );
                },
                child: Text("Go to Map View",
                style: TextStyle(
                  color: Colors.black,
                ),
                )
             ),

            // Trail search button
            ElevatedButton(
                onPressed: () {
                  print("hello");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                },
                child: Text("Search Trails",
                style: TextStyle(
                  color: Colors.black,
                ),
                )
           ),
            const SignOutButton(),
          ],
        ),
      ),
    );
  }
}
