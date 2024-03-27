import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';
import 'package:GoTrail/signin/signin.dart';
import 'package:GoTrail/signin/terms_conditions.dart';
import 'package:GoTrail/header_bar/header_bar.dart';

class AuthGate extends StatelessWidget {
 const AuthGate({super.key});

 @override
 Widget build(BuildContext context) {
   return StreamBuilder<User?>(
     stream: FirebaseAuth.instance.authStateChanges(),
     builder: (context, snapshot) {
  
       if (!snapshot.hasData) {
         return SignInScreen(
           providers: [
             EmailAuthProvider(),
           ],
           headerBuilder: header,
           subtitleBuilder: signin,
           footerBuilder: termsConditions,
         );
       }
       return const HomeScreen();
     },
   );
 }



}