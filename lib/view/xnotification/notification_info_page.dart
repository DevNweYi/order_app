import 'package:flutter/material.dart';

class NotificationInfoPage extends StatefulWidget {
  String info;
  NotificationInfoPage({super.key,required this.info});

  @override
  State<NotificationInfoPage> createState() => _NotificationInfoPageState(info);
}

class _NotificationInfoPageState extends State<NotificationInfoPage> {
  String info;

  _NotificationInfoPageState(this.info);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Center(
          child: Text(info),
        ),
    );
  }
}