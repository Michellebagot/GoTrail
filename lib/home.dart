import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/profile/profile_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        automaticallyImplyLeading: false,
      ),
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


}