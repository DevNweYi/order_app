import 'package:get/get.dart';

class LocaleString extends Translations{
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {

    'en_US':{
      'home':'Home',
      'product':'Product',
      'order':'Order',
      'setting':'Settings',
      'search':'Search',
      'categories':'Categories',
      'total':'Total',
      'close':'Close',
      'cart':'Cart',
      'add_to_cart':'Add to Cart',
      'product_detail':'Product Detail',
      'send_order':'Send Order'
    },

    'my_MM':{
      'home':'မူလ',
      'product':'ကုန်ပစ္စည်း',
      'order':'အော်ဒါ',
      'setting':'အကောင့်',
      'search':'ရှာရန်',
      'categories':'အမျိုးအစားများ',
      'total':'စုစုပေါင်း',
      'close':'ပိတ်ရန်',
      'cart':'စျေးခြင်း',
      'add_to_cart':'ခြင်းထဲထည့်',
      'product_detail':'အသေးစိတ်',
      'send_order':'အော်ဒါတင်မည်'
    }

  };
  
}