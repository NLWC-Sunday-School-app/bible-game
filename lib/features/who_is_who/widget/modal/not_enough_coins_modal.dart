import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/shared/constants/image_routes.dart';

void showNotEnoughCoinsModal(BuildContext context, {required VoidCallback onTap}) {
  showDialog(
    barrierDismissible: true,
    barrierColor: const Color.fromRGBO(40, 40, 40, 0.9),
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        insetAnimationCurve: Curves.bounceInOut,
        insetAnimationDuration: const Duration(milliseconds: 500),
        child: NotEnoughCoinsModal(
          onTap: onTap,
        ),
      );
    },
  );
}

class NotEnoughCoinsModal extends StatelessWidget {
  const NotEnoughCoinsModal({Key? key, required this.onTap}) : super(key: key);
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 25.w),
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: screenWidth >= 500
            ? 400.h
            : screenHeight >= 800
            ? 450.h
            : 500.h,
        width: screenWidth >= 500 ? 400.h : 500.h,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ProductImageRoutes.notEnoughCoinsBg),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: EdgeInsets.only(right: 30.0.w),
                child: Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: onTap,
                    child: Image.asset(
                      IconImageRoutes.redCircleClose,
                      width: 55.w,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: StrokeText(
                  text: 'You don’t have enough \n    coins to keep playing',
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  strokeColor: const Color(0xFFC08404),
                  strokeWidth: 5,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Play more games to earn coins.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              InkWell(
                onTap: onTap,
                child: Container(
                  width: 250.w,
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      image: const DecorationImage(
                        image: AssetImage(
                          ProductImageRoutes.notEnoughCoinsBtnBg,
                        ),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(
                          color: const Color(0xFFC08404), width: 2.w),
                      borderRadius: BorderRadius.all(Radius.circular(10.r))),
                  child: Text(
                    'Go home',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 1,
                      color: const Color(0xFFC08404),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
