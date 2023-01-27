import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class WelcomeModal extends StatelessWidget {
  const WelcomeModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 25.w),
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: Get.width >= 500 ? 500.h : Get.height >= 800 ? 400.h : 450.h,
        width: Get.width >= 500 ? 500.h : 400.h,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/welcome_layout.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 30.h,),
              Row(
                children: [
                  SizedBox(width: 30.h,),
                  SvgPicture.asset('assets/images/icons/bro_luke.svg', width: 200.w,),
                ],
              ),
              SizedBox(height: 20.h,),
              Text(
                'Welcome to the \nbible game!',
               textAlign: TextAlign.center,
               style: TextStyle(
                 fontSize: 20.sp,
                 fontFamily: 'Neuland',
                 color: const Color(0xFF548BD5)
               ),
              ),
              SizedBox(height: 20.h,),
              Text('I hope as you play daily you can grow \n& test your bible knowledge with \nall your friends.',
               textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500
                ),
              ),
              SizedBox(height: 40.h,),
              GestureDetector(
                onTap: () => {
                  player.setAsset('assets/audios/click.mp3'),
                  player.play(),
                  Get.back(),
                },
                child: Container(
                  width: 250.w,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: const Color(0xFF548BD5),
                      border: Border.all(color: const Color(0xFF548CD7)),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(40))),
                  child: Text(
                    'Got It!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Neuland',
                        letterSpacing: 1,
                        color: const Color(0xFFFFFFFF),
                        fontSize: 14.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
