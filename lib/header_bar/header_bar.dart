import 'package:GoTrail/profile/profile_page_mb.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:GoTrail/home.dart';
import 'package:GoTrail/map_view/map_page.dart';
import 'package:GoTrail/trail_search/trail_search.dart';

PreferredSizeWidget header(BuildContext context, BoxConstraints constraints, double shrinkOffset) {
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
    toolbarHeight: 50,
    backgroundColor: Color.fromRGBO(166, 132, 119, 1),
    actions: [
      if (FirebaseAuth.instance.currentUser != null) IconButton(
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
      if (FirebaseAuth.instance.currentUser != null) IconButton(
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
      if (FirebaseAuth.instance.currentUser != null) IconButton(
        icon: const Icon(Icons.person),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePageMB(),
            ),
          );
        },
      ),
    ],
  );
}
