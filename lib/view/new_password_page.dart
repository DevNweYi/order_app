import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:order_app/view/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apiservice.dart';
import '../value/app_color.dart';
import '../value/app_string.dart';
import '../widget/regular_text.dart';
import '../widget/title_text.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  TextEditingController confirm_password_controller =
      new TextEditingController();
  TextEditingController password_controller = new TextEditingController();
  ApiService apiService = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColor.primary_700,
        title: TitleText(
          text: AppString.create_new_password,
          color: Colors.white,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/lock.png"),
          SizedBox(
            height: 80,
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: AppColor.grey_200,
            ),
            alignment: Alignment.center,
            child: TextField(
              controller: password_controller,
              textInputAction: TextInputAction.next,
              obscureText: true,
              style: TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.vpn_key,
                    color: AppColor.primary,
                  ),
                  hintText: AppString.enter_new_password,
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
              controller: confirm_password_controller,
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
          GestureDetector(
            onTap: () {
              if (_isValidateControl()) {
                EasyLoading.show(status: AppString.loading);
                getUserID().then((value) {
                  value ??= 0;
                  apiService
                      .updateClientPassword(value, password_controller.text)
                      .then((value) async {
                    EasyLoading.dismiss();
                    Fluttertoast.showToast(msg: AppString.success);

                    Navigator.pushAndRemoveUntil(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return LoginPage(
                        isSaveToken: false,
                      );
                    }), (route) => false);
                  });
                });
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
                text: AppString.save,
                color: AppColor.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isValidateControl() {
    if (password_controller.text.isEmpty) {
      Fluttertoast.showToast(msg: AppString.enter_new_password);
      return false;
    } else if (confirm_password_controller.text.isEmpty) {
      Fluttertoast.showToast(msg: AppString.enter_confirm_password);
      return false;
    } else if (password_controller.text != confirm_password_controller.text) {
      Fluttertoast.showToast(msg: AppString.password_not_match);
      return false;
    }
    return true;
  }
}

Future<int?> getUserID() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getInt("UserID");
}
