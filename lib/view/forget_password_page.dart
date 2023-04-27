import 'package:flutter/material.dart';
import 'package:order_app/value/app_color.dart';
import 'package:order_app/value/app_string.dart';
import 'package:order_app/widget/title_text.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary_700,
        title: TitleText(text: AppString.forget_password,
        color: Colors.white,),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/forgot.png"),
          SizedBox(height: 100,),
          Center(
            child: Text(AppString.forget_password_verify_message,
              style: Theme.of(context).textTheme.bodyText1),
          ),
          SizedBox(height: 70,),
          ElevatedButton(
                onPressed: () {
                  
                },
                child: Text(AppString.send),
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.only(left: 40,right: 40,top:20,bottom: 20))))
        ],
      ),
    );
  }
}