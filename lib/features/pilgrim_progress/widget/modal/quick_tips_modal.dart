import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:the_bible_game/shared/constants/app_routes.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';
import 'package:the_bible_game/shared/widgets/blue_button.dart';

void showPilgrimProgressTipsModal(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return PilgrimProgressTipsModal();
      });
}

class PilgrimProgressTipsModal extends StatelessWidget {
  const PilgrimProgressTipsModal({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
      backgroundColor: Colors.transparent,
      insetAnimationCurve: Curves.bounceInOut,
      insetAnimationDuration: const Duration(milliseconds: 500),
      child: SizedBox(
        height: 500.h,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.quickTipsBigBg),
                  fit: BoxFit.fill)),
          child: Column(
            children: [
              SizedBox(
                height: 80.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                      color: Color(0xFFF8E193),
                      border: Border.all(color: Color(0xFFBE9F37)),
                      borderRadius: BorderRadius.circular(8.r)),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10.w, top: 10.h, bottom: 10.h),
                        child: Text(
                          'Bonus point for when you \nget all questions right!',
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.5),
                        ),
                      ),
                      Spacer(),
                      Image.asset(
                        IconImageRoutes.coinIcon,
                        width: 56.w,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                      color: Color(0xFFF8E193),
                      border: Border.all(color: Color(0xFFBE9F37)),
                      borderRadius: BorderRadius.circular(8.r)),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10.w, top: 10.h, bottom: 10.h),
                        child: Text(
                          'Bonus point for when you \nget all questions right!',
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.5),
                        ),
                      ),
                      Spacer(),
                      Image.asset(
                        IconImageRoutes.coinIcon,
                        width: 56.w,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                      color: Color(0xFFF8E193),
                      border: Border.all(color: Color(0xFFBE9F37)),
                      borderRadius: BorderRadius.circular(8.r)),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10.w, top: 10.h, bottom: 10.h),
                        child: Text(
                          'Bonus point for when you \nget all questions right!',
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.5),
                        ),
                      ),
                      Spacer(),
                      Image.asset(
                        IconImageRoutes.coinIcon,
                        width: 56.w,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                      color: Color(0xFFF8E193),
                      border: Border.all(color: Color(0xFFBE9F37)),
                      borderRadius: BorderRadius.circular(8.r)),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 10.w, top: 10.h, bottom: 10.h),
                        child: Text(
                          'Bonus point for when you \nget all questions right!',
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.5),
                        ),
                      ),
                      Spacer(),
                      Image.asset(
                        IconImageRoutes.coinIcon,
                        width: 56.w,
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              BlueButton(
                buttonText: 'Play Now',
                buttonIsLoading: false,
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.pilgrimProgressQuestionScreen,
                ),
                width: 280.w,
              )
            ],
          ),
        ),
      ),
    );
    ;
  }
}
