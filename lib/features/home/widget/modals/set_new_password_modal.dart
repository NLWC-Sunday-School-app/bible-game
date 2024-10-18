import 'package:another_flushbar/flushbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/features/home/widget/modals/reset_password_success_modal.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';

import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/utils/validation.dart';
import '../../../../shared/widgets/blue_button.dart';

void showSetNewPasswordModal(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return SetNewPasswordModal();
      });
}

class SetNewPasswordModal extends StatefulWidget {
  const SetNewPasswordModal({Key? key}) : super(key: key);

  @override
  State<SetNewPasswordModal> createState() => _SetNewPasswordModalState();
}

class _SetNewPasswordModalState extends State<SetNewPasswordModal> {
  bool isToggle = true;
  bool isToggle2 = true;
  final GlobalKey<FormState> _newPasswordFormKey = GlobalKey<FormState>();
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
                image: AssetImage(ProductImageRoutes.modalBg),
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
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 15.0.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          IconImageRoutes.closeModal,
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
                  text: 'Set Password',
                  textStyle: TextStyle(
                    color: const Color(0xFF1768B9),
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
                  'You are in control now, \nset a new password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Mikado',
                  ),
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
                          fontSize: 14.sp,
                        ),
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
                                    IconImageRoutes.eyeOpen,
                                    scale: 1.5,
                                  )
                                : Image.asset(
                                    IconImageRoutes.eyeClose,
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
                            fontSize: 14.sp,
                            fontFamily: 'Mikado'),
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
                                    IconImageRoutes.eyeOpen,
                                    scale: 1.5,
                                  )
                                : Image.asset(
                                    IconImageRoutes.eyeClose,
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
                        onChanged: (text) => {}),
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                BlocConsumer<AuthenticationBloc, AuthenticationState>(
                  listener: (context, state) {
                    if (state.hasResetPassword) {
                      Navigator.pop(context);
                      Flushbar(
                        message: 'Password reset successful',
                        flushbarPosition: FlushbarPosition.TOP,
                        flushbarStyle: FlushbarStyle.GROUNDED,
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 3),
                      ).show(context);

                      showResetPasswordSuccessModal(context);
                    }
                  },
                  builder: (context, state) {
                    return BlueButton(
                      width: 250.w,
                      buttonText: 'Set new password',
                      buttonIsLoading: state.isResettingPassword,
                      onTap: () {
                        if (_newPasswordFormKey.currentState!.validate()) ;
                        context
                            .read<AuthenticationBloc>()
                            .add(ResetPassword(newPasswordController.text));
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
