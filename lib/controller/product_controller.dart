import 'package:get/get.dart';

import '../model/product_data.dart';

class ProductController extends GetxController {
  RxList<ProductData> lstRxProduct = <ProductData>[].obs;
  static Rx<int> totalCartItems = 0.obs;

  RxList<ProductData> getRxProduct(List<ProductData> lstProduct) {
    lstRxProduct = lstProduct.obs;
    return lstRxProduct;
  }

  void addOrRemove(int index, int productQty,bool isIncrease,int cartQty) {
    lstRxProduct[index].Quantity = productQty;
    lstRxProduct.refresh();
    if(isIncrease){
       totalCartItems.value+=cartQty;
    }else{
      totalCartItems.value-=cartQty;
    }
  }

  void increase(int productId){
    if(lstRxProduct.isNotEmpty){
      int index=lstRxProduct.indexWhere((e) => e.ProductID == productId);
      if(index!=-1){
        int curQty=lstRxProduct[index].Quantity!;
        lstRxProduct[index].Quantity=curQty+1;
        lstRxProduct.refresh();
      }
    }
    totalCartItems.value+=1;
  }

  void decrease(int productId){
    if(lstRxProduct.isNotEmpty){
      int index=lstRxProduct.indexWhere((e) => e.ProductID == productId);
      if(index != -1){
        int curQty=lstRxProduct[index].Quantity!;
        lstRxProduct[index].Quantity=curQty-1;
        lstRxProduct.refresh();
      }
    }
    totalCartItems.value-=1;
  }

  void remove(int productId,int quantity) {
    if(lstRxProduct.isNotEmpty){
       int index=lstRxProduct.indexWhere((e) => e.ProductID == productId);
       if(index != -1){
          lstRxProduct[index].Quantity = 0;
          lstRxProduct.refresh();
       }
       totalCartItems.value-=quantity;
    }
  }
  
}
