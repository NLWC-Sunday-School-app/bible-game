import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import '../../../../shared/constants/image_routes.dart';

void showSuccessfulRegistrationModal(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
          backgroundColor: Colors.transparent,
          insetAnimationCurve: Curves.easeIn,
          insetAnimationDuration: const Duration(milliseconds: 500),
          child: SizedBox(
            height: 400.h,
            width: 400.w,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.successfulModalBg),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 40.h,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            IconImageRoutes.closeModal,
                            width: 35.w,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Image.asset(
                    ProductImageRoutes.successfulMark,
                    width: 80.w,
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  StrokeText(
                    text: 'Profile created \n successfully!',
                    textStyle: TextStyle(
                      color: const Color(0xFF1768B9),
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w900,
                    ),
                    strokeColor: Colors.white,
                    strokeWidth: 5,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'Enjoy the Bible game!',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
}
