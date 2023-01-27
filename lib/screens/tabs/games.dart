import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import '../../widgets/modals/nativity_info.dart';

class TabGamesScreen extends StatelessWidget {
  const TabGamesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 25.h),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF32B1F2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/games_cloud.png',
                    width: 240.w,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 80.h),
              child: Text(
                'Live Challenge',
                style: TextStyle(
                    fontFamily: 'Neuland',
                    letterSpacing: 1,
                    fontSize: 20.sp,
                    color: Colors.white),
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0.w),
                margin: EdgeInsets.only(
                  top: 220.h,
                ),
                child: Column(
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF97D3FF),
                          borderRadius: BorderRadius.circular(15.r),
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0xFFFEC14B),
                                offset: Offset(0, 15),
                                blurRadius: 0,
                                spreadRadius: -10)
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 23.0.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Image.asset(
                                    'assets/images/global.png',
                                    height: 25,
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  AutoSizeText(
                                    'NATIVITY STORY',
                                    style: TextStyle(
                                      letterSpacing: 0.5,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Neuland',
                                      color: const Color.fromRGBO(
                                          124, 110, 203, 1),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8.h,
                                  ),
                                  Text(
                                    'How well do you know the',
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'Nativity story? Test yourself.',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 14.h,
                                  ),
                                  GestureDetector(
                                    onTap: () => {
                                      player
                                          .setAsset('assets/audios/click.mp3'),
                                      player.play(),
                                     // Get.dialog(const NativityInfo(), barrierDismissible: true)
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                        left: 21.w,
                                        right: 21.w,
                                        top: 10.h,
                                        bottom: 10.h,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            const Color.fromRGBO(110, 91, 220, 1).withOpacity(0.2),
                                            const Color.fromRGBO(60, 46, 144, 1).withOpacity(0.4),
                                          ],
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      child: Text(
                                        'NOT LIVE',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.sp,
                                          color: const Color(0xFFFFFFFF),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 16.h,
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15.r),
                                    bottom: Radius.circular(15.r)),
                                child: Image.asset(
                                  'assets/images/baby_jesus.png',
                                  width: Get.width >= 600 ? 120.w : 150.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
