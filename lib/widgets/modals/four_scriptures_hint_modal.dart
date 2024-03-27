import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FourScripturesHintModal extends StatelessWidget {
  const FourScripturesHintModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 0.w),
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: Get.width >= 500
            ? 300.h
            : Get.height >= 800
                ? 350.h
                : 400.h,
        width: Get.width >= 500 ? 400.h : 500.h,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/aesthetics/announcement_bg.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 30.0.w),
                child: Align(
                  alignment: Alignment.topRight,
                    child: InkWell (
                      onTap: () => Get.back(),
                      child: Image.asset(
                  'assets/images/icons/blue_close.png',
                  width: 48.w,
                ),
                    )),
              ),
              SizedBox(
                height: 10.h,
              ),
              Image.asset(
                'assets/images/aesthetics/thunder_flag.png',
                width: 160.w,
              ),
              Text(
                'Hints are here!',
                style: TextStyle(
                    fontFamily: 'Mikado',
                    fontSize: 24.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Buy one letter hint to decipher the \nanswer and move to the next level!',
                style: TextStyle(
                    fontFamily: 'Mikado',
                    fontSize: 14.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ),
    );
  }
}
