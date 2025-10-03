import 'package:flutter/material.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/constants/image_routes.dart';

class GroupCardButton extends StatelessWidget {
  const GroupCardButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 5.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.r),
          image: DecorationImage(
            image: AssetImage(ProductImageRoutes.homeScreenPlayButtonBg),
            fit: BoxFit.cover,
          ),
        ),
        child:  StrokeText(
          text: 'Create',
          textStyle: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700
          ),
          strokeColor: const Color(0xFF228209),
          strokeWidth: 3,
        ),
      ),
    );
  }
}
