import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:launch_review/launch_review.dart';
import 'package:stroke_text/stroke_text.dart';

class AppUpdateModal extends StatelessWidget {
  const AppUpdateModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 25.w),
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: Get.width >= 500 ? 400.h : Get.height >= 800 ? 350.h : 450.h,
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
              Center(
                child: StrokeText(
                  text: 'There’s a new game \n     update for you!',
                  textStyle: TextStyle(
                    color: const Color(0xFF1768B9),
                    fontFamily: 'Mikado',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  strokeColor: Colors.white,
                  strokeWidth: 5,
                ),
              ),
              SizedBox(height: 20.h,),
              Text('New features, better performance and \nmore fun for you and your friends!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Mikado',
                    fontWeight: FontWeight.w500
                ),
              ),
              SizedBox(height: 40.h,),
              GestureDetector(
                onTap: () => {
                  // player.setAsset('assets/audios/click.mp3'),
                  // player.play(),
                  // Get.back(),
                LaunchReview.launch(
                androidAppId: 'com.nlwc.bible.game',
                iOSAppId: 'id1663041338',
                writeReview: false
                )
                },
                child: Container(
                  width: 250.w,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: const Color(0xFF548BD5),
                      image: const DecorationImage(
                        image: AssetImage(
                            "assets/images/aesthetics/update_btn_bg.png"),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(color: const Color(0xFF1E62D4), width: 2.w),
                      borderRadius:
                      BorderRadius.all(Radius.circular(10.r))),
                  child: Text(
                    'Update app now',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Mikado',
                        letterSpacing: 1,
                        color: const Color(0xFFFFFFFF),
                        fontSize: 16.sp,
                      fontWeight: FontWeight.w700
                    ),
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
