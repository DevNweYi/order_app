import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:order_app/value/app_color.dart';
import 'package:order_app/value/app_string.dart';
import 'package:order_app/widget/title_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:order_app/controller/register_controller.dart';
import 'package:get/get.dart';
import 'package:order_app/view/otp_page.dart';

import '../widget/regular_text.dart';
import '../widget/small_text.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  TextEditingController phone_controller = TextEditingController();
  var registerController = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary_700,
        title: TitleText(
          text: AppString.forget_password,
          color: Colors.white,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/forgot.png"),
          SizedBox(
            height: 80,
          ),
          Center(
            child: Text(AppString.forget_password_verify_message,
                style: Theme.of(context).textTheme.bodyText1),
          ),
          FutureBuilder<String>(
            future: getUserPhone(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                phone_controller.text = snapshot.data!;
                return Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColor.grey_200,
                  ),
                  alignment: Alignment.center,
                  child: TextField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    controller: phone_controller,
                    style: TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.phone,
                        color: AppColor.primary,
                      ),
                      hintText: AppString.enter_phone,
                      hintStyle: TextStyle(color: Colors.black45),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return SmallText(text: snapshot.error.toString());
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
          GestureDetector(
            onTap: () {
              if (_isValidateControl()) {
                EasyLoading.show(status: AppString.loading);
                RegisterController.instance
                    .phoneAuthentication("+95${phone_controller.text}");
                Get.to(() => OTPPage(
                      phone: phone_controller.text,
                      isForgetPassword: true,
                    ));
              }
            },
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 50),
              padding: EdgeInsets.only(left: 20, right: 20),
              width: 200,
              alignment: Alignment.center,
              height: 54,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [(AppColor.primary), (AppColor.primary_700)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const RegularText(
                text: AppString.send,
                color: AppColor.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isValidateControl() {
    if (phone_controller.text.isEmpty) {
      Fluttertoast.showToast(msg: AppString.enter_phone);
      return false;
    }
    return true;
  }
}

Future<String> getUserPhone() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString("UserPhone").toString();
}
