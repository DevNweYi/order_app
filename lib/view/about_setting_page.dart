import 'package:flutter/material.dart';

import '../value/app_color.dart';
import '../value/app_string.dart';
import '../widget/title_text.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutSettingPage extends StatefulWidget {
  const AboutSettingPage({super.key});

  @override
  State<AboutSettingPage> createState() => _AboutSettingPageState();
}

class _AboutSettingPageState extends State<AboutSettingPage> {

  final Uri _url = Uri.parse('https://github.com/DevNweYi');
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: AppColor.primary_700,
            title: const TitleText(
              text: AppString.about,
              color: AppColor.white,
            )),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 50,),
              Container(
                child: Image.asset("assets/images/girl.png"),
                height: 300,
                width: 300,
              ),
              SizedBox(height: 20,),
              Text("Hello!",style:Theme.of(context).textTheme.headline5),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset("assets/images/github.png"),
                    height: 30,
                    width: 30,
                  ),
                  SizedBox(width: 10,),
                  TextButton(
                    onPressed: (){
                      _launchUrl();
                    },
                    child: Text("https://github.com/DevNweYi",style:Theme.of(context).textTheme.bodyText1),
                  )
                ],
              )
            ],
          ),
        ),
    );
  }

  Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
}