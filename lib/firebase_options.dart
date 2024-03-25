// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAI3tdM2wft_5dH1Z6OE2q2_0vOSP6-kk4',
    appId: '1:8475561867:web:00359480691ae278eae98e',
    messagingSenderId: '8475561867',
    projectId: 'gotrail-239ab',
    authDomain: 'gotrail-239ab.firebaseapp.com',
    storageBucket: 'gotrail-239ab.appspot.com',
    measurementId: 'G-GKETE2EEFS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCkNY6sC-qdk0kgXueCKVxonN0i4UWg_r4',
    appId: '1:8475561867:android:049de61bb5e9629deae98e',
    messagingSenderId: '8475561867',
    projectId: 'gotrail-239ab',
    storageBucket: 'gotrail-239ab.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDRwD4GWPm37lSpFUJ80G-5yPJd-v-YlU8',
    appId: '1:8475561867:ios:8d70a418f8fda79aeae98e',
    messagingSenderId: '8475561867',
    projectId: 'gotrail-239ab',
    storageBucket: 'gotrail-239ab.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );
}
