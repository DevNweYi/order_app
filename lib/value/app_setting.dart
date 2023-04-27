import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';

class AppSetting{
  static var formatter = NumberFormat('#,##,000');

  static String getTodayDate(){
    DateTime now=DateTime.now();
    String date=DateFormat.yMMMMd().format(now);
    return date;
  }

  static String getFilterDate(){  //dd/mm/yyyy
    DateTime now=DateTime.now();
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    String date=formatter.format(now);
    return date;
  }

  static void getToken(String phone) async{
    await FirebaseMessaging.instance.getToken().then((token) {
        saveToken(phone,token!);
    });
  }

  static void saveToken(String phone,String token) async{
      await FirebaseFirestore.instance.collection("UserTokens").doc(phone).set({
        'token':token
      });
  }

}