import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:order_app/controller/otp_controller.dart';
import 'package:order_app/value/app_color.dart';
import 'package:order_app/view/new_password_page.dart';
import 'package:order_app/widget/regular_text.dart';
import 'package:order_app/widget/title_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apiservice.dart';
import '../controller/register_controller.dart';
import '../model/client_data.dart';
import '../value/app_setting.dart';
import '../value/app_string.dart';
import '../widget/small_text.dart';
import 'init_page.dart';

class OTPPage extends StatefulWidget {
  String phone;
  bool isForgetPassword;
  OTPPage({super.key, required this.phone, required this.isForgetPassword});

  @override
  State<OTPPage> createState() => _OTPPageState(phone, isForgetPassword);
}

class _OTPPageState extends State<OTPPage> {
  ApiService apiService = Get.find();
  var otp;
  var otpController = Get.put(OTPController());
  var registerController = Get.put(RegisterController());
  String phone;
  bool isForgetPassword;

  _OTPPageState(this.phone, this.isForgetPassword);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              TitleText(
                text: AppString.otp_verification.toUpperCase(),
                color: AppColor.primary_700,
                fontWeight: FontWeight.bold,
              ),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Image.asset("assets/images/otp.png"),
                          height: 150,
                          width: 150,
                        ),
                        SizedBox(
                          height: 70,
                        ),
                        SmallText(
                          text: AppString.otp_verification_message + phone,
                          textOverflow: TextOverflow.visible,
                          textAlign: TextAlign.center,
                          color: AppColor.blueGrey,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        OtpTextField(
                          mainAxisAlignment: MainAxisAlignment.center,
                          numberOfFields: 6,
                          onSubmit: (value) {
                            otp = value;
                            EasyLoading.show(status: AppString.loading);
                            OTPController.instance
                                .verifyOTP(otp)
                                .then((isVerified) {
                              if (isVerified) {
                                if (isForgetPassword == true) {
                                  EasyLoading.dismiss();
                                  Get.to(() => const NewPasswordPage());
                                } else {
                                  _insertClient();
                                }
                              } else {
                                EasyLoading.dismiss();
                                Get.back();
                              }
                            });
                          },
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (otp == null) return;
                            if (otp != null) {
                              EasyLoading.show(status: AppString.loading);
                              OTPController.instance
                                  .verifyOTP(otp)
                                  .then((isVerified) {
                                if (isVerified) {
                                  if (isForgetPassword == true) {
                                    EasyLoading.dismiss();
                                    Get.to(() => const NewPasswordPage());
                                  } else {
                                    _insertClient();
                                  }
                                } else {
                                  EasyLoading.dismiss();
                                  Get.back();
                                }
                              });
                            }
                          },
                          child: Container(
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 30),
                            padding: EdgeInsets.only(left: 20, right: 20),
                            width: 200,
                            alignment: Alignment.center,
                            height: 54,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [
                                    (AppColor.primary),
                                    (AppColor.primary_700)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const RegularText(
                              text: AppString.verify,
                              color: AppColor.white,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 60),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(AppString.donot_receive_code,
                                  style: Theme.of(context).textTheme.bodyText2),
                              InkWell(
                                onTap: () => {},
                                child: const SmallText(
                                    text: AppString.resend,
                                    color: AppColor.primary),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _insertClient() async{
    /* apiService
        .insertClient(ClientData(
            ClientID: 0,
            ClientName: registerController.name_controller.text,
            ClientPassword: "",
            ShopName: "",
            Phone: registerController.phone_controller.text,
            DivisionID: 1,
            TownshipID: 1,
            Address: "",
            IsSalePerson: false,
            DivisionName: "",
            TownshipName: "",
            Token: ""))
        .then((it) async { */
      /* if (it != 0) {
        apiService
            .updateClientPassword(
                it, registerController.password_controller.text)
            .then((value) async {
          EasyLoading.dismiss();
          Fluttertoast.showToast(msg: AppString.success); */
          SharedPreferences sharedPreferences =
               await SharedPreferences.getInstance();
          sharedPreferences.setBool("IsRegistered", true);
          sharedPreferences.setInt("UserID", 0);
          sharedPreferences.setString(
              "UserName", registerController.name_controller.text);
          sharedPreferences.setString(
              "UserPhone", registerController.phone_controller.text);

          AppSetting.getToken(registerController.phone_controller.text);
          AppSetting.saveUser(registerController.phone_controller.text,registerController.name_controller.text,registerController.password_controller.text);

          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return InitPage(clientId: 0);
          }), (route) => false);
       /*  });
      }  */
      /* else {
        EasyLoading.dismiss();
        Fluttertoast.showToast(msg: AppString.already_register_phone);
      } */
   /*  }).catchError((onError) {
      EasyLoading.dismiss();
      Fluttertoast.showToast(msg: onError.toString());
    }); */
  }
}
