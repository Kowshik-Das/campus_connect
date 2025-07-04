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
    apiKey: 'AIzaSyDDFIOCeA_eydcx571g4ErppBR8NQcZwv4',
    appId: '1:365650123442:web:8c0d92bfe20b019e0e47ab',
    messagingSenderId: '365650123442',
    projectId: 'campus-connect-3ae17',
    authDomain: 'campus-connect-3ae17.firebaseapp.com',
    storageBucket: 'campus-connect-3ae17.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC_LwjH7_zCzjNJuWGbfjUkx8y0N3zNOmQ',
    appId: '1:365650123442:android:3399bda6cf0a06000e47ab',
    messagingSenderId: '365650123442',
    projectId: 'campus-connect-3ae17',
    storageBucket: 'campus-connect-3ae17.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBTak_33MKBlqGlSIiq4wKCyZQhA1T2Ymo',
    appId: '1:365650123442:ios:c5b4e2f13eb9aec80e47ab',
    messagingSenderId: '365650123442',
    projectId: 'campus-connect-3ae17',
    storageBucket: 'campus-connect-3ae17.firebasestorage.app',
    iosBundleId: 'com.example.campusConnect',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBTak_33MKBlqGlSIiq4wKCyZQhA1T2Ymo',
    appId: '1:365650123442:ios:c5b4e2f13eb9aec80e47ab',
    messagingSenderId: '365650123442',
    projectId: 'campus-connect-3ae17',
    storageBucket: 'campus-connect-3ae17.firebasestorage.app',
    iosBundleId: 'com.example.campusConnect',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDDFIOCeA_eydcx571g4ErppBR8NQcZwv4',
    appId: '1:365650123442:web:1f5718003acb60530e47ab',
    messagingSenderId: '365650123442',
    projectId: 'campus-connect-3ae17',
    authDomain: 'campus-connect-3ae17.firebaseapp.com',
    storageBucket: 'campus-connect-3ae17.firebasestorage.app',
  );
}
