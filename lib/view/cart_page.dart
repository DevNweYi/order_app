import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:order_app/controller/product_controller.dart';
import 'package:order_app/database/database_helper.dart';
import 'package:order_app/model/cart_data.dart';
import 'package:order_app/value/app_string.dart';
import 'package:order_app/view/order_summary_page.dart';
import 'package:order_app/widget/regular_text.dart';
import 'package:order_app/widget/small_text.dart';
import 'package:order_app/widget/title_text.dart';
import 'package:quickalert/quickalert.dart';

import '../controller/cart_controller.dart';
import '../value/app_color.dart';
import '../value/app_setting.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<CartData>> _lstCartData;
  final CartController cartController = Get.put(CartController());
  final ProductController productController = Get.put(ProductController());

  @override
  void initState() {
    _lstCartData = DatabaseHelper().getCartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary_700,
        title: const TitleText(
          text: AppString.cart,
          color: AppColor.white,
        ),
        actions: [
          IconButton(
              onPressed: () {
                if (cartController.lstRxCart.isEmpty) return;
                QuickAlert.show(
                    context: context,
                    type: QuickAlertType.confirm,
                    text: 'Do you want to delete all?',
                    confirmBtnText: 'Yes',
                    cancelBtnText: 'No',
                    confirmBtnColor: AppColor.primary,
                    onConfirmBtnTap: () {
                      DatabaseHelper().deleteAllCart();
                      setState(() {
                        _lstCartData = DatabaseHelper().getCartData();
                      });
                      ProductController.totalCartItems.value = 0;
                      for (var element in productController.lstRxProduct) {
                        element.Quantity = 0;
                      }
                      productController.lstRxProduct.refresh();
                      Navigator.pop(context);
                    },
                    onCancelBtnTap: () {
                      Navigator.pop(context);
                    });
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder<List<CartData>>(
                  future: _lstCartData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      cartController.getRxCart(snapshot.data!);
                      if (cartController.lstRxCart.isNotEmpty) {
                        return _cartList();
                      } else {
                        return _emptyCart();
                      }
                    } else if (snapshot.hasError) {
                      return RegularText(text: snapshot.error.toString());
                    }
                    return const Center(child: CircularProgressIndicator());
                  })),
          Container(
            height: 1,
            color: AppColor.grey_200,
          ),
          Container(
            padding: EdgeInsets.only(left: 5, right: 5, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    children: [
                      Text(AppString.total,
                          style: Theme.of(context).textTheme.bodyText1),
                      FutureBuilder<int>(
                          future: DatabaseHelper().getTotalCartAmount(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              cartController.totalAmount.value = snapshot.data!;
                              return Obx(() => cartController.totalAmount.value
                                          .toString()
                                          .length >
                                      3
                                  ? Obx(
                                      () => Text(
                                          AppSetting.formatter.format(
                                              cartController.totalAmount.value),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                    )
                                  : Obx(
                                      () => Text(
                                          cartController.totalAmount.value
                                              .toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                    ));
                            } else if (snapshot.hasError) {
                              return RegularText(
                                  text: snapshot.error.toString());
                            }
                            return const Center(
                                child: CircularProgressIndicator());
                          })
                    ],
                  ),
                ),
                ElevatedButton(
                    onPressed: _orderPressed,
                    child: Text(AppString.continue_to_order),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.all(20))))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartList() {
    return Obx(() => ListView.builder(
        itemCount: cartController.lstRxCart.length,
        itemBuilder: (BuildContext context, int index) {
          CartData item = cartController.lstRxCart[index];
          return Slidable(
            key: UniqueKey(),
            startActionPane: ActionPane(
                extentRatio: 0.3,
                motion: const ScrollMotion(),
                dismissible: DismissiblePane(onDismissed: () {
                  _removeCart(index, item.productId, item.quantity);
                }),
                children: [
                  SlidableAction(
                    onPressed: ((context) {
                      _removeCart(index, item.productId, item.quantity);
                    }),
                    backgroundColor: AppColor.red,
                    foregroundColor: AppColor.white,
                    icon: Icons.delete,
                    label: "Delete",
                  )
                ]),
            child: Card(
              margin: EdgeInsets.all(5),
              child: ListTile(
                onTap: null,
                leading: Image.asset("assets/images/logo.png"),
                title: Text(item.productName),
                subtitle: item.salePrice.toString().length > 3
                    ? Text(
                        AppSetting.formatter.format(item.salePrice).toString())
                    : Text(item.salePrice.toString()),
                trailing: Container(
                  color: AppColor.white,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          //if (item.quantity == 0) return;
                          int quantity = item.quantity - 1;
                          DatabaseHelper().insertCart(CartData.insertCart(
                              ProductID: item.productId, Quantity: quantity));
                          if (quantity == 0) {
                            cartController.delete(index);
                          } else {
                            cartController.changeQuantity(index, quantity);
                          }
                          productController.decrease(item.productId);
                        },
                        icon: const Icon(
                          Icons.remove,
                          color: AppColor.blueGrey,
                        ),
                        iconSize: 30.0,
                      ),
                      Obx(
                        () => RegularText(
                          text: cartController.lstRxCart[index].quantity
                              .toString(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          int quantity = item.quantity + 1;
                          DatabaseHelper().insertCart(CartData.insertCart(
                              ProductID: item.productId, Quantity: quantity));
                          cartController.changeQuantity(index, quantity);
                          productController.increase(item.productId);
                        },
                        icon: const Icon(
                          Icons.add,
                          color: AppColor.accent,
                        ),
                        iconSize: 30.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }

  Widget _emptyCart() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/basket.png"),
        SizedBox(
          height: 50,
        ),
        Text(AppString.cart_empty,
            style: Theme.of(context).textTheme.headline6),
        SizedBox(
          height: 10,
        ),
        SmallText(
          text: AppString.cart_empty_message,
          color: AppColor.blueGrey,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 50,
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(AppString.back_product),
            style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.all(15)),
                backgroundColor: MaterialStateProperty.all(AppColor.white),
                foregroundColor: MaterialStateProperty.all(AppColor.primary))),
      ],
    );
  }

  void _removeCart(int index, int productId, int quantity) {
    DatabaseHelper().deleteCart(productId);
    cartController.delete(index);
    productController.remove(productId, quantity);
    Fluttertoast.showToast(msg: AppString.deleted);
  }

  Future? _orderPressed() {
    if (cartController.lstRxCart.isEmpty) {
      return null;
    } else {
      return Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const OrderSummaryPage()));
    }
  }
}
