import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';

class AppSetting {
  // static var formatter = NumberFormat('#,##,000');
  static var formatter = NumberFormat.decimalPattern('en_us');

  static String getTodayDate() {
    DateTime now = DateTime.now();
    String date = DateFormat.yMMMMd().format(now);
    return date;
  }

  static String getFilterDate() {
    //dd/mm/yyyy
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    String date = formatter.format(now);
    return date;
  }

  static void getToken(String phone) async {
    await FirebaseMessaging.instance.getToken().then((token) {
      saveToken(phone, token!);
    });
  }

  static void saveToken(String phone, String token) async {
    await FirebaseFirestore.instance
        .collection("UserTokens")
        .doc(phone)
        .set({'token': token});
  }

  static void saveUser(String phone, String name, String password) async {
    await FirebaseFirestore.instance
        .collection("UserTokens")
        .doc(phone)
        .set({'name': name, 'password': password});
  }

  static void updatePassword(String phone, String password) async {
    await FirebaseFirestore.instance
        .collection("UserTokens")
        .doc(phone)
        .set({'password': password});
  }

  static Future<bool> checkUser(String phone, String password) async {
    Future<bool> result = false as Future<bool>;
    final snapshot = await FirebaseFirestore.instance
        .collection('UserTokens')
        .doc(phone)
        .get();

    if (snapshot.exists) {
      String pw = snapshot.get('password');

      if (pw == password) {
        result = Future.value(true);
      }
    }
    return result;
  }

  static Future<String> getName(String phone) async {
    Future<String> name = "" as Future<String>;
    final snapshot = await FirebaseFirestore.instance
        .collection("UserTokens")
        .doc(phone)
        .get();

    if (snapshot.exists) {
      name = snapshot.get('name');
    }
    return name;
  }
}
