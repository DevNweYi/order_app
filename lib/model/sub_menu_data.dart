import 'package:json_annotation/json_annotation.dart';
part 'sub_menu_data.g.dart';

@JsonSerializable()
class SubMenuData {

  @JsonKey(name:"SubMenuID")
  int subMenuId;
  @JsonKey(name:"SubMenuName")
  String subMenuName;

  SubMenuData({required this.subMenuId,required this.subMenuName});

  factory SubMenuData.fromJson(Map<String, dynamic> json) => _$SubMenuDataFromJson(json);
  Map<String, dynamic> toJson() => _$SubMenuDataToJson(this);
}