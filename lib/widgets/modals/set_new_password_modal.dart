import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';
import '../../utilities/validator.dart';

class SetNewPasswordModal extends StatefulWidget {
  const SetNewPasswordModal({Key? key}) : super(key: key);

  @override
  State<SetNewPasswordModal> createState() => _SetNewPasswordModalState();
}

class _SetNewPasswordModalState extends State<SetNewPasswordModal> {
  bool isToggle = true;
  bool isToggle2 = true;
  final GlobalKey<FormState> _newPasswordFormKey = GlobalKey<FormState>();
  AuthController authController = Get.put(AuthController());
  UserController userController = Get.put(UserController());
  final newPasswordController = TextEditingController();

  void toggle() {
    setState(() {
      isToggle = !isToggle;
    });
  }

  void toggle2() {
    setState(() {
      isToggle2 = !isToggle2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: Get.width >= 500 ? 500.h : 600.h,
        width: Get.width >= 500 ? 500.h : 400.h,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/modal_layout_2.png'),
                fit: BoxFit.fill),
          ),
          child: Form(
            key: _newPasswordFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50.h,
                ),
                GestureDetector(
                  onTap: () => {
                    userController.soundIsOff.isFalse
                        ? userController.playGameSound()
                        : null,
                    Get.back()
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 15.0.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          'assets/images/icons/close.png',
                          width: 40.w,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                AutoSizeText(
                  'set password',
                  style: TextStyle(
                      fontFamily: 'Neuland',
                      fontSize: 25.sp,
                      color: const Color(0xFF4075BB)),
                ),
                SizedBox(
                  height: 10.h,
                ),
                AutoSizeText(
                  'You are in control now, \nset a new password',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 45.0.w),
                  child: SizedBox(
                    child: TextFormField(
                        controller: newPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: isToggle,
                        style: TextStyle(
                            height: 1.5.h,
                            color: const Color(0xFF104387),
                            fontSize: 12.sp),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("[A-Za-z0-9#-]*")),
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFD4DDDF),
                          focusColor: Colors.red,
                          errorStyle: TextStyle(fontSize: 12.sp),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () => toggle(),
                            child: !isToggle
                                ? Image.asset(
                                    'assets/images/icons/eye_open.png',
                                    scale: 1.5,
                                  )
                                : Image.asset(
                                    'assets/images/icons/eye_closed.png',
                                    scale: 1.5,
                                  ),
                          ),
                          hintText: 'Set a new password',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Color(0xFFD4DDDF),
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Color(0xFFD4DDDF), width: 1.5)),
                        ),
                        validator: (text) {
                          var validation = Validator.validatePassword(text!);
                          return validation;
                        },
                        onChanged: (text) => {}
                        // {authController.loginEmail.value = text},
                        ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 45.0.w),
                  child: SizedBox(
                    child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: isToggle2,
                        style: TextStyle(
                            height: 1.5.h,
                            color: const Color(0xFF104387),
                            fontSize: 12.sp),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("[A-Za-z0-9#-]*")),
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFD4DDDF),
                          suffixIcon: GestureDetector(
                            onTap: () => toggle2(),
                            child: !isToggle2
                                ? Image.asset(
                                    'assets/images/icons/eye_open.png',
                                    scale: 1.5,
                                  )
                                : Image.asset(
                                    'assets/images/icons/eye_closed.png',
                                    scale: 1.5,
                                  ),
                          ),
                          focusColor: Colors.red,
                          errorStyle: TextStyle(fontSize: 12.sp),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: 'Input the password again',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Color(0xFFD4DDDF),
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Color(0xFFD4DDDF), width: 1.5)),
                        ),
                        validator: (text) {
                          var validation = Validator.validateConfirmPassword(
                              text!, newPasswordController.text);
                          return validation;
                        },
                        onChanged: (text) => {}
                        // {authController.loginEmail.value = text},
                        ),
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                GestureDetector(
                  onTap: () => {
                    userController.soundIsOff.isFalse
                        ? userController.playGameSound()
                        : null,
                    if (_newPasswordFormKey.currentState!.validate())
                      {authController.resetPassword(newPasswordController.text)}
                  },
                  child: Obx(
                    () => Container(
                      width: 200.w,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          color: const Color(0xFF548BD5),
                          border: Border.all(color: const Color(0xFF548CD7)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(40))),
                      child: authController.isResettingPassword.isTrue
                          ? Center(
                              child: SizedBox(
                                  height: 20.w,
                                  width: 20.w,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  )),
                            )
                          : Text(
                              'set new password',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Neuland',
                                  letterSpacing: 1,
                                  color: Colors.white,
                                  fontSize: 14.sp),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
