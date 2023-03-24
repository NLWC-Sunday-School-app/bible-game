
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DifficultyLevelMeter extends StatelessWidget {
  final String difficultyLevel;
  final Color dotColor;
  final bool isActive;
  final String difficultyImage;
  final String checkerImage;

  const DifficultyLevelMeter({
    Key? key,
    required this.difficultyLevel,
    required this.dotColor,
    required this.isActive,
    required this.difficultyImage,
    required this.checkerImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              height: 11.w,
              width: 11.w,
              child: isActive ? Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor,
                ),
              ) : const SizedBox(),
            ),
            SizedBox(
              height: 8.h,
            ),
             Get.width > 900 ? SvgPicture.asset(difficultyImage, width: 70.w,) : SvgPicture.asset(difficultyImage,),

            SizedBox(
              height: 5.h,
            ),
            Text(
              difficultyLevel,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF323B63),
                fontSize: 14.sp
              ),
            )
          ],
        ),
       isActive ? Container(
          margin: Get.width > 900 ? EdgeInsets.only(top: 70.h, left: 80) : EdgeInsets.only(top: Get.height < 680 ? 70.h : 60.h, left: Get.height < 680 ? 50.h : 40.h),
          child: Get.width > 900 ? SvgPicture.asset(checkerImage, width: 50.w) : SvgPicture.asset(checkerImage,),
        ): const SizedBox(),
      ],
    );
  }
}
