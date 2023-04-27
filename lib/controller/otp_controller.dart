import 'package:get/get.dart';
import 'package:order_app/repository/auth_repository.dart';
import 'package:order_app/view/init_page.dart';
import 'package:order_app/view/main_page.dart';

class OTPController extends GetxController{
  static OTPController get instance => Get.find();

  Future<bool> verifyOTP(String otp) async{
    var isVerified= await AuthRepository.instance.verifyOTP(otp);
    return isVerified;
    //isVerified ? Get.offAll(InitPage(clientId: 1)) : Get.back();
  }
}