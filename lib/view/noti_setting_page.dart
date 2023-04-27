import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../value/app_color.dart';
import '../value/app_string.dart';
import '../widget/small_text.dart';
import '../widget/title_text.dart';

class NotiSettingPage extends StatefulWidget {
  const NotiSettingPage({super.key});

  @override
  State<NotiSettingPage> createState() => _NotiSettingPageState();
}

class _NotiSettingPageState extends State<NotiSettingPage> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColor.primary_700,
          title: const TitleText(
            text: AppString.notification,
            color: AppColor.white,
          )),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListTile(
            title: const Text(AppString.notification),
            subtitle: const Text(AppString.notification_on_message),
            trailing: Container(
              width: 100,
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FutureBuilder<bool>(
                      future: getIsNotificationOn(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          isSwitched = snapshot.data!;
                          return Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                              });
                              setNotificationOnOff(value);
                            },
                          );
                        } else if (snapshot.hasError) {
                          return SmallText(text: snapshot.error.toString());
                        }
                        return const Center(child: CircularProgressIndicator());
                      }),
                ],
              ),
            )),
      ),
    );
  }

  Future<void> setNotificationOnOff(value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("IsNotificationOn", value);
  }

  Future<bool> getIsNotificationOn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? isNotificationOn = sharedPreferences.getBool("IsNotificationOn");
    if (isNotificationOn == null) {
      return true;
    } else {
      if (isNotificationOn) {
        return true;
      } else {
        return false;
      }
    }
  }
}
