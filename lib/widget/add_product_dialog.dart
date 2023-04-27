import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:order_app/model/product_data.dart';
import 'package:order_app/widget/regular_text.dart';
import 'package:order_app/widget/title_text.dart';

import '../controller/product_controller.dart';
import '../database/database_helper.dart';
import '../model/cart_data.dart';
import '../value/app_color.dart';
import '../value/app_string.dart';

class AddProductDialog extends StatefulWidget {
  int index;
  ProductData data;
  AddProductDialog({super.key, required this.index, required this.data});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState(index, data);
}

class _AddProductDialogState extends State<AddProductDialog> {
  final ProductController productController = Get.put(ProductController());
  int index, quantity = 0, defaultQuantity = 0;
  ProductData data;

  _AddProductDialogState(this.index, this.data);

  @override
  void initState() {
    data.Quantity == null ? quantity = 0 : quantity = data.Quantity!;
    defaultQuantity = quantity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: const Text(AppString.select_quantity),
        content: SingleChildScrollView(
            child: ListBody(
          children: [
            Center(
                child: Text(data.ProductName,style:Theme.of(context).textTheme.bodyText1)
                /* RegularText(
              text: data.ProductName.toString(),
              color: Colors.black87,
            ) */
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (quantity != 0) quantity--;
                    });
                  },
                  icon: const Icon(
                    Icons.remove_circle,
                    color: AppColor.blueGrey,
                  ),
                  iconSize: 40.0,
                ),
                //TitleText(text: "$quantity"),
                Text("$quantity",style:Theme.of(context).textTheme.headline6),
                IconButton(
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                  icon: const Icon(
                    Icons.add_circle,
                    color: AppColor.accent,
                  ),
                  iconSize: 40.0,
                )
              ],
            )
          ],
        )),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const 
                  Text(
                    AppString.cancel,
                    style: TextStyle(color: Colors.blueGrey),
                  )
                  ),
              TextButton(
                  onPressed: () {
                    if (quantity == 0) return;
                    DatabaseHelper().insertCart(CartData.insertCart(
                        ProductID: data.ProductID, Quantity: quantity));

                    if (quantity > defaultQuantity) {
                      //increase
                      int incQty = quantity - defaultQuantity;
                      productController.addOrRemove(
                          index, quantity, true, incQty);
                    } else if (quantity < defaultQuantity) {
                      //decrease
                      int decQty = defaultQuantity - quantity;
                      productController.addOrRemove(
                          index, quantity, false, decQty);
                    }

                    productController.lstRxProduct[index].Quantity = quantity;
                    Fluttertoast.showToast(msg: AppString.added_to_cart);
                    Navigator.pop(context, quantity);
                  },
                  child: const Text(AppString.add_to_cart))
            ],
          )
        ],
      );
    });
  }
}
