import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:the_bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../../shared/constants/image_routes.dart';
import 'login_modal.dart';

void showResetPasswordSuccessModal (BuildContext context){
  showDialog(
    context: context,
    builder: (BuildContext context){
      return ResetPasswordSuccessModal();
    }
  );
}


class ResetPasswordSuccessModal extends StatelessWidget {
  const ResetPasswordSuccessModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: SizedBox(
          height: Get.width >= 500 ? 450.h : 550.h,
          width: Get.width >= 500 ? 600.h : 350,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.modalBg),
                  fit: BoxFit.fill
              ),
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
            const SizedBox(height: 20,),
            Image.asset(ProductImageRoutes.successfulMark, width: 80.w,),
            const SizedBox(height: 50,),
            AutoSizeText(
              'New password set \nsuccessfully!',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF4075BB)
              ),),
            const SizedBox(height: 50,),
            BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                return state.user.id == 0 ? Container(
                  width: 200.w,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: const Color(0xFFE8F8FF),
                      border: Border.all(color: const Color(0xFF548CD7)),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(40))),
                  child: Text(
                    'LOG IN',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        letterSpacing: 1,
                        color: const Color(0xFF4075BB),
                        fontSize: 14.sp),
                  ),
                ) : SizedBox();
              },
            ),
          ],
        ),
      ),
    ),)
    ,
    );
  }
}
