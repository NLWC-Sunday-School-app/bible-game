import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/services/auth_service.dart';
import 'package:bible_game/utilities/constants.dart';
import 'package:bible_game/widgets/modals/set_new_password_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stroke_text/stroke_text.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';
import '../button/modal_blue_button.dart';

class EnterResetPasswordCodeModal extends StatefulWidget {
  const EnterResetPasswordCodeModal({Key? key}) : super(key: key);

  @override
  State<EnterResetPasswordCodeModal> createState() =>
      _EnterResetPasswordCodeModalState();
}

class _EnterResetPasswordCodeModalState
    extends State<EnterResetPasswordCodeModal> {
  AuthController authController = Get.put(AuthController());
  final UserController _userController = Get.put(UserController());

  //final otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: Get.width >= 500 ? 450.h : 500.h,
        width: Get.width >= 500 ? 600.w : 500.w,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/aesthetics/modal_bg.png'),
              fit: BoxFit.fill,
            ),
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
                    authController.otpController.text = '',
                    Get.back()
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 15.0.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          'assets/images/icons/close.png',
                          width: 35.w,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                StrokeText(
                  text: 'Code Sent',
                  textStyle: TextStyle(
                    color: const Color(0xFF1768B9),
                    fontFamily: 'Mikado',
                    fontSize: 25.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  strokeColor: Colors.white,
                  strokeWidth: 5,
                ),
                SizedBox(
                  height: 10.h,
                ),
                AutoSizeText(
                  'Kindly type in the code \nsent to your mail',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Mikado',
                  ),
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
                    onChanged: (String value) {},
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),


                Obx(
                  () => ModalBlueButton(
                    buttonText: 'Verify Code',
                    buttonIsLoading: authController.isVerifyingCode.value,
                    onTap: () => {
                      _userController.soundIsOff.isFalse
                          ? _userController.playGameSound()
                          : null,
                      if(authController.otpController.text.length == 4){
                        authController.verifyOTP(authController.otpController.text),
                      }

                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
