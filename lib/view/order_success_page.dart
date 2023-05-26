import 'package:flutter/material.dart';
import 'package:order_app/value/app_color.dart';
import 'package:order_app/view/main_page.dart';
import 'package:order_app/widget/regular_text.dart';
import 'package:order_app/widget/small_text.dart';
import 'package:order_app/widget/title_text.dart';
import 'package:get/get.dart';

import '../value/app_setting.dart';
import '../value/app_string.dart';

class OrderSuccessPage extends StatefulWidget {
  final int clientId;
  final String orderNumber;
  final int totalAmount;
  const OrderSuccessPage(
      {super.key,
      required this.clientId,
      required this.orderNumber,
      required this.totalAmount});

  @override
  State<OrderSuccessPage> createState() =>
      _OrderSuccessPageState(clientId, orderNumber, totalAmount);
}

class _OrderSuccessPageState extends State<OrderSuccessPage> {
  final int clientId;
  final String orderNumber;
  final int totalAmount;
  _OrderSuccessPageState(this.clientId, this.orderNumber, this.totalAmount);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.primary_50,
        body: SafeArea(
          child: Column(children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Center(
                      child: TitleText(
                    text: AppString.thank_you,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                    size: 30,
                  )),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.all(20),
                          padding: EdgeInsets.all(25),
                          color: AppColor.white,
                          child: Column(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: AppColor.primary,
                                size: 60,
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RegularText(
                                      text: 'order_date'.tr,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                  RegularText(
                                    text: AppSetting.getTodayDate(),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15, bottom: 15),
                                height: 1,
                                color: AppColor.grey_50,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RegularText(
                                      text: 'order_no'.tr,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                  RegularText(
                                      text: "#$orderNumber",
                                      fontWeight: FontWeight.bold),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 15, bottom: 15),
                                height: 1,
                                color: AppColor.grey_50,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RegularText(
                                      text: 'total_amount'.tr,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                  totalAmount.toString().length > 3
                                      ? RegularText(
                                          text: AppSetting.formatter
                                              .format(totalAmount)
                                              .toString(),
                                          fontWeight: FontWeight.bold)
                                      : RegularText(
                                          text: totalAmount.toString(),
                                          fontWeight: FontWeight.bold)
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin:
                              EdgeInsets.only(left: 20, right: 20, bottom: 30),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size.fromHeight(50),
                                  backgroundColor: AppColor.white,
                                  foregroundColor: AppColor.primary,
                                  elevation: 0),
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) {
                                  return MainPage(
                                    clientId: clientId,
                                    currentIndex: 2,
                                    subMenuId: 0,
                                    subMenu: 'ALL',
                                  );
                                }), (route) => false);
                              },
                              child: Text('view_your_order'.tr)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                SmallText(
                  text: 'receive_order_message'.tr,
                  color: Colors.black54,
                ),
                SizedBox(
                  height: 3,
                ),
                SmallText(
                  text: 'ship_item_message'.tr,
                  color: Colors.black54,
                ),
                SizedBox(
                  height: 20,
                ),
                FloatingActionButton(
                    backgroundColor: AppColor.accent,
                    child: Icon(
                      Icons.close,
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return MainPage(
                          clientId: clientId,
                          currentIndex: 0,
                          subMenuId: 0,
                          subMenu: 'ALL',
                        );
                      }), (route) => false);
                    }),
                SizedBox(
                  height: 20,
                ),
              ],
            )
          ]),
        ));
  }
}
