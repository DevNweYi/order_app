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
        return macos;
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
    apiKey: 'AIzaSyCpuuyo4Wd6lsinYJiMsSld-yLC5z0xorg',
    appId: '1:24676314742:web:d137865b508b3c5c92b957',
    messagingSenderId: '24676314742',
    projectId: 'orderapp-72528',
    authDomain: 'orderapp-72528.firebaseapp.com',
    storageBucket: 'orderapp-72528.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCQNecv23DDmkgRxv6-O7QvIGf5jHYJyhk',
    appId: '1:24676314742:android:d69204b34ebe922992b957',
    messagingSenderId: '24676314742',
    projectId: 'orderapp-72528',
    storageBucket: 'orderapp-72528.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDJWVxs0wSTL3Ut7oH639DlipemtgqgExI',
    appId: '1:24676314742:ios:746e38e28e12528d92b957',
    messagingSenderId: '24676314742',
    projectId: 'orderapp-72528',
    storageBucket: 'orderapp-72528.appspot.com',
    androidClientId: '24676314742-dn0d0qtsoe6eldq19ue41j4k9dfrpt97.apps.googleusercontent.com',
    iosClientId: '24676314742-hsqcd8qcdgotnf9kuugkj5oaucitcv0f.apps.googleusercontent.com',
    iosBundleId: 'com.example.orderApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDJWVxs0wSTL3Ut7oH639DlipemtgqgExI',
    appId: '1:24676314742:ios:746e38e28e12528d92b957',
    messagingSenderId: '24676314742',
    projectId: 'orderapp-72528',
    storageBucket: 'orderapp-72528.appspot.com',
    androidClientId: '24676314742-dn0d0qtsoe6eldq19ue41j4k9dfrpt97.apps.googleusercontent.com',
    iosClientId: '24676314742-hsqcd8qcdgotnf9kuugkj5oaucitcv0f.apps.googleusercontent.com',
    iosBundleId: 'com.example.orderApp',
  );
}
