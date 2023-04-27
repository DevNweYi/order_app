import 'package:get/get.dart';

class NotificationController extends GetxController{
  static Rx<int> notificationCount=0.obs;

  void setNotificationCount(int count){
    notificationCount.value=count;
  }
}