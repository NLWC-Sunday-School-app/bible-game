import 'package:flutter/material.dart';
import '../../../shared/constants/image_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GamePlayCard extends StatelessWidget {
  const GamePlayCard({super.key, required this.title, required this.text, required this.backgroundImage, required this.swordImage, required this.onTap});

  final String title;
  final String text;
  final String backgroundImage;
  final String swordImage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.fill
            ),
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
          height: 85.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Color(0xFF014CA3),
                      fontWeight: FontWeight.w900,
                      fontSize: 20.sp,
                    ),
                  ),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 12.sp,
                    ),
                  )
                ],
              ),
              Image.asset(
               swordImage,
                width: 65.w,
              )
            ],
          ),
        ),
      ),
    );
  }
}

