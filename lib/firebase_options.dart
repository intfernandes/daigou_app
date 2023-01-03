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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAVCeaIbNaXro_c3dCXbQmQXGdiMrBaypA',
    appId: '1:521370548270:android:dfaaf4a63687120eb047bf',
    messagingSenderId: '521370548270',
    projectId: 'jiyun-app-1df62',
    databaseURL: 'https://jiyun-app-1df62-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'jiyun-app-1df62.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD4c_mfGDiagF4T2jrRqOYUL9B9RO91rmY',
    appId: '1:521370548270:ios:f6c4734b8d314f96b047bf',
    messagingSenderId: '521370548270',
    projectId: 'jiyun-app-1df62',
    databaseURL: 'https://jiyun-app-1df62-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'jiyun-app-1df62.appspot.com',
    androidClientId: '521370548270-f0tdas0lllp048vci57h6q2fvohgipaq.apps.googleusercontent.com',
    iosClientId: '521370548270-9i9f4jn0grjubmo75epl9ulb14q80vbb.apps.googleusercontent.com',
    iosBundleId: 'com.zhongha.jiyunAppClient',
  );
}
