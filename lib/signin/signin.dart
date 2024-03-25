import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

Widget signin(context, action) {
     return Padding(
       padding: const EdgeInsets.symmetric(vertical: 8.0),
       child: action == AuthAction.signIn
           ? const Text('Welcome to GoTrail, please sign in!')
           : const Text('Welcome to GoTrail, please sign up!'),
     );
   }