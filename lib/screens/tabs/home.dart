import 'package:bible_game/widgets/onboarding/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TabHomeScreen extends StatelessWidget {
  const TabHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(54, 42, 122, 1),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                  left: 21.w, right: 0.w, bottom: 40.h, top: 10.h),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(118, 99, 229, 1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Good Morning',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      const Text(
                        'Olarenwaju',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Image.asset('assets/images/cloud.png'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 22.w, right: 22.w),
              child: Column(
                children: [
                  SizedBox(
                    height: 160.h,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 15.w, bottom: 15.w),
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.r),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(118, 99, 229, 1),
                            offset: Offset(0, 25),
                            blurRadius: 1,
                            spreadRadius: -14)
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Your High Score',
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color.fromRGBO(52, 42, 122, 1)),
                        ),
                        Text(
                          '1560',
                          style: TextStyle(
                              fontSize: 65.sp, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Play more games to earn more points',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 38.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.r),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(118, 99, 229, 1),
                            offset: Offset(0, 25),
                            blurRadius: 1,
                            spreadRadius: -14)
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
                                height: 21.h,
                              ),
                              Text(
                                'Quick Game',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color.fromRGBO(124, 110, 203, 1),
                                ),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Text(
                                'Memorize scripture',
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'through short quizzes',
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 14.h,
                              ),
                              Container(
                                  padding: EdgeInsets.only(
                                    left: 21.w,
                                    right: 21.w,
                                    top: 10.h,
                                    bottom: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color.fromRGBO(254, 193, 75, 1),
                                        Color.fromRGBO(224, 153, 16, 1),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: const Text(
                                    'PLAY NOW',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  )),
                              SizedBox(
                                height: 16.h,
                              ),
                            ],
                          ),
                        ),

                        Flexible(
                            child: SvgPicture.asset(
                          'assets/images/bible_image.svg',
                        )),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 38.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.r),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(118, 99, 229, 1),
                            offset: Offset(0, 25),
                            blurRadius: 1,
                            spreadRadius: -14)
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
                                height: 21.h,
                              ),
                              Text(
                                'Pilgrim Progress',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color.fromRGBO(124, 110, 203, 1),
                                ),
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Text(
                                'Make a journey through the bible',
                                style: TextStyle(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'learning deeper when you progress',
                                style: TextStyle(
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 14.h,
                              ),
                              Container(
                                  padding: EdgeInsets.only(
                                    left: 21.w,
                                    right: 21.w,
                                    top: 10.h,
                                    bottom: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color.fromRGBO(254, 193, 75, 1),
                                        Color.fromRGBO(224, 153, 16, 1),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: const Text(
                                    'PLAY NOW',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFFFFFFF),
                                    ),
                                  )),
                              SizedBox(
                                height: 16.h,
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: SvgPicture.asset(
                            'assets/images/pilgrim_progress.svg',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 38.h,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'What’s Coming',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 25.w, bottom: 25.w),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/gift_image.png',
                        ),
                        Text(
                          'Ads',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
