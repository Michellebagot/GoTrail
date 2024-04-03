import 'package:GoTrail/auth_gate.dart';
import 'package:GoTrail/header_bar/header_bar.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:GoTrail/profile/trail_blazer_profile.dart';
import 'package:GoTrail/trail_blazer_options.dart';

TextStyle titleStyle = TextStyle(
  fontFamily: GoogleFonts.balooBhaina2().fontFamily,
  fontWeight: FontWeight.bold,
  fontSize: 24, //TODO update this for more appropriate size later - MB
  color: Colors.black,
  decoration: TextDecoration.none,
);

TextStyle bodyStyle = TextStyle(
  fontFamily: GoogleFonts.lexendDeca().fontFamily,
  fontWeight: FontWeight.normal,
  fontSize: 18, //TODO update this for more appropriate size later - MB
  color: Colors.black,
  decoration: TextDecoration.none,
);

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String selectedImage = 'assets/profileImages/placeholder.jpg';
  late String userId;
  late FirebaseFirestore firestore;
  late FirebaseAuth auth;
  late String userName = '';
  late int pointsEarned = 0;
  late bool trailBlazerOwner = true;
  late String trailBlazerName = '';
  late String trailBlazer = '';

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
    firestore = FirebaseFirestore.instance;
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = auth.currentUser;
    if (user != null) {
      userId = user.uid;
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await firestore.collection('users').doc(userId).get();
      if (snapshot.exists) {
        setState(() {
          selectedImage = snapshot.data()?['avatarUrl'] == ''
              ? 'assets/profileImages/placeholder.jpg'
              : snapshot.data()?['avatarUrl'] ??
                  'assets/profileImages/placeholder.jpg';
          userName = snapshot.data()?['name'] ?? 'User';
          pointsEarned = snapshot.data()?['pointsEarned'] ?? 0;
          trailBlazerOwner = snapshot.data()?[true] ?? false;
          trailBlazerName = snapshot.data()?['trailBlazerName'] ?? '';
          trailBlazer = snapshot.data()?['trailBlazer'] ?? '';
        });
      }
    }
  }

  Future<void> updateUserAvatarUrl(String newAvatarUrl) async {
    await firestore.collection('users').doc(userId).update({
      'avatarUrl': newAvatarUrl,
    });
  }

  void updateUserDisplayName(String newName) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && newName.isNotEmpty) {
      user.updateDisplayName(newName).then((_) {
        firestore.collection('users').doc(userId).update({
          'name': newName,
        });
      }).catchError((error) {
        print('Error updating display name: $error');
      });
    }
  }

  void avatarChange() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select an Avatar', style: bodyStyle),
          content: SizedBox(
            width: 300,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              children: [
                for (var hikerImage in [
                  'assets/profileImages/hiker1.jpg',
                  'assets/profileImages/hiker2.jpg',
                  'assets/profileImages/hiker3.jpg',
                  'assets/profileImages/hiker4.jpg',
                  'assets/profileImages/hiker5.jpg',
                  'assets/profileImages/hiker6.jpg'
                ])
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedImage = hikerImage;
                      });
                      updateUserAvatarUrl(hikerImage);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipOval(
                        child: Image.asset(
                          hikerImage,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void accountDetailsChange() {
    String newName = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Your Name', style: bodyStyle),
          content: TextField(
            onChanged: (value) {
              setState(() {
                newName = value;
              });
            },
            decoration: InputDecoration(hintText: 'Enter your new name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                updateUserDisplayName(newName);
                setState(() {
                  userName = newName;
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
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
      body: Center(
        child: Column(
          children: [
            Text(
              "Hey $userName! Welcome to your Profile",
            ),
            SizedBox(
              width: 300,
              child: Container(
                padding: EdgeInsets.all(10.0),
                child: ClipOval(
                  child: Image.asset(
                    selectedImage,
                  ),
                ),
              ),
            ),
            Text("Points Earned: $pointsEarned"),
            ElevatedButton(
              onPressed: avatarChange,
              child: Text("Change your Avatar",
              style: TextStyle(
                  color: Colors.black,
                ),
                ),
            ),
            ElevatedButton(
              onPressed: accountDetailsChange,
              child: Text("Change your Account Details",                
              style: TextStyle(
                  color: Colors.black,
                ),
                ),
            ),
            if (trailBlazerName != '')
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TrailBlazerProfile()),
                  );
                },
                child: Text('View TrailBlazer',                 
                style: TextStyle(
                  color: Colors.black,
                ),
                ),
              ),
            if (trailBlazerName == '')
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TrailBlazers()),
                  );
                },
                child: Text('Choose trailBlazer',                 
                style: TextStyle(
                  color: Colors.black,
                ),),
              ),
          ],
        ),
      ),
    );
  }
}
