import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/colors.dart';

class ScreenAppBar extends StatelessWidget {
  const ScreenAppBar({super.key, required this.widgets});

  final List<Widget> widgets;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryColorShade,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.r),
          bottomRight: Radius.circular(10.r),
        ),
        boxShadow: [
          BoxShadow(
              color: AppColors.accentColor,
              offset: Offset(0, 10),
              blurRadius: 0,
              spreadRadius: -3),
          BoxShadow(
            color: AppColors.screenTopBorder,
            offset: Offset(0, 8),
            blurRadius: 0,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: widgets,
        ),
      ),
    );
  }
}
