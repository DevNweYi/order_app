import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../value/app_color.dart';
import '../../value/app_string.dart';
import '../../widget/regular_text.dart';
import '../../widget/small_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PushNotificationPage extends StatefulWidget {
  const PushNotificationPage({super.key});

  @override
  State<PushNotificationPage> createState() => _PushNotificationPageState();
}

class _PushNotificationPageState extends State<PushNotificationPage> {

  TextEditingController user_controller = new TextEditingController();
  TextEditingController title_controller = new TextEditingController();
  TextEditingController body_controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      body: SingleChildScrollView(
          child: Column(
        children: [
          Container(
            height: 300,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(90)),
                color: AppColor.primary,
                gradient: LinearGradient(
                    colors: [(AppColor.primary), (AppColor.primary_700)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 50),
                      child: Image.asset("assets/images/logo.png"),
                      height: 120,
                      width: 120,
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 20, top: 20),
                      alignment: Alignment.bottomRight,
                      child: RegularText(
                        text: AppString.notification,
                        color: AppColor.grey_300,
                      ),
                    )
                  ]),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 70),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColor.grey_200,
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: AppColor.grey_200)
                ]),
            alignment: Alignment.center,
            child: TextField(
              textInputAction: TextInputAction.next,            
              controller: user_controller,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.person,
                    color: AppColor.primary,
                  ),
                  hintText: AppString.enter_name,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColor.grey_200,
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: AppColor.grey_200)
                ]),
            alignment: Alignment.center,
            child: TextField(
              textInputAction: TextInputAction.next,
              controller: title_controller,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.title,
                    color: AppColor.primary,
                  ),
                  hintText: AppString.enter_title,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: AppColor.grey_200,
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: AppColor.grey_200)
                ]),
            alignment: Alignment.center,
            child: TextField(
              textInputAction: TextInputAction.done,
              controller: body_controller,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.message,
                    color: AppColor.primary,
                  ),
                  hintText: AppString.enter_body,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none),
            ),
          ),
          InkWell(
            onTap: () async {
              String userName=user_controller.text.trim();
              String titleText=title_controller.text;
              String bodyText=body_controller.text;

              if(userName!=""){
                DocumentSnapshot snap=await FirebaseFirestore.instance.collection("UserTokens").doc(userName).get();
                String token=snap['token'];             
                sendPushMessage(token,bodyText,titleText);
              }
            },
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 60),
              padding: EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.center,
              height: 54,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [(AppColor.primary), (AppColor.primary_700)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 50,
                        color: AppColor.grey_200)
                  ]),
              child: RegularText(
                text: AppString.push_notification,
                color: AppColor.white,
              ),
            ),
          ),
        ],
      )),
    );
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
}