import 'package:flutter/material.dart';
import '../../../shared/constants/image_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupGameCard extends StatelessWidget {
  const GroupGameCard({super.key, required this.title, required this.backgroundColor, required this.cardImage, required this.onTap});

  final String title;
  final Color backgroundColor;
  final String cardImage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Container(
          padding: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(width: 2.w, color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFFFE9C7),
                offset: Offset(2, 4),
                blurRadius: 0,
                spreadRadius: -2,
              ),
            ],
          ),
          // height: 188.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                cardImage,
                width: 80.w,
                height: 80.h,
              ),
              SizedBox(height: 12.h,),
              Text(
                title,
                style: TextStyle(
                  color: Color(0xFF00418B),
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 21.h,),
              Image.asset(
                ProductImageRoutes.groupCardButton,
                height: 32.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

