// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationData _$NotificationDataFromJson(Map<String, dynamic> json) =>
    NotificationData(
      NotiType: (json['NotiType'] as num).toInt(),
      NotiID: (json['NotiID'] as num).toInt(),
      NotiMessage: json['NotiMessage'] as String,
      NotiDateTime: json['NotiDateTime'] as String,
    );

Map<String, dynamic> _$NotificationDataToJson(NotificationData instance) =>
    <String, dynamic>{
      'NotiType': instance.NotiType,
      'NotiID': instance.NotiID,
      'NotiMessage': instance.NotiMessage,
      'NotiDateTime': instance.NotiDateTime,
    };
