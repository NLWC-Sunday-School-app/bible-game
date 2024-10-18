import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/widgets/blue_button.dart';
import '../../../../shared/constants/image_routes.dart';
import 'login_modal.dart';

void showResetPasswordSuccessModal(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return ResetPasswordSuccessModal();
      });
}

class ResetPasswordSuccessModal extends StatelessWidget {
  const ResetPasswordSuccessModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: SizedBox(
          height: Get.width >= 500 ? 450.h : 500.h,
          width: Get.width >= 500 ? 600.h : 350.w,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.modalBg),
                  fit: BoxFit.fill),
            ),
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
                          width: 40.w,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Image.asset(
                  ProductImageRoutes.successfulMark,
                  width: 80.w,
                ),
                const SizedBox(
                  height: 50,
                ),
                AutoSizeText(
                  'New password set \nsuccessfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF4075BB)),
                ),
                const SizedBox(
                  height: 50,
                ),
                BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    return state.user.id == 0
                        ? BlueButton(
                            buttonText: 'LOG IN',
                            buttonIsLoading: false,
                            width: 250.w,
                            onTap: () {
                              Navigator.pop(context);
                              showLoginModal(context);
                            },
                          )
                        : SizedBox();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
