import 'package:bible_game/widgets/modals/nativity_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';

import '../../controllers/global_game_controller.dart';

class NativityInfo extends StatelessWidget {
  const NativityInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 15.w),
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: Get.width >= 500 ? 500.h : Get.height >= 800 ? 400.h : 450.h,
        width: Get.width >= 500 ? 500.h : 400.h,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/nativity_info_layout.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 30.h,),
              Row(
                children: [
                  SizedBox(width: 20.h,),
                  SvgPicture.asset('assets/images/icons/luke_nativity.svg', width: 230.w,),
                ],
              ),
              SizedBox(height: 20.h,),
              Text(
                'The global story',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24.sp,
                    fontFamily: 'Neuland',
                    color: Colors.white
                ),
              ),
              SizedBox(height: 20.h,),
              Text('Be a part of this live global challenge, \ntest your knowledge of the scriptures \nalongside your brethren.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                ),
              ),
              SizedBox(height: 40.h,),
              GestureDetector(
                onTap: () async {
                  player.setAsset('assets/audios/click.mp3');
                  player.play();
                  Get.back();
                  Get.dialog(const NativityLoader(), barrierDismissible: true);
                },
                child: Container(
                  width: 250.w,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                      borderRadius:
                      const BorderRadius.all(Radius.circular(40))),
                  child: Text(
                    'join the challenge',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Neuland',
                        letterSpacing: 1,
                        color: const Color(0xFFA96823),
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
