import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_bible_game/features/home/widget/modals/enter_reset_password_code_modal.dart';
import 'package:the_bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../../shared/constants/image_routes.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../../shared/utils/validation.dart';
import '../../../../shared/widgets/blue_button.dart';

void showResetPasswordModal(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return ResetPasswordModal();
      });
}

class ResetPasswordModal extends StatefulWidget {
  const ResetPasswordModal({super.key});

  @override
  State<ResetPasswordModal> createState() => _ResetPasswordModalState();
}

class _ResetPasswordModalState extends State<ResetPasswordModal> {
  final GlobalKey<FormState> _resetPasswordFormKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
      backgroundColor: Colors.transparent,
      insetAnimationCurve: Curves.easeIn,
      insetAnimationDuration: const Duration(milliseconds: 500),
      child: SizedBox(
        height: 500.h,
        width: 500.w,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ProductImageRoutes.modalBg),
              fit: BoxFit.fill,
            ),
          ),
          child: Form(
            key: _resetPasswordFormKey,
            child: Column(
              children: [
                SizedBox(
                  height: 50.h,
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                    ),
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
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 45.0.w),
                  child: SizedBox(
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: textController,
                      style: TextStyle(
                        height: 1.5.h,
                        color: const Color(0xFF104387),
                        fontSize: 14.sp,
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
                      onChanged: (text) => {},
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                BlocConsumer<AuthenticationBloc, AuthenticationState>(
                  listener: (context, state) {
                    if (state.forgotPasswordMailSent) {
                      Navigator.pop(context);
                      Flushbar(
                        message: 'An OTP has been sent to your account email address',
                        flushbarPosition: FlushbarPosition.TOP,
                        flushbarStyle: FlushbarStyle.GROUNDED,
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 3),
                      ).show(context);
                      showEnterResetPasswordCodeModal(context);
                    }
                  },
                  builder: (context, state) {
                    return BlueButton(
                      width: 250.w,
                      buttonText: 'Send Code',
                      buttonIsLoading: state.isSendingForgotPasswordCode,
                      onTap: () {
                        if (_resetPasswordFormKey.currentState!.validate())
                          context
                              .read<AuthenticationBloc>()
                              .add(SendForgotPasswordMail(textController.text));
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
