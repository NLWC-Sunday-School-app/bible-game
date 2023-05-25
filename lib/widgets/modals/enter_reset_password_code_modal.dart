import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/services/auth_service.dart';
import 'package:bible_game/utilities/constants.dart';
import 'package:bible_game/widgets/modals/set_new_password_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';

class EnterResetPasswordCodeModal extends StatefulWidget {
  const EnterResetPasswordCodeModal({Key? key}) : super(key: key);

  @override
  State<EnterResetPasswordCodeModal> createState() => _EnterResetPasswordCodeModalState();
}

class _EnterResetPasswordCodeModalState extends State<EnterResetPasswordCodeModal> {

  AuthController authController = Get.put(AuthController());
  UserController _userController = Get.put(UserController());
  //final otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: Get.width >= 500 ? 450.h : 500.h,
        width: Get.width >= 500 ? 600.w : 500.w,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/modal_layout_2.png'),
                fit: BoxFit.fill),
          ),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50.h,
                ),
                GestureDetector(
                  onTap: () => {
                    _userController.soundIsOff.isFalse
                        ? _userController.playGameSound()
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
                  'code sent',
                  style: TextStyle(
                      fontFamily: 'Neuland',
                      fontSize: 25.sp,
                      color: const Color(0xFF4075BB)),
                ),
                SizedBox(
                  height: 10.h,
                ),
                AutoSizeText(
                  'Kindly type in the code \nsent to your mail',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                  child: PinCodeTextField(
                    autoDisposeControllers: false,
                    mainAxisAlignment: MainAxisAlignment.center,
                    length: 4,
                    scrollPadding: EdgeInsets.zero,
                    animationType: AnimationType.fade,
                    textStyle: TextStyle(fontSize: 18.sp),
                    pinTheme: PinTheme(
                      fieldOuterPadding: EdgeInsets.all(5.w),
                      inactiveFillColor: const Color(0xFFD4DDDF),
                      inactiveColor: const Color(0xFFD4DDDF),
                      activeColor: const Color(0xFF598DE7),
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50.w,
                      fieldWidth: 50.w,
                      activeFillColor: Colors.white,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    // errorAnimationController: errorController,
                    controller: authController.otpController,
                    onCompleted: (text) {
                      //authController.verifyOTP(text);
                      print('love');
                    },
                    appContext: context,
                    onChanged: (String value) {

                    },
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Obx(
                  () => GestureDetector(
                    onTap: () => {
                      _userController.soundIsOff.isFalse
                          ? _userController.playGameSound()
                          : null,
                       authController.verifyOTP(authController.otpController.text)

                    },
                    child: Container(
                      width: 200.w,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          color: const Color(0xFF548BD5),
                          border: Border.all(color: const Color(0xFF548CD7)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(40))),
                      child: authController.isVerifyingCode.isTrue
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
                              'verify code',
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
