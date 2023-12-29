import 'dart:convert';

import 'package:bible_game/controllers/pilgrim_progress_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/screens/tabs/tab_main_screen.dart';
import 'package:bible_game/widgets/modals/login_successful.dart';
import 'package:bible_game/widgets/modals/success_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../services/auth_service.dart';
import '../services/game_service.dart';
import '../services/user_service.dart';
import '../widgets/modals/enter_reset_password_code_modal.dart';
import '../widgets/modals/reset_password_success_modal.dart';
import '../widgets/modals/set_new_password_modal.dart';
import 'awesome_notification_controller.dart';

class AuthController extends GetxController {
  var username = ''.obs;
  var country = ''.obs;
  var countryCode = '234'.obs;
  var phoneNumber = ''.obs;
  var emailAddress = ''.obs;
  var updatedName = ''.obs;
  var updatedPassword = ''.obs;
  var updatedEmailAddress = ''.obs;
  var password = ''.obs;
  var isLoadingRegistration = false.obs;
  var isSendingCode = false.obs;
  var isVerifyingCode = false.obs;
  var isResettingPassword = false.obs;
  var isLoadingLogin = false.obs;
  var isLoadingLogout = false.obs;
  var isLoadingUpdate = false.obs;
  var isDeletingAccount = false.obs;
  var loginEmail = ''.obs;
  var loginPassword = ''.obs;
  var token = ''.obs;
  var isLoggedIn = false.obs;
  var forgotPasswordMail = ''.obs;
 final otpController = TextEditingController();
  GetStorage box = GetStorage();

  registerUser() async {
    isLoadingRegistration(true);
    try {
      var fcmToken = await AwesomeNotificationController.getFirebaseMessagingToken();
      var status = await AuthService.registerUser(
          username.value, emailAddress.value, password.value, fcmToken, country.value);
      if (status == 200){
        var isTempLoggedIn = GetStorage().read('isTempLoggedIn') ?? false ;
        await AuthService.loginUser(emailAddress.value, password.value);
        await UserService.getUserData();
        await UserService.getUserPilgrimProgress();
        if(isTempLoggedIn){
          var userData = GetStorage().read('user_data');
          var gameData = GetStorage().read('tempProgressData');
          var userId = userData['id'];
          await GameService.sendGameData(
            gameData['gameMode'],
            gameData['totalScore'],
            gameData['baseScore'],
            gameData['bonusScore'],
            gameData['averageTimeSpent'],
            gameData['playerRank'],
            gameData['noOfCorrectAnswers'],
            userId,
            gameData['userProgress'],
            gameData['numberOfRounds'],
          );
        }
        box.write('userLoggedIn', true);
        box.write('password', password.value);
        isLoggedIn(true);
        isLoadingRegistration(false);
        Get.back();
        Get.dialog(const SuccessModal(), barrierDismissible: false);
        updateFcmToken();
      }
      isLoadingRegistration(false);
    } catch (e) {
      isLoadingRegistration(false);
    }
  }

  sendForgotPasswordMail() async{
     try{
       isSendingCode(true);
       var response =  await AuthService.sendForgotPasswordMail(forgotPasswordMail.value);
       GetStorage().write('reset_email', forgotPasswordMail.value);
       if(response == 200){
         Get.back();
         Get.snackbar(
             'Awesome!',
             'An OTP has been sent to your account email address',
             messageText: Text(
             'An OTP has been sent to your account email address',
               style: TextStyle(
                 fontSize: 16.sp,
                 color: Colors.white,
                 fontWeight: FontWeight.w500,
               ),
             ),
             backgroundColor: Colors.green,
             colorText: Colors.white
         );
         isSendingCode(false);
         Get.dialog(const EnterResetPasswordCodeModal(), barrierDismissible: false);
       }
       isSendingCode(false);
     }catch(e){
       isSendingCode(false);
     }
  }

  verifyOTP(code)async{
    isVerifyingCode(true);
    try{
     var response = await AuthService.verifyOTP(code);
     if(response == 200){
        Get.back();
        Get.snackbar(
           'Awesome!',
           'verification successful',
           messageText: Text(
            'verification successful',
             style: TextStyle(
               fontSize: 16.sp,
               color: Colors.white,
               fontWeight: FontWeight.w500,
             ),
           ),
           backgroundColor: Colors.green,
           colorText: Colors.white
       );
       otpController.text = '';
       Get.dialog(const SetNewPasswordModal());
       isVerifyingCode(false);
     }
    }catch(e){
      isVerifyingCode(false);
    }
  }

  resetPassword(newPassword) async{
    isResettingPassword(true);
    try{
       var response = await AuthService.resetPassword(newPassword);
       Get.back();
       Get.snackbar(
           'Awesome!',
           response['message'],
           messageText: Text(
             response['message'],
             style: TextStyle(
               fontSize: 16.sp,
               color: Colors.white,
               fontWeight: FontWeight.w500,
             ),
           ),
           backgroundColor: Colors.green,
           colorText: Colors.white
       );
       Get.dialog(const ResetPasswordSuccessModal());
       isResettingPassword(false);
    }catch(e){
      isResettingPassword(false);
    }
  }

  updateFcmToken() async{
      try{
        var fcmToken = await AwesomeNotificationController.getFirebaseMessagingToken();
        await UserService.updateUserFcmToken(fcmToken);
      }catch(e){
      }
  }

  loginUser() async {
    isLoadingLogin(true);
    try {
      var response = await AuthService.loginUser(loginEmail.value, loginPassword.value);
      if (response == 200) {
        var isTempLoggedIn = GetStorage().read('isTempLoggedIn') ?? false ;
        await UserService.getUserData();
        await UserService.getUserPilgrimProgress();
        await UserService.getYearRecap();
        if(isTempLoggedIn){
             var userData = GetStorage().read('user_data');
             var gameData = GetStorage().read('tempProgressData');
             var userId = userData['id'];
             await GameService.sendGameData(
               gameData['gameMode'],
               gameData['totalScore'],
               gameData['baseScore'],
               gameData['bonusScore'],
               gameData['averageTimeSpent'],
               gameData['playerRank'],
               gameData['noOfCorrectAnswers'],
               userId,
               gameData['userProgress'],
                gameData['numberOfRounds'],
             );
          }
        isLoadingLogin(false);
        box.write('userLoggedIn', true);
        box.write('password', loginPassword.value);
        isLoggedIn(true);
        Get.back();
        Get.dialog(const LoginSuccessfulModal());
        updateFcmToken();
      }else {
        isLoadingLogin(false);
        Get.snackbar(
            'Error',
            response,
            messageText: Text(
              response,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: Colors.red,
            colorText: Colors.white
        );
      }
    } catch (e) {
      isLoadingLogin(false);
    }
  }

  updateUserProfile(id)async{
    isLoadingUpdate(true);
    try{
     var response = await UserService.updateProfile(id, updatedName);
     if(response == 200){
       await UserService.getUserData();
       isLoadingUpdate(false);
       Get.back();
     }else{
       isLoadingUpdate(false);
       Get.snackbar(
           'Error',
           response,
           messageText: Text(
             response,
             style: const TextStyle(
               fontSize: 16,
               color: Colors.white,
               fontWeight: FontWeight.w500,
             ),
           ),
           backgroundColor: Colors.red,
           colorText: Colors.white
       );
     }
    }catch(e){
      isLoadingUpdate(false);
    }
  }

  resetAppData()async{
    await box.write('userLoggedIn', false);
    await Get.delete<PilgrimProgressController>();
    await box.remove('user_token');
    isLoggedIn(false);
    isLoadingLogout(false);
  }

  logoutUser() async {
    isLoadingLogout(true);
    try {
      var status = await AuthService.loginOutUser();
      if (status == 200) {
        await box.write('userLoggedIn', false);
        await Get.delete<PilgrimProgressController>();
        await box.remove('user_token');
        await box.remove('game_recap');
        isLoggedIn(false);
        isLoadingLogout(false);
        Get.back();
      } else {
        isLoadingLogout(false);
        Get.snackbar(
            'Oops',
            'Error',
            messageText: const Text(
              'Error',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: Colors.red,
            colorText: Colors.white
        );
      }
    } catch (e) {
      isLoadingLogout(false);
    }
  }

  deleteAccount(id) async{
    isDeletingAccount(true);
    await box.write('tempUserId', id);
   try{
     var logOutStatus = await AuthService.loginOutUser();
     if(logOutStatus == 200){
       await box.write('userLoggedIn', false);
       await AuthService.deleteUserAccount(id);
       await box.remove('user_token');
       await Get.delete<PilgrimProgressController>();
       isLoggedIn(false);
       isDeletingAccount(false);
       Get.back();
       Get.snackbar(
           '',
           'Your account has been deleted.',
           messageText: const Text(
             'Your account has been deleted.',
             style: TextStyle(
               fontSize: 16,
               color: Colors.white,
               fontWeight: FontWeight.w500,
             ),
           ),
           backgroundColor: Colors.green,
           colorText: Colors.white
       );
     }else{
       isDeletingAccount(false);
       Get.snackbar(
           'Error',
           'Error',
           messageText: const Text(
             'Error',
             style: TextStyle(
               fontSize: 16,
               color: Colors.white,
               fontWeight: FontWeight.w500,
             ),
           ),
           backgroundColor: Colors.red,
           colorText: Colors.white
       );
     }
   }catch(e){

   }
  }

  @override
  void dispose() {
    super.dispose();
    otpController.dispose();
  }
}
