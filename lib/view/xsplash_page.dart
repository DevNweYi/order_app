//import 'dart:html';

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:order_app/value/app_color.dart';
import 'package:order_app/view/xnotification/notification_info_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  String? mToken="";
  TextEditingController username=new TextEditingController();
  TextEditingController title=new TextEditingController();
  TextEditingController body=new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
    getToken();
    initInfo();
  }

  void requestPermission() async {
      FirebaseMessaging firebaseMessaging=FirebaseMessaging.instance;

      NotificationSettings settings=await firebaseMessaging.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
      );

      if(settings.authorizationStatus == AuthorizationStatus.authorized){
        print("User granted permission");
      }else if(settings.authorizationStatus == AuthorizationStatus.provisional){
        print("User granted provisional permission");
      }else{
        print("User declined or has not accepted permission");
      }
  }

  void getToken() async{
    await FirebaseMessaging.instance.getToken().then((token) {
        setState(() {
          mToken=token;
          print("My token is $mToken");
        });
        saveToken(token!);
    });
  }

  void saveToken(String token) async{
      await FirebaseFirestore.instance.collection("UserTokens").doc("User3").set({
        'token':token
      });
  }

  void initInfo(){
      var androidInitialize=const AndroidInitializationSettings("@mipmap/ic_launcher");
      var iOSInitialize=const DarwinInitializationSettings();
      var initializationsSettings=InitializationSettings(android: androidInitialize,iOS: iOSInitialize);
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin=FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.initialize(initializationsSettings,onDidReceiveNotificationResponse: (details) {
        try{
            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                return NotificationInfoPage(info: details.payload.toString());
            }));
        }catch(e){

        }
        return;
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async { 
          print("....................onMessage...................");
          print("onMessage:${message.notification?.title}/${message.notification?.body}");

          BigTextStyleInformation bigTextStyleInformation =BigTextStyleInformation(
            message.notification!.body.toString(),htmlFormatBigText: true,
            contentTitle: message.notification!.title.toString(),htmlFormatContentTitle: true,
          );

          AndroidNotificationDetails androidPlatformChannelSpecifics= AndroidNotificationDetails(
            'dborder', 'dborder',importance: Importance.high,styleInformation: bigTextStyleInformation,
            priority: Priority.high,playSound: true);

          NotificationDetails platformChannelSpecifics=NotificationDetails(android: androidPlatformChannelSpecifics,
            iOS: const DarwinNotificationDetails());
          await flutterLocalNotificationsPlugin.show(0, message.notification!.title, message.notification!.body, 
            platformChannelSpecifics,payload: message.data['body']);
      });
  }

  void sendPushMessage(String token,String body,String title) async{
      try{
          await http.post(
            Uri.parse("https://fcm.googleapis.com/fcm/send"),
            headers: <String,String>{
                'Content-Type': 'application/json',
                'Authorization': 'key=AAAABb7SrnY:APA91bFVv__D17Lv3oD4SZhF67xoOLJUQVmPRONVWvBm4415r3bkRKe8cG3JLkDwh8NNGw1kRXWBOPcXe4CkMoDnn3KZK4wLTbykags4zYjSek9KoRUNZ1uB7ZvIGYkpMaSsRdGHuwDh'
            },
            body: jsonEncode(<String,dynamic>{
              'priority':'high',
              'data':<String,dynamic>{
                'click_action':'FLUTTER_NOTIFICATION_CLICK',
                'status':'done',
                'body':body,
                'title':title
              },

              "notification":<String,dynamic>{
                "title":title,
                "body":body,
                "android_channel_id":"dborder",
              },
              "to":token,
            })
          );
      }catch(e){
          if(kDebugMode){
            print("error push notification");
          }
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                TextFormField(
                    controller: username,
                ),
                TextFormField(
                    controller: title,
                ),
                TextFormField(
                    controller: body,
                ),
                GestureDetector(
                  onTap: () async {
                    String name=username.text.trim();
                    String titleText=title.text;
                    String bodyText=body.text;

                    if(name!=""){
                      DocumentSnapshot snap=await FirebaseFirestore.instance.collection("UserTokens").doc(name).get();
                      String token=snap['token'];
                      print(token);

                      sendPushMessage(token,bodyText,titleText);
                    }
                  },
                  child: Container(
                    child: Text("button"),
                    margin: EdgeInsets.all(20),
                    height: 40,
                    width: 200,
                      decoration: BoxDecoration(

                      ),
                  ),
                )
            ],
          ),
        ),
    );
  }
}