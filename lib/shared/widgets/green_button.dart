import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/constants/image_routes.dart';

class GreenButton extends StatelessWidget {
  const GreenButton(
      {super.key,
      this.onTap,
      required this.buttonIsLoading,
      required this.width,
      this.customWidget,
      this.isActive = true});

  final VoidCallback? onTap;
  final bool buttonIsLoading;
  final double width;
  final Widget? customWidget;
  final bool? isActive;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: 55.h,
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          image: DecorationImage(
            image: AssetImage(
              isActive!
                  ? ProductImageRoutes.streakRestoreButtonBg
                  :  ProductImageRoutes.streakRestoreButtonInactiveBg,
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: buttonIsLoading
            ? Center(
                child: SizedBox(
                    height: 20.w,
                    width: 20.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    )),
              )
            : customWidget,
      ),
    );
  }
}
