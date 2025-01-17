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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyD7stS3RQPAZq60bfgLZftd2vzpcGSjLdE',
    appId: '1:990204355214:web:1631fd328c57cd907d5fdf',
    messagingSenderId: '990204355214',
    projectId: 'prod-beta-a049d',
    authDomain: 'prod-beta-a049d.firebaseapp.com',
    storageBucket: 'prod-beta-a049d.appspot.com',
    measurementId: 'G-D85F9SX5RP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAvGFYiIKY208qHQM79xYyiMPrk3EBzWF8',
    appId: '1:990204355214:android:0e4e9c05c42eb78f7d5fdf',
    messagingSenderId: '990204355214',
    projectId: 'prod-beta-a049d',
    storageBucket: 'prod-beta-a049d.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCFC61B9PpkWz7nEP49sQv5D2MJ_OSbstU',
    appId: '1:990204355214:ios:692fbb059b2f94547d5fdf',
    messagingSenderId: '990204355214',
    projectId: 'prod-beta-a049d',
    storageBucket: 'prod-beta-a049d.appspot.com',
    iosBundleId: 'com.example.soundscape',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCFC61B9PpkWz7nEP49sQv5D2MJ_OSbstU',
    appId: '1:990204355214:ios:692fbb059b2f94547d5fdf',
    messagingSenderId: '990204355214',
    projectId: 'prod-beta-a049d',
    storageBucket: 'prod-beta-a049d.appspot.com',
    iosBundleId: 'com.example.soundscape',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD7stS3RQPAZq60bfgLZftd2vzpcGSjLdE',
    appId: '1:990204355214:web:16925233577b077f7d5fdf',
    messagingSenderId: '990204355214',
    projectId: 'prod-beta-a049d',
    authDomain: 'prod-beta-a049d.firebaseapp.com',
    storageBucket: 'prod-beta-a049d.appspot.com',
    measurementId: 'G-49L09CSJXT',
  );
}
