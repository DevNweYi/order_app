import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:order_app/controller/register_controller.dart';
import 'package:order_app/value/app_color.dart';
import 'package:order_app/view/login_page.dart';
import 'package:order_app/view/otp_page.dart';

import '../api/apiservice.dart';
import '../network/network_connectivity.dart';
import '../value/app_string.dart';
import '../widget/regular_text.dart';
import '../widget/small_text.dart';
import '../widget/title_text.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  ApiService apiService = Get.find();
  var registerController = Get.put(RegisterController());

  Map _event = {ConnectivityResult.none: false};
  final NetworkConnectivity _networkConnectivity = NetworkConnectivity.instance;
  String connMessage = '';
  final _controller = StreamController.broadcast();

  @override
  void initState() {
    requestPermission();
    super.initState();

    _networkConnectivity.initialize(_controller);
    _networkConnectivity.myStream.listen((event) {
      _event = event;
    
      switch (_event.keys.toList()[0]) {
        case ConnectivityResult.mobile:
          connMessage='';
          break;
        case ConnectivityResult.wifi:
          connMessage='';
          break;
        case ConnectivityResult.none:
        default:
          connMessage = 'No Internet Connection';
      }

      setState(() {});

      if (connMessage.length != 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: TitleText(text: connMessage,),
            backgroundColor:AppColor.accent
        ));
      }
    });
  }

  void requestPermission() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User declined or has not accepted permission");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      child: Image.asset("assets/icons/launcher.png"),
                      height: 90,
                      width: 90,
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 20, top: 20),
                      alignment: Alignment.bottomRight,
                      child: RegularText(
                        text: AppString.register,
                        color: AppColor.grey_300,
                      ),
                    )
                  ]),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 50),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColor.grey_200,
            ),
            alignment: Alignment.center,
            child: TextField(
              textInputAction: TextInputAction.next,
              controller: registerController.name_controller,
              style: TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.person,
                    color: AppColor.primary,
                  ),
                  hintText: AppString.enter_name,
                  hintStyle: TextStyle(color: Colors.black45),
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
            ),
            alignment: Alignment.center,
            child: TextField(
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              controller: registerController.phone_controller,
              style: TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.phone,
                    color: AppColor.primary,
                  ),
                  hintText: AppString.enter_phone,
                  hintStyle: TextStyle(color: Colors.black45),
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
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: registerController.password_controller,
              textInputAction: TextInputAction.next,
              obscureText: true,
              style: TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.vpn_key,
                    color: AppColor.primary,
                  ),
                  hintText: AppString.enter_password,
                  hintStyle: TextStyle(color: Colors.black45),
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
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: registerController.confirm_password_controller,
              textInputAction: TextInputAction.done,
              obscureText: true,
              style: TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.vpn_key,
                    color: AppColor.primary,
                  ),
                  hintText: AppString.enter_confirm_password,
                  hintStyle: TextStyle(color: Colors.black45),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none),
            ),
          ),
          InkWell(
            onTap: () => {
              if (_isValidateControl())
                {
                  EasyLoading.show(status: AppString.loading),
                  apiService
                      .checkClientByPhone(
                          registerController.phone_controller.text.trim())
                      .then((clientData) {
                    //EasyLoading.dismiss();
                    if (clientData.ClientID == 0) {
                      RegisterController.instance.phoneAuthentication(
                          "+95${registerController.phone_controller.text.trim()}");
                      Get.to(() => OTPPage(
                            phone: registerController.phone_controller.text,isForgetPassword: false,
                          ));
                    } else {
                      EasyLoading.dismiss();
                      Fluttertoast.showToast(
                          msg: AppString.already_register_phone);
                    }
                  })
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
              ),
              child: RegularText(
                text: AppString.register,
                color: AppColor.white,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppString.already_have_account,
                    style: Theme.of(context).textTheme.bodyText2),
                InkWell(
                  onTap: () => {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginPage(
                                  isSaveToken: true,
                                )))
                  },
                  child: SmallText(
                    text: AppString.login_now,
                    color: AppColor.primary,
                  ),
                )
              ],
            ),
          )
        ],
      )),
    );
  }

  @override
  void dispose() {
    _networkConnectivity.disposeStream();
    super.dispose();
  }

  bool _isValidateControl() {
    if (registerController.name_controller.text.isEmpty) {
      Fluttertoast.showToast(msg: AppString.enter_name);
      return false;
    } else if (registerController.phone_controller.text.isEmpty) {
      Fluttertoast.showToast(msg: AppString.enter_phone);
      return false;
    } else if (registerController.password_controller.text.isEmpty) {
      Fluttertoast.showToast(msg: AppString.enter_password);
      return false;
    } else if (registerController.confirm_password_controller.text.isEmpty) {
      Fluttertoast.showToast(msg: AppString.enter_confirm_password);
      return false;
    } else if (registerController.password_controller.text !=
        registerController.confirm_password_controller.text) {
      Fluttertoast.showToast(msg: AppString.password_not_match);
      return false;
    }
    return true;
  }
}
