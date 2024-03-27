import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:GoTrail/home.dart';
import 'package:GoTrail/map_view/map_page.dart';
import 'package:GoTrail/trail_search/trail_search.dart';

  MaterialPageRoute<ProfileScreen> profilePage() {
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
                  actions: [
                    SignedOutAction((context) {
                      Navigator.of(context).pop();
                    })
                  ],
                  children: [
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: AspectRatio(
                        aspectRatio: 1,
                      ),
                    ),
                  ],
                ),
              );
  }
