import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:get/get.dart';
class TabTeamScreen extends StatelessWidget {
  const TabTeamScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFF384A5E),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/aesthetics/pattern_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Container(
                height: Get.height < 680
                    ? 130
                    : (Get.height > 680 && Get.height < 800)
                    ? 150
                    : 160.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF366ABC),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.r),
                    bottomRight: Radius.circular(10.r),
                  ),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0xFFF3DB3E),
                        offset: Offset(0, 10),
                        blurRadius: 0,
                        spreadRadius: -3),
                    BoxShadow(
                        color: Color(0xFFEF798A),
                        offset: Offset(0, 8),
                        blurRadius: 0,
                        spreadRadius: -4),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child:  Center(
                              child: StrokeText(
                                text: 'Fantasy Bible League',
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Mikado',
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                                strokeColor: const Color(0xFF05477B) ,
                                strokeWidth: 5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Image.asset('assets/images/aesthetics/fbl_coming_soon.png',
                width: 300.w,
              ),
              SizedBox(
                height: 30.h,
              ),
              Text('Play and win with your friends!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontFamily: 'Mikado',
                    fontWeight: FontWeight.w700
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      )
    );
  }
}
