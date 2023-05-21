import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order_app/value/app_color.dart';
import 'package:order_app/view/partial/home_page.dart';
import 'package:order_app/view/partial/order_page.dart';
import 'package:order_app/view/partial/product_page.dart';
import 'package:order_app/view/partial/setting_page.dart';

import '../value/app_string.dart';

class MainPage extends StatefulWidget {
  final int clientId;
  final int currentIndex;
  final int subMenuId;
  final String subMenu;
  MainPage(
      {super.key,
      required this.clientId,
      required this.currentIndex,
      required this.subMenuId,
      required this.subMenu});

  @override
  State<MainPage> createState() =>
      _MainPageState(clientId, currentIndex, subMenuId, subMenu);
}

class _MainPageState extends State<MainPage> {
  final int clientId;
  int _currentIndex;
  int _subMenuId;
  String _subMenu;

  _MainPageState(
      this.clientId, this._currentIndex, this._subMenuId, this._subMenu);

  List<Widget> _partial = [];

  @override
  void initState() {
    _partial = [
      HomePage(
        clientId: clientId,
      ),
      ProductPage(
        clientId: clientId,
        subMenuId: _subMenuId,
        subMenu: _subMenu,
      ),
      OrderPage(clientId: clientId),
      SettingPage()
    ];
    super.initState();
  }

  void onNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    //print("current height is "+MediaQuery.of(context).size.height.toString());
    return Scaffold(
      body: _partial[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
        canvasColor: Colors.amber[700]),
        child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: onNavTapped,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home), label: 'home'.tr),
              BottomNavigationBarItem(
                  icon: Icon(Icons.view_in_ar), label: 'product'.tr),
              BottomNavigationBarItem(
                  icon: Icon(Icons.list_alt), label: 'order'.tr),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'setting'.tr),
            ]),
      ),
    );
  }
}
