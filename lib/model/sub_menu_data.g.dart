// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_menu_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubMenuData _$SubMenuDataFromJson(Map<String, dynamic> json) => SubMenuData(
      subMenuId: (json['SubMenuID'] as num).toInt(),
      subMenuName: json['SubMenuName'] as String,
    );

Map<String, dynamic> _$SubMenuDataToJson(SubMenuData instance) =>
    <String, dynamic>{
      'SubMenuID': instance.subMenuId,
      'SubMenuName': instance.subMenuName,
    };
