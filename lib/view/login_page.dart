import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:order_app/value/app_color.dart';
import 'package:order_app/value/app_setting.dart';
import 'package:order_app/value/app_string.dart';
import 'package:order_app/view/forget_password_page.dart';
import 'package:order_app/view/register_page.dart';
import 'package:order_app/view/init_page.dart';
import 'package:order_app/widget/regular_text.dart';
import 'package:order_app/widget/small_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apiservice.dart';

class LoginPage extends StatefulWidget {
  bool isSaveToken;
  LoginPage({super.key, required this.isSaveToken});

  @override
  State<LoginPage> createState() => _LoginPageState(isSaveToken);
}

class _LoginPageState extends State<LoginPage> {
  bool isSaveToken;
  _LoginPageState(this.isSaveToken);

  ApiService apiService = Get.find();
  TextEditingController phone_controller = new TextEditingController();
  TextEditingController password_controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    phone_controller.text = "09784314734";
    password_controller.text = "111";
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
                        text: AppString.login,
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
              textInputAction: TextInputAction.done,
              controller: password_controller,
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
            margin: EdgeInsets.only(top: 20, right: 20),
            alignment: Alignment.centerRight,
            child: GestureDetector(
              child: SmallText(
                text: AppString.forget_password,
                color: AppColor.blueGrey,
              ),
              onTap: (() {
                Get.to(()=>ForgetPasswordPage());
              }),
            ),
          ),
          InkWell(
            onTap: () => {
              if (_isValidateControl())
                {
                  EasyLoading.show(status: AppString.loading),
                  apiService
                      .checkClient(phone_controller.text, false)
                      .then((it) async {
                    EasyLoading.dismiss();
                    if (it.ClientID == 0) {
                      Fluttertoast.showToast(msg: AppString.not_fount_data);
                    } else {
                      if (it.ClientPassword == password_controller.text) {
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.setBool("IsRegistered", true);
                        sharedPreferences.setInt("UserID", it.ClientID);
                        sharedPreferences.setString(
                            "UserName", it.ClientName.toString());
                        sharedPreferences.setString(
                            "UserPhone", it.Phone.toString());
                        sharedPreferences.setString(
                            "UserAddress", it.Address.toString());

                        if (isSaveToken) {
                          AppSetting.getToken(it.Phone.toString());
                        }

                        Navigator.pushReplacement(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => InitPage(
                                      clientId: it.ClientID,
                                    )));
                      } else {
                        Fluttertoast.showToast(
                            msg: AppString.incorrect_password);
                      }
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
                text: AppString.login,
                color: AppColor.white,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppString.donot_have_account,
                    style: Theme.of(context).textTheme.bodyText2),
                InkWell(
                  onTap: () => {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => RegisterPage()))
                  },
                  child: SmallText(
                    text: AppString.register_now,
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

  bool _isValidateControl() {
    if (phone_controller.text.isEmpty) {
      Fluttertoast.showToast(msg: AppString.enter_phone);
      return false;
    } else if (password_controller.text.isEmpty) {
      Fluttertoast.showToast(msg: AppString.enter_password);
      return false;
    }
    return true;
  }
}
