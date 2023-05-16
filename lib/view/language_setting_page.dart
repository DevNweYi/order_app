import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../value/app_color.dart';
import '../value/app_string.dart';
import '../widget/title_text.dart';

class LanguageSettingPage extends StatelessWidget {
  LanguageSettingPage({super.key});

  final List locale=[
    {'name':'English','locale':Locale('en','US')},
    {'name':'Myanmar','locale':Locale('my','MM')},
  ];

  updateLanguage(Locale locale){
    Get.updateLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColor.primary_700,
          title: const TitleText(
            text: AppString.language,
            color: AppColor.white,
          )),
        body: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  child: Text(locale[index]['name']),onTap: () {
                    updateLanguage(locale[index]['locale']);
                  },
                ),
              );
            },
            separatorBuilder:(context, index) {
              return const Divider(
                color: AppColor.blueGrey,
              );
            },
            itemCount: locale.length,
          ),
        ),
    );
  }
}