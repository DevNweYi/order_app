import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:order_app/database/database_helper.dart';
import 'package:order_app/value/app_setting.dart';
import 'package:order_app/value/app_string.dart';
import 'package:order_app/widget/small_text.dart';
import 'package:order_app/widget/title_text.dart';
import 'package:sqflite/sqflite.dart';

import '../../api/apiservice.dart';
import '../../model/cart_data.dart';
import '../../model/order_data.dart';
import '../../value/app_color.dart';
import '../../widget/regular_text.dart';
import '../main_page.dart';

class OrderPage extends StatefulWidget {
  final int clientId;
  const OrderPage({super.key, required this.clientId});

  @override
  State<OrderPage> createState() => _OrderPageState(clientId);
}

class _OrderPageState extends State<OrderPage> {
  ApiService apiService = Get.find();
  late String fromDate, toDate;
  final int clientId;
  List<OrderData> lstOrder = [];

  _OrderPageState(this.clientId);

  @override
  void initState() {
    fromDate = AppSetting.getFilterDate();
    toDate = AppSetting.getFilterDate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: TitleText(
              text: 'my_orders'.tr,
              color: AppColor.white,
            ),
            backgroundColor: AppColor.primary_700,
          ),
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppColor.primary_50,
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: AppColor.primary, width: 3))),
                    labelColor: AppColor.primary_700,
                    unselectedLabelColor: Colors.black45,
                    tabs: [
                      Tab(
                        text: 'current_orders'.tr,
                      ),
                      Tab(
                        text: 'past_orders'.tr,
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: TabBarView(children: [
                  FutureBuilder<List<OrderData>>(
                    future: DatabaseHelper().getOrder(),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        return _currentOrder(snapshot.data!, isHistory: false);
                      } else if (snapshot.hasError) {
                        return RegularText(text: snapshot.error.toString());
                      }
                      return const Center(child: CircularProgressIndicator());
                    }),
                  ),
                  FutureBuilder<List<OrderData>>(
                    future: DatabaseHelper().getEmptyOrder(),
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        return _currentOrder(snapshot.data!, isHistory: true);
                      } else if (snapshot.hasError) {
                        return RegularText(text: snapshot.error.toString());
                      }
                      return const Center(child: CircularProgressIndicator());
                    }),
                  ),
                ]))
              ],
            ),
          )),
    );
  }

  Widget _currentOrder(List<OrderData> lstOrder, {required bool isHistory}) {
    // named para
    if (lstOrder.isNotEmpty) {
      return ListView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemCount: lstOrder.length,
          itemBuilder: (context, index) {
            OrderData data = lstOrder[index];
            List<CartData> lst = data.lstSaleOrderTran!;
            return Card(
              margin: EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("#${data.OrderNumber}",
                            style: Theme.of(context).textTheme.headline6),
                        SmallText(
                          text: "${data.Month!} ${data.Day!}, ${data.Year!}",
                          color: AppColor.primary_700,
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      height: 1,
                      color: AppColor.grey_200,
                    ),
                    _orderDetail(lst),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      height: 1,
                      color: AppColor.grey_200,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${'total_items'.tr} : ${lst.length}",
                            style: Theme.of(context).textTheme.bodyText1),
                        Row(
                          children: [
                            Text("${'total'.tr} : ",
                                style: Theme.of(context).textTheme.bodyText1),
                            data.Total.toString().length > 3
                                ? Text(
                                    AppSetting.formatter
                                        .format(data.Total)
                                        .toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyText1)
                                : Text(data.Total.toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyText1)
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
    } else {
      if (isHistory) {
        return _emptyOrder(
            "assets/images/history.png", AppString.no_order_history, "", 20, 0);
      } else {
        return _emptyOrder("assets/images/preview.png",
            AppString.no_order_found, AppString.no_order_found_message, 50, 10);
      }
    }
  }

  Widget _orderDetail(List<CartData> lst) {
    return ListView(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        children: List.generate(lst.length, (index) {
          CartData data = lst[index];
          return ListTile(
              leading: Image.asset("assets/images/logo.png"),
              title: Text(data.productName),
              subtitle: data.salePrice.toString().length > 3
                  ? Row(
                      children: [
                        Text(AppSetting.formatter
                            .format(data.salePrice)
                            .toString()),
                        const Text(" * "),
                        Text(data.quantity.toString()),
                      ],
                    )
                  : Row(
                      children: [
                        Text(data.salePrice.toString()),
                        const Text(" * "),
                        Text(data.quantity.toString()),
                      ],
                    ),
              trailing: (data.salePrice * data.quantity).toString().length > 3
                  ? Text(AppSetting.formatter
                      .format(data.salePrice * data.quantity)
                      .toString())
                  : Text((data.salePrice * data.quantity).toString()));
        }));
  }

  Widget _emptyOrder(String image, String message, String subMessage,
      double msgTopSize, double subMsgTopSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(image),
        SizedBox(
          height: msgTopSize,
        ),
        Text(message, style: Theme.of(context).textTheme.headline6),
        SizedBox(
          height: subMsgTopSize,
        ),
        SmallText(
          text: subMessage,
          color: AppColor.blueGrey,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 50,
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return MainPage(
                  clientId: clientId,
                  currentIndex: 1,
                  subMenuId: 0,
                  subMenu: 'ALL',
                );
              }));
            },
            child: Text(AppString.back_product),
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                backgroundColor: MaterialStateProperty.all(AppColor.white),
                foregroundColor: MaterialStateProperty.all(AppColor.primary))),
      ],
    );
  }
}
