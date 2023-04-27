import 'package:flutter/material.dart';
import 'package:order_app/view/issue_receive_page.dart';

import '../value/app_color.dart';
import '../value/app_string.dart';
import '../widget/title_text.dart';

class HelpSettingPage extends StatefulWidget {
  const HelpSettingPage({super.key});

  @override
  State<HelpSettingPage> createState() => _HelpSettingPageState();
}

class _HelpSettingPageState extends State<HelpSettingPage> {
  TextEditingController text_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
            backgroundColor: AppColor.primary_700,
            title: const TitleText(
              text: AppString.help,
              color: AppColor.white,
            )),
        body: Column(
          children: [
            SizedBox(height: 50,),
            Container(
              child: Image.asset("assets/icons/launcher.png"),
              height: 90,
              width: 90,
            ),
            SizedBox(height: 50,),
            const TitleText(
              text: AppString.help_title,
              color: AppColor.primary_700,
              fontWeight: FontWeight.bold,
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 40),
              padding: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.grey_200,
              ),
              alignment: Alignment.center,
              child: TextField(
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                controller: text_controller,
                style: TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.message,
                    color: AppColor.primary,
                  ),
                  hintText: AppString.describe_your_issue,
                  hintStyle: TextStyle(color: Colors.black45),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 50,),
            ElevatedButton(
                onPressed: () {
                  if(_isValidateControl()){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => IssueReceivePage()));
                  }
                },
                child: Text(AppString.send),
                style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.only(left: 40,right: 40,top:20,bottom: 20))))
          ],
        ));
  }

   bool _isValidateControl() {
    if (text_controller.text.isEmpty) {
      return false;
    } 
    return true;
  }
}
