import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stroke_text/stroke_text.dart';

class TabStoreScreen extends StatelessWidget {
  const TabStoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              text: 'Store',
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
            Image.asset('assets/images/aesthetics/fbl_coming_soon.gif',
             width: 300.w,
            ),
            SizedBox(
              height: 0.h,
            ),
            Text('Store up this gold,\n moth & rust can’t destroy it!',
             textAlign: TextAlign.center,
             style: TextStyle(
               color: Colors.white,
               fontSize: 20.sp,
               fontFamily: 'Mikado',
               fontWeight: FontWeight.w700
             ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
