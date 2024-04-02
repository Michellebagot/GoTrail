import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:GoTrail/header_bar/header_bar.dart';
import 'package:GoTrail/trail_search/trail_search.dart';
import 'package:GoTrail/profile/profile_page%20old.dart';
import 'package:GoTrail/map_view/map_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:GoTrail/tips/tips.dart';

import 'package:GoTrail/profile/profile_page.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                child: Text("go to map view")),

            // Trail search button
            ElevatedButton(
                onPressed: () {
                  print("hello");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                },
                child: Text("Search trails")),
            const SignOutButton(),
          ],
        ),
      ),
    );
  }
}
