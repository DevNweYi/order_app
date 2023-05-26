import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' as scheduler;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:order_app/api/apiservice.dart';
import 'package:order_app/database/database_helper.dart';
import 'package:order_app/model/product_data.dart';
import 'package:order_app/view/main_page.dart';

import '../controller/product_controller.dart';
import '../value/app_color.dart';
import '../value/app_string.dart';
import '../widget/regular_text.dart';
import 'xnotification/notification_info_page.dart';

class InitPage extends StatefulWidget {
  final int clientId;
  const InitPage({super.key, required this.clientId});

  @override
  State<InitPage> createState() => _InitPageState(clientId);
}

class _InitPageState extends State<InitPage> {
  final int clientId;
  ApiService apiService = Get.find();
  final ProductController productController = Get.put(ProductController());

  _InitPageState(this.clientId);

  @override
  void initState() {
    DatabaseHelper().deleteAllProduct();
    requestPermission();
    initInfo();
    super.initState();
  }

  void requestPermission() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User declined or has not accepted permission");
    }
  }

  void initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationsSettings,
        onDidReceiveNotificationResponse: (details) {
      try {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return NotificationInfoPage(info: details.payload.toString());
        }));
      } catch (e) {}
      return;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("....................onMessage...................");
      print(
          "onMessage:${message.notification?.title}/${message.notification?.body}");

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );

      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails('dborder', 'dborder',
              importance: Importance.high,
              styleInformation: bigTextStyleInformation,
              priority: Priority.high,
              playSound: true);

      NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: const DarwinNotificationDetails());
      await flutterLocalNotificationsPlugin.show(0, message.notification!.title,
          message.notification!.body, platformChannelSpecifics,
          payload: message.data['body']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ProductData>>(
          future: apiService.getProduct(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ProductData> lstProduct = snapshot.data!;
              for (int i = 0; i < lstProduct.length; i++) {
                DatabaseHelper().insertProduct(ProductData.insertProduct(
                    ProductID: lstProduct[i].ProductID,
                    SubMenuID: lstProduct[i].SubMenuID,
                    SalePrice: lstProduct[i].SalePrice,
                    Code: lstProduct[i].Code,
                    ProductName: lstProduct[i].ProductName,
                    Description: lstProduct[i].Description,
                    PhotoUrl: lstProduct[i].PhotoUrl));
              }
              scheduler.SchedulerBinding.instance
                  .addPostFrameCallback((timeStamp) {
                Navigator.pushReplacement(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => MainPage(
                              clientId: clientId,
                              currentIndex: 0,
                              subMenuId: 0,
                              subMenu: 'ALL',
                            )));
              });
            } else if (snapshot.hasError) {
              return RegularText(text: snapshot.error.toString());
            }
            return const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
