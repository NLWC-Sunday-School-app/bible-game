import 'package:another_flushbar/flushbar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/features/home/widget/modals/set_new_password_modal.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';

import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/widgets/blue_button.dart';
import '../../../../shared/widgets/custom_toast.dart';

void showEnterResetPasswordCodeModal(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return EnterResetPasswordCodeModal();
      });
}

class EnterResetPasswordCodeModal extends StatefulWidget {
  const EnterResetPasswordCodeModal({Key? key}) : super(key: key);

  @override
  State<EnterResetPasswordCodeModal> createState() =>
      _EnterResetPasswordCodeModalState();
}

class _EnterResetPasswordCodeModalState
    extends State<EnterResetPasswordCodeModal> {
  final textController = TextEditingController();

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
              image: AssetImage(ProductImageRoutes.modalBg),
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
                  onTap: () => Navigator.pop(context),
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
                  text: 'Code Sent',
                  textStyle: TextStyle(
                    color: const Color(0xFF1768B9),
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
                    controller: textController,
                    onCompleted: (text) {},
                    appContext: context,
                    onChanged: (String value) {},
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                BlocConsumer<AuthenticationBloc, AuthenticationState>(
                  listener: (context, state) {
                      if(state.hasVerifiedCode){
                        Navigator.pop(context);
                        showCustomToast(context, 'Verification successful');

                        showSetNewPasswordModal(context);
                      }
                  },
                  builder: (context, state) {
                    return BlueButton(
                      width: 250.w,
                      buttonText: 'Verify Code',
                      buttonIsLoading: state.isVerifyingCode,
                      onTap: () {
                        if (textController.text.length == 4) {
                             context.read<AuthenticationBloc>().add(VerifyOTP(textController.text));
                        }
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
