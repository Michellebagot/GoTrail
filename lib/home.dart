import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:GoTrail/profile/profile_page.dart';
import 'package:google_fonts/google_fonts.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 246, 222, 1),
       appBar: appBarMethod(context),
      body: Center(
        child: Column(
          children: [
            // Image.asset('dash.png'),
            Text(
              'This is the Home Screen of the App!',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SignOutButton(),
          ],
        ),
      ),
    );
  }

  AppBar appBarMethod(BuildContext context) {
    return AppBar( // TODO : need to extract this and replace with header_bar 
          leading: Icon(Icons.menu),
          title: Text('GoTrail',
          style: GoogleFonts.balooBhaina2(fontWeight: FontWeight.bold,),
          
          ),
          toolbarHeight: 50,
          backgroundColor: Color.fromRGBO(166, 132, 119, 1),
           actions: [
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
        );
  }


}