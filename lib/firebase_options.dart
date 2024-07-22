// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyBFGM_dbG2EZIBhqcqNl3uiu8WRvLxl-Ag',
    appId: '1:432474904178:web:9474154b845a5d3559d4eb',
    messagingSenderId: '432474904178',
    projectId: 'git-gud-f001b',
    authDomain: 'git-gud-f001b.firebaseapp.com',
    storageBucket: 'git-gud-f001b.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyABZWErSOniIudiqhFobu5Zelj-32jBvXM',
    appId: '1:432474904178:android:75e74e363b6f380059d4eb',
    messagingSenderId: '432474904178',
    projectId: 'git-gud-f001b',
    storageBucket: 'git-gud-f001b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAlfFLfRtRAdRCwVZ5Q1q-kBzGxg_p9sA4',
    appId: '1:432474904178:ios:e8c6fc87368fad7b59d4eb',
    messagingSenderId: '432474904178',
    projectId: 'git-gud-f001b',
    storageBucket: 'git-gud-f001b.appspot.com',
    iosBundleId: 'com.example.frontend',
  );

}