import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:order_app/api/apiservice.dart';
import 'package:order_app/value/locale_string.dart';
import 'package:order_app/view/login_page.dart';
import 'package:dio/dio.dart';
import 'package:order_app/view/register_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  bool? isRegistered = sharedPreferences.getBool("IsRegistered");
  bool isDark=false;
  if(sharedPreferences.getBool("IsDark") != null && sharedPreferences.getBool("IsDark") == true){
      isDark=true;
  }

  runApp(MyApp(
    isRegistered: isRegistered,
    isDark: isDark,
  ));
}

class MyApp extends StatelessWidget {
  bool? isRegistered;
  bool isDark;

  MyApp({super.key, required this.isRegistered,required this.isDark});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Dio dio = Dio();
    ApiService apiService = ApiService(dio);
    Get.put(apiService);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: LocaleString(),
      locale: const Locale('en','US'),
      title: 'Flutter Demo',
      theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
          //canvasColor: Colors.blue,
          brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: isDark? ThemeMode.dark : ThemeMode.light,
      home: AnimatedSplashScreen(
        splash: 'assets/icons/launcher.png',
        nextScreen: isRegistered == null || isRegistered == false
            ? const RegisterPage()
            : LoginPage(
                isSaveToken: false,
              ),
        splashTransition: SplashTransition.fadeTransition,
      ),
      builder: EasyLoading.init(),
    );
  }
}
