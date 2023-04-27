import 'package:get/get.dart';

import '../model/cart_data.dart';

class CartController extends GetxController{
  RxList<CartData> lstRxCart = <CartData>[].obs;
  Rx<int> totalAmount=0.obs;

  RxList<CartData> getRxCart(List<CartData> lstCart) {
    lstRxCart = lstCart.obs;
    return lstRxCart;
  }

  void changeQuantity(int index, int quantity) {
    lstRxCart[index].quantity = quantity;
    lstRxCart.refresh();
    calculateTotalAmount();
  }

  calculateTotalAmount() {
    totalAmount.value = 0;
    for (var element in lstRxCart) {
      if (element.quantity > 0) {
        totalAmount.value+=element.quantity*element.salePrice;
      }
    }
  }

  void delete(int index){
    lstRxCart.removeAt(index);
    lstRxCart.refresh();
    calculateTotalAmount();
  }

}