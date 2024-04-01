import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:GoTrail/profile/profile_page.dart';
import 'package:GoTrail/home.dart';
import 'package:GoTrail/profile/profile_page_mb.dart';

Widget header(context, constraints, shrinkOffset) {
  return SizedBox(
    height: constraints.maxHeight,
    width: constraints.maxWidth,
    child: Padding(
      padding: const EdgeInsets.all(0.1),
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.menu),
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
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  // profilePage(),
                  ProfilePageMB() as Route<Object?>,
                );
              },
            )
          ],
        ),
      ),
    ),
  );
}
