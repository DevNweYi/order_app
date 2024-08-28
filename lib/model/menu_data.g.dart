// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuData _$MenuDataFromJson(Map<String, dynamic> json) => MenuData(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      subMenu: (json['subMenu'] as List<dynamic>?)
          ?.map((e) => MenuData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MenuDataToJson(MenuData instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'subMenu': instance.subMenu,
    };
