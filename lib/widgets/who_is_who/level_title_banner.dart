import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LevelTitleBanner extends StatelessWidget {
  const LevelTitleBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Image.asset(
            'assets/images/icons/string.png',
            width: 60.w,
          ),
          Expanded(
            child: ClipPath(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color(0xFF0072EE), width: 3.w),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.r)),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.w, vertical: 10.h),
                  decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage("assets/images/aesthetics/pattern_bg.png"),
                        fit: BoxFit.cover,
                      ),
                      color: const Color(0xFF084E9A),
                      border: Border.all(
                          color: Colors.white, width: 2.w),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4.r))),
                  child: Text(
                    'Fair Haven',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Mikado',
                        fontWeight: FontWeight.w900,
                        fontSize: 18.sp),
                  ),
                ),
              ),
            ),
          ),
          Image.asset(
            'assets/images/icons/string.png',
            width: 60.w,
          ),
        ],
      ),
    );
  }
}
