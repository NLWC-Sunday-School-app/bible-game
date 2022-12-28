
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
              height: 11,
              width: 11,
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
             SvgPicture.asset(difficultyImage),

            SizedBox(
              height: 5.h,
            ),
            Text(
              difficultyLevel,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color.fromRGBO(91, 73, 191, 1),
              ),
            )
          ],
        ),
       isActive ? Container(
          margin: EdgeInsets.only(top: Get.height < 680 ? 70.h : 60.h, left: Get.height < 680 ? 50.h : 40.h),
          child: SvgPicture.asset(checkerImage),
        ): const SizedBox(),
      ],
    );
  }
}
