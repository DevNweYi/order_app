import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AuthRepository extends GetxController{

  static AuthRepository get instance => Get.find();
  final _auth=FirebaseAuth.instance;
  var verificationId=''.obs;

  void phoneAuthentication(String phone) async{
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (credentials) async{
          await _auth.signInWithCredential(credentials);
      }, 
      verificationFailed: (e){
        EasyLoading.dismiss();
        if(e.code == 'invalid-phone-number'){
          Get.snackbar('Error', 'The provided phone number is not valid.');
        }else{
          Get.snackbar('Error', 'Something went wrong. Try again.');
        }
      }, 
      codeSent: (verificationId, resendToken) {
        EasyLoading.dismiss();
        this.verificationId.value=verificationId;
      }, 
      codeAutoRetrievalTimeout: (verificationId){
        EasyLoading.dismiss();
        this.verificationId.value=verificationId;
      });
  }

  Future<bool> verifyOTP(String otp) async{
    var credentials= await _auth.signInWithCredential(PhoneAuthProvider.credential(verificationId: this.verificationId.value, smsCode: otp));
    return credentials.user != null ? true:false;
  }

 
}