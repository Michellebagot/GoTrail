import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth_gate.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyMedium: GoogleFonts.lexendDeca(),
          bodySmall: GoogleFonts.lexendDeca(),
          bodyLarge: GoogleFonts.lexendDeca(),
          displayLarge: GoogleFonts.lexendDeca(),
          displayMedium: GoogleFonts.lexendDeca(),
          displaySmall: GoogleFonts.lexendDeca(),
          labelLarge: GoogleFonts.lexendDeca(),
          labelMedium: GoogleFonts.lexendDeca(),
          labelSmall: GoogleFonts.lexendDeca(),
          titleLarge: GoogleFonts.lexendDeca(),
          titleMedium: GoogleFonts.lexendDeca(),
          titleSmall: GoogleFonts.lexendDeca(),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.blueGrey,
                width: 1,
              )),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.blueGrey,
                width: 1,
              )),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.blueGrey,
                width: 1,
              )),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            Color.fromRGBO(166, 159, 119, 1),
          ),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        )),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
          backgroundColor: Color.fromRGBO(255, 246, 222, 1),
          cardColor: Color.fromRGBO(166, 159, 119, 1),
          accentColor: Color.fromRGBO(166, 132, 119, 1),
        ),
      ),
      home: AuthGate(),
    );
  }
}
