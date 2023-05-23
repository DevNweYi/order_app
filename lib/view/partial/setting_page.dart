import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order_app/view/noti_setting_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../value/app_color.dart';
import '../../value/app_string.dart';
import '../../widget/regular_text.dart';
import '../../widget/small_text.dart';
import '../about_setting_page.dart';
import '../help_setting_page.dart';
import '../language_setting_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 30,
            ),
            Text('setting'.tr,
                style: Theme.of(context).textTheme.headline5),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Text('account'.tr,
                      style: Theme.of(context).textTheme.subtitle1),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const CircleAvatar(
                          backgroundColor: Color(0xFFE3F2FD),
                          child: Icon(
                            Icons.person_rounded,
                            color: Colors.blue,
                          )),
                      Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<String>(
                                future: getUserName(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(snapshot.data!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1);
                                  } else if (snapshot.hasError) {
                                    return RegularText(
                                        text: snapshot.error.toString());
                                  }
                                  return const Center(
                                      child: CircularProgressIndicator());
                                },
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              FutureBuilder<String>(
                                future: getUserPhone(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(snapshot.data!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2);
                                  } else if (snapshot.hasError) {
                                    return SmallText(
                                        text: snapshot.error.toString());
                                  }
                                  return const Center(
                                      child: CircularProgressIndicator());
                                },
                              ),
                            ],
                          ))
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 25, bottom: 30),
                    height: 1,
                    color: AppColor.grey_100,
                  ),
                  Text('setting'.tr,
                      style: Theme.of(context).textTheme.subtitle1),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                              backgroundColor: Color(0xFFFFF3E0),
                              child: Icon(
                                Icons.language,
                                color: Colors.orange,
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          Text('language'.tr,
                              style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                      Row(
                        children: [
                          FutureBuilder<String?>(
                            future: getLanguage(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(snapshot.data!,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2);
                              } else if (snapshot.hasError) {
                                return SmallText(
                                    text: snapshot.error.toString());
                              }
                              return Text('English',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2);
                            },
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_right),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LanguageSettingPage()));
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                              backgroundColor: Color(0xFFE0F7FA),
                              child: Icon(
                                Icons.notifications,
                                color: Colors.cyan,
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          Text(AppString.notification,
                              style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_right),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const NotiSettingPage()));
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                                backgroundColor: Color(0xFFEDE7F6),
                                child: Icon(
                                  Icons.dark_mode,
                                  color: Colors.deepPurple,
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            Text(AppString.dark_mode,
                                style: Theme.of(context).textTheme.bodyText1),
                          ],
                        ),
                        FutureBuilder<bool>(
                            future: getIsDark(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                isSwitched = snapshot.data!;
                                return Switch(
                                  value: isSwitched,
                                  onChanged: (value) {
                                    setState(() {
                                      isSwitched = value;
                                    });
                                    setTheme(value);
                                    if (value) {
                                      Get.changeTheme(ThemeData.dark());
                                    } else {
                                      Get.changeTheme(ThemeData.light());
                                    }
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return SmallText(
                                    text: snapshot.error.toString());
                              }
                              return const Center(
                                  child: CircularProgressIndicator());
                            })
                      ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                              backgroundColor: Color(0xFFE1F5FE),
                              child: Icon(
                                Icons.help,
                                color: Colors.lightBlue,
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          Text('help'.tr,
                              style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_right),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const HelpSettingPage()));
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                              backgroundColor: Color(0xFFFFFDE7),
                              child: Icon(
                                Icons.info,
                                color: Colors.yellow,
                              )),
                          SizedBox(
                            width: 20,
                          ),
                          Text(AppString.about,
                              style: Theme.of(context).textTheme.bodyText1),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_right),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AboutSettingPage()));
                        },
                      )
                    ],
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    ));
  }

  Future<String> getUserName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("UserName").toString();
  }

  Future<String> getUserPhone() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("UserPhone").toString();
  }

  Future<bool> getIsDark() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool? isDark = sharedPreferences.getBool("IsDark");
    if (isDark == null) {
      return false;
    } else {
      if (isDark) {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<void> setTheme(value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("IsDark", value);
  }

  Future<String?> getLanguage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("Language");
  }
}
