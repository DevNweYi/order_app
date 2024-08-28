import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:order_app/model/order_data.dart';
import 'package:order_app/value/app_color.dart';
import 'package:order_app/view/order_success_page.dart';
import 'package:order_app/widget/small_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/apiservice.dart';
import '../controller/cart_controller.dart';
import '../database/database_helper.dart';
import '../model/cart_data.dart';
import '../model/client_data.dart';
import '../value/app_setting.dart';
import '../value/app_string.dart';
import '../widget/regular_text.dart';
import '../widget/title_text.dart';

class OrderSummaryPage extends StatefulWidget {
  const OrderSummaryPage({super.key});

  @override
  State<OrderSummaryPage> createState() => _OrderSummaryPageState();
}

class _OrderSummaryPageState extends State<OrderSummaryPage> {
  late Future<List<CartData>> _lstCartData;
  final CartController cartController = Get.put(CartController());
  TextEditingController name_controller = new TextEditingController();
  TextEditingController phone_controller = new TextEditingController();
  TextEditingController address_controller = new TextEditingController();
  int _clientId = 0;
  late List<CartData> _lstOrder;
  ApiService apiService = Get.find();

  @override
  void initState() {
    _lstCartData = DatabaseHelper().getCartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColor.primary_700,
        title: TitleText(
          text: 'order_summary'.tr,
          color: AppColor.white,
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20, left: 8, right: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('delivery_address'.tr,
                      style: Theme.of(context).textTheme.bodyText2),
                ),
              ),
              Card(
                  elevation: 8.0,
                  margin: EdgeInsets.all(8.0),
                  color: AppColor.primary,
                  child: FutureBuilder<ClientData>(
                    future: getUserData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return _userData(snapshot.data!);
                      } else if (snapshot.hasError) {
                        return RegularText(text: snapshot.error.toString());
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  )),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('order_items'.tr,
                      style: Theme.of(context).textTheme.bodyText2),
                ),
              ),
              FutureBuilder<List<CartData>>(
                  future: _lstCartData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return _cartList(snapshot.data!);
                    } else if (snapshot.hasError) {
                      return RegularText(text: snapshot.error.toString());
                    }
                    return const Center(child: CircularProgressIndicator());
                  }),
            ],
          ))),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('total'.tr,
                        style: Theme.of(context).textTheme.headline6),
                    FutureBuilder<int>(
                        future: DatabaseHelper().getTotalCartAmount(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            cartController.totalAmount.value = snapshot.data!;
                            return cartController.totalAmount.value
                                        .toString()
                                        .length >
                                    3
                                ? Text(
                                    AppSetting.formatter.format(
                                        cartController.totalAmount.value),
                                    style:
                                        Theme.of(context).textTheme.headline6)
                                : Text(
                                    cartController.totalAmount.value.toString(),
                                    style:
                                        Theme.of(context).textTheme.headline6);
                          } else if (snapshot.hasError) {
                            return RegularText(text: snapshot.error.toString());
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        })
                  ],
                ),
              ),
              Container(
                height: 1,
                color: AppColor.grey_200,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, top: 8),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                      onPressed: () {
                        if (_isValidateControl()) {
                          EasyLoading.show(status: AppString.loading);
                          DatabaseHelper()
                              .insertOrder(_lstOrder,cartController.totalAmount.value)
                              .then((orderNumber) {
                            DatabaseHelper().deleteAllCart().then((value) {
                              EasyLoading.dismiss();
                              Navigator.pushReplacement(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => OrderSuccessPage(
                                            clientId: _clientId,
                                            orderNumber: orderNumber,
                                            totalAmount: cartController
                                                .totalAmount.value,
                                          )));
                            });
                          });
                        }
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.only(
                              left: 30, right: 30, top: 20, bottom: 20))),
                      child: Text('send_order'.tr)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _userData(ClientData data) {
    _clientId = data.ClientID;
    if (data.Address == null) {
      address_controller.text = "";
    } else {
      address_controller.text = data.Address!;
    }
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: Colors.white70,
              ),
              SizedBox(
                width: 10,
              ),
              RegularText(
                text: data.ClientName!,
                color: Colors.white70,
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(
                Icons.phone,
                color: Colors.white70,
              ),
              SizedBox(
                width: 10,
              ),
              RegularText(
                text: data.Phone!,
                color: Colors.white70,
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: AppColor.grey_200,
              /* boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: AppColor.grey_200)
                ] */
            ),
            alignment: Alignment.center,
            child: TextField(
              maxLines: null,
              controller: address_controller,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.multiline,
              style: TextStyle(color: Colors.black87),
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.home,
                    color: AppColor.primary,
                  ),
                  hintText: AppString.enter_address,
                  hintStyle: TextStyle(color: Colors.black45),
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartList(List<CartData> lstCartData) {
    _lstOrder = lstCartData;
    return Container(
      margin: EdgeInsets.only(left: 8, right: 8),
      decoration: BoxDecoration(border: Border.all(color: AppColor.grey_200)),
      child: ListView.builder(
          primary: false,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: lstCartData.length,
          itemBuilder: (BuildContext context, int index) {
            CartData item = lstCartData[index];
            return ListTile(
                onTap: null,
                leading: Image.asset("assets/images/logo.png"),
                title: Text(item.productName),
                subtitle: item.salePrice.toString().length > 3
                    ? Row(
                        children: [
                          Text(AppSetting.formatter
                              .format(item.salePrice)
                              .toString()),
                          const Text(" * "),
                          Text(item.quantity.toString()),
                        ],
                      )
                    : Row(
                        children: [
                          Text(item.salePrice.toString()),
                          const Text(" * "),
                          Text(item.quantity.toString()),
                        ],
                      ),
                trailing: (item.salePrice * item.quantity).toString().length > 3
                    ? Text(AppSetting.formatter
                        .format(item.salePrice * item.quantity)
                        .toString())
                    : Text((item.salePrice * item.quantity).toString()));
          }),
    );
  }

  Future<ClientData> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    ClientData clientData = ClientData(
        ClientID: sharedPreferences.getInt("UserID")!,
        ClientName: sharedPreferences.getString("UserName"),
        ClientPassword: "",
        ShopName: "",
        Phone: sharedPreferences.getString("UserPhone"),
        DivisionID: 0,
        TownshipID: 0,
        Address: sharedPreferences.getString("UserAddress"),
        IsSalePerson: false,
        DivisionName: "",
        TownshipName: "",
        Token: "");
    return clientData;
  }

  bool _isValidateControl() {
    if (address_controller.text.isEmpty) {
      Fluttertoast.showToast(msg: AppString.enter_address);
      return false;
    }
    return true;
  }
}
