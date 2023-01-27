import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
class RetryLevelScreen extends StatelessWidget {
  const RetryLevelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/pilgrim_levels/retry_level.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 150.h,
          ),
          Text(
            'retry level',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20.sp,
                fontFamily: 'neuland',
                fontWeight: FontWeight.w400,
                letterSpacing: 2,
                color: Colors.white,
                decoration: TextDecoration.none),
          ),
          SizedBox(
            height: 100.h,
          ),
          Image.asset(
            'assets/images/icons/group_star.png',
            width: 200.w,
          ),
          SizedBox(
            height: 60.h,
          ),
          Text(
            'Oops! you couldn’t \ncomplete the goal \nplay again.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20.sp,
                fontFamily: 'neuland',
                height: 1.5,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                decoration: TextDecoration.none),
          ),
          SizedBox(
            height: 100.h,
          ),
          GestureDetector(
            onTap: () =>  {
              Get.back()
            },
            child: Text(
              'Tap to continue',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.sp,
                  fontFamily: 'neuland',
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  decoration: TextDecoration.none),
            ),
          ),
        ],
      ),
    );
  }
}
