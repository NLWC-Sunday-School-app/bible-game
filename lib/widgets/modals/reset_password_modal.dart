import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/widgets/modals/enter_reset_password_code_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';
import '../../utilities/validator.dart';
import '../button/modal_blue_button.dart';

class ResetPasswordModal extends StatefulWidget {
  const ResetPasswordModal({Key? key}) : super(key: key);

  @override
  State<ResetPasswordModal> createState() => _ResetPasswordModalState();
}

class _ResetPasswordModalState extends State<ResetPasswordModal> {
  final GlobalKey<FormState> _resetPasswordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    UserController _userController = Get.put(UserController());
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: Get.width >= 500 ? 450.h : 500.h,
        width: Get.width >= 500 ? 600.w : 500.w,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/aesthetics/modal_bg.png'),
                fit: BoxFit.fill),
          ),
          child: Form(
            key: _resetPasswordFormKey,
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
                  text: 'Reset password',
                  textStyle: TextStyle(
                    color: const Color(0xFF1768B9),
                    fontFamily: 'Mikado',
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  strokeColor: Colors.white,
                  strokeWidth: 5,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  'Fear not, you can reset your \npassword.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Mikado'
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 45.0.w),
                  child: SizedBox(
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                          height: 1.5.h,
                          color: const Color(0xFF104387),
                          fontSize: 12.sp,
                          fontFamily: 'Mikado'
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFD4DDDF),
                        focusColor: Colors.red,
                        errorStyle: TextStyle(fontSize: 12.sp),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: 'Please input your registered email',
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
                      onChanged: (text) => {
                        authController.forgotPasswordMail.value = text,
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                Obx(
                  () => ModalBlueButton(
                    buttonText: 'Send Code',
                    buttonIsLoading: authController.isSendingCode.value,
                      onTap: () => {
                        _userController.soundIsOff.isFalse
                            ? _userController.playGameSound()
                            : null,
                        if (_resetPasswordFormKey.currentState!.validate())
                          {authController.sendForgotPasswordMail()}
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
