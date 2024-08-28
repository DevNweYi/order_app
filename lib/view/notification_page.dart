import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:order_app/value/app_string.dart';
import 'package:order_app/widget/title_text.dart';

import '../api/apiservice.dart';
import '../model/notification_data.dart';
import '../value/app_color.dart';
import '../widget/regular_text.dart';

class NotificationPage extends StatefulWidget {
  final int clientId;
  const NotificationPage({super.key, required this.clientId});

  @override
  State<NotificationPage> createState() => _NotificationPageState(clientId);
}

class _NotificationPageState extends State<NotificationPage> {
  ApiService apiService = Get.find();
  final int clientId;
  bool isNotificationRead = false;

  _NotificationPageState(this.clientId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColor.primary_700,
          title: const TitleText(
            text: AppString.notification,
            color: AppColor.white,
          )),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                  onPressed: () {
                    EasyLoading.show(status: AppString.loading);
                    /* apiService.deleteAllNotification(clientId).then((value) {
                      EasyLoading.dismiss();
                      setState(() {
                        isNotificationRead = true;
                      });
                    }); */
                  },
                  child: Text(AppString.mark_all_read)),
            ),
          ),
          !isNotificationRead
              ? Expanded(child: _emptyNotification()
                  /* FutureBuilder<List<NotificationData>>(
                      future: apiService.getNotification(clientId, false),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.isNotEmpty) {
                            return _showNotification(snapshot.data!);
                          } else {
                            return _emptyNotification();
                          }
                        } else if (snapshot.hasError) {
                          return RegularText(text: snapshot.error.toString());
                        }
                        return const Center(child: CircularProgressIndicator());
                      })*/
                  )
              : Container()
        ],
      ),
    );
  }

  Widget _showNotification(List<NotificationData> lstNotification) {
    return ListView.builder(
        itemCount: lstNotification.length,
        itemBuilder: (context, index) {
          NotificationData data = lstNotification[index];
          return Column(
            children: [
              ListTile(
                leading: data.NotiType == 1
                    ? Icon(
                        Icons.new_label_rounded,
                        color: AppColor.primary,
                      )
                    : Icon(
                        Icons.info_rounded,
                        color: AppColor.accent,
                      ),
                title: Text(data.NotiMessage),
                subtitle: Text(data.NotiDateTime),
              ),
              Divider()
            ],
          );
        });
  }

  Widget _emptyNotification() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/noalarm.png"),
        SizedBox(
          height: 20,
        ),
        Text(AppString.no_notification,
            style: Theme.of(context).textTheme.headline6),
        SizedBox(
          height: 50,
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppString.back_product),
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                backgroundColor: MaterialStateProperty.all(AppColor.white),
                foregroundColor: MaterialStateProperty.all(AppColor.primary))),
      ],
    );
  }
}
