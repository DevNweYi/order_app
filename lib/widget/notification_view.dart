import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:order_app/widget/small_text.dart';

import '../value/app_color.dart';
import '../view/notification_page.dart';

class NotificationView extends StatefulWidget {
  int count, clientId;
  NotificationView({super.key, required this.clientId, required this.count});

  @override
  State<NotificationView> createState() =>
      _NotificationViewState(clientId, count);
}

class _NotificationViewState extends State<NotificationView> {
  int count, clientId;

  _NotificationViewState(this.clientId, this.count);

  @override
  Widget build(BuildContext context) {
    return count != 0
        ? badge.Badge(
            badgeContent: SmallText(
              text: count.toString(),
              color: AppColor.white,
            ),
            badgeColor: AppColor.accent,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NotificationPage(
                          clientId: clientId,
                        )));
              },
              icon: const Icon(Icons.notifications),
              color: AppColor.white,
            ),
          )
        : IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => NotificationPage(
                        clientId: clientId,
                      )));
            },
            icon: const Icon(Icons.notifications),
            color: AppColor.white,
          );
  }
}
