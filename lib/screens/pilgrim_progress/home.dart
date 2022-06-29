import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class PilgrimProgressHomeScreen extends StatelessWidget {
  const PilgrimProgressHomeScreen({Key? key}) : super(key: key);
  static String routeName = "/pilgrim-progress-home-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(54, 42, 122, 1),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => {Navigator.pop(context)},
                  child: Padding(
                    padding: EdgeInsets.only(left: 22.0.w, top: 30.h),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios_new,
                          size: 15.w,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        const Text(
                          'Back home',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Image.asset(
                  'assets/images/pilgrim_progress_cloud.png',
                  width: 200.w,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.0.w),
              child: Container(
                margin: EdgeInsets.only(top: 100.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 23.0.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                fontSize: 10.sp, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'learning deeper when you progress',
                            style: TextStyle(
                                fontSize: 10.sp, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 14.h,
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: ClipRRect(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(18.r),
                            bottom: Radius.circular(18.r)),
                        child: SvgPicture.asset(
                          'assets/images/pilgrim_progress.svg',
                          width: 150.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: EdgeInsets.only(top: 400.h),
                child: Image.asset(
                  'assets/images/pilgrim_right_cloud.png',
                  width: 180.w,
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(top: 530.h),
                child: Image.asset(
                  'assets/images/pilgrim_left_cloud.png',
                  width: 180.w,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 250.h),
              child: Column(
                children: [
                  Row(
                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/baby_level.png',
                            width: 150.w,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 40.0.w, bottom: 10.h),
                            child: Text(
                              'Babe',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.sp
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/child.png',
                            width: 150.w,
                          ),
                           Padding(
                              padding: EdgeInsets.only(left: 40.0.w, bottom: 10.h),
                              child: Text(
                                'Child',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.sp
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/locked_young_believer.png',
                            width: 150.w,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 40.0.w, bottom: 10.h),
                            child: Text(
                              'Young believer',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.sp
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/locked_charity.png',
                            width: 150.w,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 40.0.w, bottom: 10.h),
                            child: Text(
                              'Charity',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.sp
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/locked_father.png',
                            width: 150.w,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 40.0.w, bottom: 10.h),
                            child: Text(
                              'Father',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.sp
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/locked_elder.png',
                            width: 150.w,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 40.0.w, bottom: 10.h),
                            child: Text(
                              'Elder',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.sp
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
