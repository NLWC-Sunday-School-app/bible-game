import 'package:bible_game/screens/onboarding/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../screens/tabs/tab_main_screen.dart';

class NoNetworkModal extends StatelessWidget {
  const NoNetworkModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      backgroundColor: Colors.transparent,
      child: SizedBox(
         height: 280.h,
        // width: 350.h,
        child: Container(
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Connection Error${Get.height}',
                style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Unable to connect to the server.\n check your internet connection and try again',
                style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 30.h,
              ),
              GestureDetector(
                onTap: () {
                  Get.offAll(() => const SplashScreen());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                   decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.circular(10)
                   ),
                    child: Text('Try again', style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp
                    ),)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
