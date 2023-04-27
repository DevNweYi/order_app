import 'package:flutter/material.dart';

List dataList = [
  {
    "name": "MainMenu-1",
    "icon": Icons.menu,
    "subMenu": [
      {"name": "SubMenu-1/1"},
      {"name": "SubMenu-2/1"}
    ]
  },
  {
    "name": "MainMenu-2",
    "icon": Icons.menu,
    "subMenu": [
      {"name": "SubMenu-1/2"},
      {"name": "SubMenu-2/2"},
      {"name": "SubMenu-3/2"},
      {"name": "SubMenu-4/2"},
      {"name": "SubMenu-5/2"}
    ]
  }
];

class Menu {
  String? name;
  IconData? icon;
  List<Menu>? subMenu = [];

  Menu({this.name, this.subMenu, this.icon});

  Menu.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    icon = json['icon'];
    if (json['subMenu'] != null) {
      subMenu!.clear();
      json['subMenu'].forEach((v) {
        subMenu?.add(new Menu.fromJson(v));
      });
    }
  }
}
