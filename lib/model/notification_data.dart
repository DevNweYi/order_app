import 'dart:ffi';

import "package:json_annotation/json_annotation.dart";
part 'notification_data.g.dart';

@JsonSerializable()
class NotificationData{
  int NotiType;
  int NotiID;
  String NotiMessage;
  String NotiDateTime;

  NotificationData({required this.NotiType,required this.NotiID,required this.NotiMessage,required this.NotiDateTime});

  factory NotificationData.fromJson(Map<String, dynamic> json) => _$NotificationDataFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);

}