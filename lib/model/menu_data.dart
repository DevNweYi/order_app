import 'package:json_annotation/json_annotation.dart';
part 'menu_data.g.dart';

@JsonSerializable()
class MenuData {
  int? id;
  String? name;
  List<MenuData>? subMenu = [];

  MenuData({this.id,this.name, this.subMenu});

  factory MenuData.fromJson(Map<String, dynamic> json) => _$MenuDataFromJson(json);
  Map<String, dynamic> toJson() => _$MenuDataToJson(this);
}