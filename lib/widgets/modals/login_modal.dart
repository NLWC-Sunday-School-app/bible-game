import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';
import '../../utilities/validator.dart';

class LoginModal extends StatefulWidget {
  const LoginModal({Key? key}) : super(key: key);

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  bool isToggle = true;

  void toggle() {
    setState(() {
      isToggle = !isToggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    UserController _userController = Get.put(UserController());
    return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          child: SizedBox(
            height: Get.width >= 500 ? 600.h : 600.h,
            width: Get.width >= 500 ? 600.w : 500.w,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/modal_layout_2.png'),
                    fit: BoxFit.fill),
              ),
              child: Form(
                key: _loginFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50.h,
                    ),
                    GestureDetector(
                      onTap: () => {
                        _userController.soundIsOff.isFalse ? _userController.playGameSound() : null,
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
                      'LOG IN',
                      style: TextStyle(
                          fontFamily: 'Neuland',
                          fontSize: 28.sp,
                          color: const Color(0xFF4075BB)),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    AutoSizeText(
                      'Continue from where you \nstopped when you log in.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 45.0.w),
                      child: SizedBox(
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              height: 1.5.h, color: const Color(0xFF104387), fontSize: 12.sp),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color(0xFFD4DDDF),
                            focusColor: Colors.red,
                            errorStyle: TextStyle(fontSize: 12.sp),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: 'Input your email',
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
                            var validation = Validator.validateEmail(text!);
                            return validation;
                          },
                          onChanged: (text) =>
                              {authController.loginEmail.value = text},
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height <= 670 ? 15.h : 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 45.0.w),
                      child: SizedBox(
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: isToggle,
                          style: TextStyle(
                              height: 1.5.h, color: const Color(0xFF104387)),
                          decoration: InputDecoration(
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
                            filled: true,
                            fillColor: const Color(0xFFD4DDDF),
                            errorStyle: TextStyle(fontSize: 12.sp),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: 'Password',
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
                          onChanged: (text) =>
                              {authController.loginPassword.value = text},
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    GestureDetector(
                      onTap: () => {
                        if (_loginFormKey.currentState!.validate())
                          {authController.loginUser()}
                      },
                      child: Obx(
                        () => Container(
                          width: 250.w,
                          padding: EdgeInsets.symmetric(
                              vertical: 20.h,),
                          decoration: BoxDecoration(
                              color: const Color(0xFFE8F8FF),
                              border:
                                  Border.all(color: const Color(0xFF548CD7)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(40))),
                          child: authController.isLoadingLogin.isTrue
                              ? Center(
                                  child: SizedBox(
                                      height: 20.w,
                                      width: 20.w,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF548CD7),
                                      )),
                                )
                              : Text(
                                  'LOG IN',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Neuland',
                                      letterSpacing: 1,
                                      color: const Color(0xFF4075BB),
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
        ));
  }
}
