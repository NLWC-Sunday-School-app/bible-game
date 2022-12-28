import 'package:bible_game/controllers/pilgrim_progress_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/screens/authentication/login.dart';
import 'package:bible_game/screens/tabs/tab_main_screen.dart';
import 'package:bible_game/widgets/modals/success_modal.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../services/auth_service.dart';
import 'awesome_notification_controller.dart';

class AuthController extends GetxController {
  var username = ''.obs;
  var country = ''.obs;
  var countryCode = '234'.obs;
  var phoneNumber = ''.obs;
  var emailAddress = ''.obs;
  var password = ''.obs;
  var isLoadingRegistration = false.obs;
  var isLoadingLogin = false.obs;
  var isLoadingLogout = false.obs;
  var loginEmail = ''.obs;
  var loginPassword = ''.obs;
  var token = ''.obs;
  var isLoggedIn = false.obs;
  GetStorage box = GetStorage();

  registerUser() async {
    isLoadingRegistration(true);
    try {
      var fcmToken =
          await AwesomeNotificationController.getFirebaseMessagingToken();
      var status = await AuthService.registerUser(
          username.value, emailAddress.value, password.value, fcmToken);
      if (status == 200) {
        await AuthService.loginUser(emailAddress.value, password.value);
        box.write('userLoggedIn', true);
        isLoggedIn(true);
        isLoadingRegistration(false);
        Get.back();
        Get.dialog(const SuccessModal(), barrierDismissible: false);
      } else if (status == 400) {
        isLoadingRegistration(false);
        Get.snackbar(
            'Error',
            'Enter a valid email address and password',
            messageText: const Text(
              'Enter a valid email address and password',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: Colors.red,
            colorText: Colors.white
        );
      } else {
        isLoadingRegistration(false);
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
    } catch (e) {
      isLoadingRegistration(false);
    }
  }

  loginUser() async {
    isLoadingLogin(true);
    try {
      var status =
          await AuthService.loginUser(loginEmail.value, loginPassword.value);
      if (status == 200) {
        isLoadingLogin(false);
        box.write('userLoggedIn', true);
        isLoggedIn(true);
        Get.back();
      } else if (status == 400) {
        isLoadingLogin(false);
        Get.snackbar(
          'Error',
          'Enter a valid email address and password',
            messageText: const Text(
              'Enter a valid email address and password',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          backgroundColor: Colors.red,
          colorText: Colors.white
        );
      } else {
        isLoadingLogin(false);
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
    } catch (e) {
      isLoadingLogin(false);
    }
  }

  logoutUser() async {
    isLoadingLogout(true);
    try {
      var status = await AuthService.loginOutUser();
      if (status == 200) {
        await box.write('userLoggedIn', false);
        await Get.delete<PilgrimProgressController>();
       // await Get.delete<UserController>();
        isLoggedIn(false);
        isLoadingLogout(false);
        Get.back();
      } else {
        isLoadingLogout(false);
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
    } catch (e) {
      isLoadingLogout(false);
    }
  }
}
