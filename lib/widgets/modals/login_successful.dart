import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
class LoginSuccessfulModal extends StatelessWidget {
  const LoginSuccessfulModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: SizedBox(
          height:  Get.width >= 500 ? 450.h : 450.h,
          width:  Get.width >= 500 ? 600.h : 350,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/modal_layout_2.png'),
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
                  onTap: () => {
                    player.setAsset('assets/audios/click.mp3'),
                    player.play(),
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
                const SizedBox(height: 20,),
                Image.asset('assets/images/icons/success_mark.png', width: 80,),
                const SizedBox(height: 50,),
                AutoSizeText(
                  'LOG IN SUCCESSFUL',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Neuland',
                      fontSize: 18.sp,
                      color: const Color(0xFF4075BB)
                  ),),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
