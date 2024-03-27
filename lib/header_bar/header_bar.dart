import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:GoTrail/profile/profile_page.dart';
import 'package:GoTrail/home.dart';

Widget header(context, constraints, shrinkOffset) {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  return SizedBox(
      height: constraints.maxHeight,
      child: Padding(
        padding: const EdgeInsets.all(0.1),
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                scaffoldKey.currentState?.openDrawer();
              },
            ),
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
                    profilePage(),
                  );
                },
              )
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text('menu header'),
                ),
                ListTile(
                  title: Text('item 1'),
                  onTap: () {
                    print("tapped item 1");
                  },
                ),
              ],
            ),
          ),
        ),
      ));
}
