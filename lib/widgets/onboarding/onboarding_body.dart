import 'package:flutter/material.dart';
import '../circle_dot.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingBody extends StatelessWidget {
  final String imageUrl;
  final String buttonText;
  final VoidCallback goToNextScreen;

  const OnboardingBody(
      {Key? key,
      required this.imageUrl,
      required this.buttonText,
      required this.goToNextScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 280.h),
            child: Image.asset(
              imageUrl,
              // height: 588.h,
              // width: 288.w,
            ),
          ),
          Positioned(
            top: 650.h,
            left: 20.w,
            child: InkWell(
              onTap: goToNextScreen,
              child: Container(
                padding: EdgeInsets.only(
                  left: 96.w,
                  right: 96.w,
                  top: 16.h,
                  bottom: 16.h,
                ),
                decoration: BoxDecoration(
                    color: const Color(0xfff2f3f7),
                    borderRadius: BorderRadius.circular(20.r)),
                child: Text(
                  buttonText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, color: Color(0xFF362A7A)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
