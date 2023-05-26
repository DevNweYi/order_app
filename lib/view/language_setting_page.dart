import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../value/app_color.dart';
import '../value/app_string.dart';
import '../widget/title_text.dart';

class LanguageSettingPage extends StatefulWidget {
  LanguageSettingPage({super.key});

  @override
  State<LanguageSettingPage> createState() => _LanguageSettingPageState();
}

class _LanguageSettingPageState extends State<LanguageSettingPage> {
  
  List locale = [
    {'name': 'English', 'locale': Locale('en', 'US'), 'isSelected': true},
    {'name': 'Myanmar', 'locale': Locale('my', 'MM'), 'isSelected': false},
  ];

  updateLanguage(Locale locale) {
    Get.updateLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: AppColor.primary_700,
            title: TitleText(
              text: 'change_language'.tr,
              color: AppColor.white,
            )),
        body: FutureBuilder<String?>(
          future: getLanguage(),
          builder: (context, snapshot) {
            if (snapshot.data == "Myanmar") {
              locale = [
                {
                  'name': 'English',
                  'locale': Locale('en', 'US'),
                  'isSelected': false
                },
                {
                  'name': 'Myanmar',
                  'locale': Locale('my', 'MM'),
                  'isSelected': true
                },
              ];
            } else {
              locale = [
                {
                  'name': 'English',
                  'locale': Locale('en', 'US'),
                  'isSelected': true
                },
                {
                  'name': 'Myanmar',
                  'locale': Locale('my', 'MM'),
                  'isSelected': false
                },
              ];
            }
            return ListView.builder(
                itemCount: locale.length,
                itemBuilder: (BuildContext context, int index) {
                  bool isSelected = locale[index]['isSelected'];
                  return Card(
                    child: ListTile(
                      title: Text(locale[index]['name']),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check,
                              color: AppColor.accent,
                            )
                          : null,
                      onTap: () async {
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.setString(
                            "Language", locale[index]['name']);
                        updateLanguage(locale[index]['locale']);
                        setState(() {
                          if (index == 0) {
                            locale = [
                              {
                                'name': 'English',
                                'locale': Locale('en', 'US'),
                                'isSelected': true
                              },
                              {
                                'name': 'Myanmar',
                                'locale': Locale('my', 'MM'),
                                'isSelected': false
                              },
                            ];
                          } else if (index == 1) {
                            locale = [
                              {
                                'name': 'English',
                                'locale': Locale('en', 'US'),
                                'isSelected': false
                              },
                              {
                                'name': 'Myanmar',
                                'locale': Locale('my', 'MM'),
                                'isSelected': true
                              },
                            ];
                          }
                        });
                      },
                    ),
                  );
                });
          },
        ));
  }

  Future<String?> getLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("Language");
  }
}
