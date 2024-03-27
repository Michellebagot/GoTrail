import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget header(context, constraints, shrinkOffset) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Scaffold(
      appBar: AppBar(
          title: Text("GoTrail", style: GoogleFonts.balooBhaina2()),
          toolbarHeight: 50,
          backgroundColor: Color.fromRGBO(166, 132, 119, 1)),
    ),
  );
}
