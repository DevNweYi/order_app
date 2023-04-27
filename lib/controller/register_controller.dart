import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:order_app/repository/auth_repository.dart';

class RegisterController extends GetxController{
  static RegisterController get instance => Get.find();
  var authRepository=Get.put(AuthRepository());

  final name_controller=TextEditingController();
  final phone_controller=TextEditingController();
  final password_controller=TextEditingController();
  final confirm_password_controller=TextEditingController();
  
  void phoneAuthentication(String phone){
    AuthRepository.instance.phoneAuthentication(phone);
  }
}