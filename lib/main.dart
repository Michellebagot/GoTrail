import 'package:flutter/material.dart';
import './map_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'api/firebase_options.dart';
import 'app.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
 );

 runApp(const MyApp());

}
