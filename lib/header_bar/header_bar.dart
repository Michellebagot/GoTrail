import 'package:GoTrail/profile/profile_page.dart';
import 'package:GoTrail/profile/trail_blazer_profile.dart';
import 'package:GoTrail/trail_blazer_options.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:GoTrail/home.dart';
import 'package:GoTrail/map_view/map_page.dart';
import 'package:GoTrail/trail_search/trail_search.dart';

PreferredSizeWidget header(
    BuildContext context, BoxConstraints constraints, double shrinkOffset) {
  return AppBar(
    title: GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      },
      child: Center(
        child: Text(
          'GoTrail',
          style: GoogleFonts.balooBhaina2(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
    leading: Builder(
      builder: (BuildContext context) {
        if (ModalRoute.of(context)?.canPop ?? false) {
          return IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          );
        } else {
          return IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          );
        }
      },
    ),
    toolbarHeight: constraints.maxHeight,
    backgroundColor: Color.fromRGBO(166, 132, 119, 1),
    actions: [
      if (FirebaseAuth.instance.currentUser != null)
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var trailBlazer = snapshot.data!['trailBlazer'];
              if (trailBlazer == null || trailBlazer == '') {
                return IconButton(
                  icon: const Icon(Icons.pets),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrailBlazers(),
                      ),
                    );
                  },
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.local_fire_department_outlined),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrailBlazerProfile(),
                      ),
                    );
                  },
                );
              }
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      if (FirebaseAuth.instance.currentUser != null)
        IconButton(
          icon: const Icon(Icons.map),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MapPage(),
              ),
            );
          },
        ),
      if (FirebaseAuth.instance.currentUser != null)
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SearchPage(),
              ),
            );
          },
        ),
      if (FirebaseAuth.instance.currentUser != null)
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ),
            );
          },
        ),
    ],
  );
}
