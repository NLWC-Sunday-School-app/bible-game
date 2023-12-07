import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stroke_text/stroke_text.dart';

class WiwNotEnoughCoinsModal extends StatelessWidget {
  const WiwNotEnoughCoinsModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 25.w),
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: Get.width >= 500
            ? 400.h
            : Get.height >= 800
            ? 350.h
            : 450.h,
        width: Get.width >= 500 ? 500.h : 400.h,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image:
              AssetImage('assets/images/aesthetics/not_enough_coins_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.only(right: 30.0.w),
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: Image.asset(
                      'assets/images/icons/blue_close.png',
                      width: 48.w,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: StrokeText(
                  text: 'You don’t have enough \n    coins to keep playing',
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Mikado',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  strokeColor: const Color(0xFFC08404),
                  strokeWidth: 5,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Play more games to earn coins.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: 'Mikado',
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              SizedBox(
                height: 40.h,
              ),
              InkWell(
                onTap: (){
                  Get.back();
                  Get.back();
                },
                child: Container(
                  width: 250.w,
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      image: const DecorationImage(
                        image: AssetImage(
                            "assets/images/aesthetics/not_enough_coins_btn_bg.png"),
                        fit: BoxFit.cover,
                      ),
                      border:
                      Border.all(color: const Color(0xFFC08404), width: 2.w),
                      borderRadius: BorderRadius.all(Radius.circular(10.r))),
                  child: Text(
                    'Go home',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Mikado',
                        letterSpacing: 1,
                        color: const Color(0xFFC08404),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700),
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
