import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

  MaterialPageRoute<ProfileScreen> profilePage() {
    return MaterialPageRoute<ProfileScreen>(
                builder: (context) => ProfileScreen(
                  appBar: AppBar(
                    title: const Text('User Profile'),
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
                        // child: Image.asset('flutterfire_300x.png'),
                      ),
                    ),
                  ],
                ),
              );
  }
