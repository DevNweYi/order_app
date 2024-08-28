import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:order_app/widget/notification_view.dart';
import 'package:order_app/widget/regular_text.dart';
import 'package:order_app/widget/small_text.dart';
import 'package:order_app/widget/title_text.dart';

import '../controller/notification_controller.dart';
import '../controller/product_controller.dart';
import '../database/database_helper.dart';
import '../value/app_color.dart';
import '../view/cart_page.dart';

class ActionBarView extends StatefulWidget {
  int clientId;
  String pageTitle;

  ActionBarView({super.key, required this.clientId, required this.pageTitle});

  @override
  State<ActionBarView> createState() =>
      _ActionBarViewState(clientId, pageTitle);
}

class _ActionBarViewState extends State<ActionBarView> {
  int clientId;
  String pageTitle;

  _ActionBarViewState(this.clientId, this.pageTitle);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.primary_700,
      elevation: 8.0,
      child: Container(
        padding: const EdgeInsets.all(6.0),
        margin: EdgeInsets.only(right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TitleText(text: pageTitle, color: AppColor.white),
            Row(children: [
              FutureBuilder<int>(
                  future: DatabaseHelper().getTotalCartItem(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      ProductController.totalCartItems.value = snapshot.data!;
                      return Obx(() => ProductController.totalCartItems.value !=
                              0
                          ? badges.Badge(
                              badgeContent: Obx(() => SmallText(
                                    text: ProductController.totalCartItems.value
                                        .toString(),
                                    color: AppColor.white,
                                  )),
                              badgeColor: AppColor.accent,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const CartPage()));
                                },
                                icon: const Icon(Icons.shopping_cart),
                                color: AppColor.white,
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const CartPage()));
                              },
                              icon: const Icon(Icons.shopping_cart),
                              color: AppColor.white,
                            ));
                    } else if (snapshot.hasError) {
                      return RegularText(text: snapshot.error.toString());
                    }
                    return const Center(child: CircularProgressIndicator());
                  }),
              NotificationView(
                  clientId: clientId,
                  count: NotificationController.notificationCount.value)
            ])
          ],
        ),
      ),
    );
  }
}
