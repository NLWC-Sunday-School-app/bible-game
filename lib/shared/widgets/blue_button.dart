import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';

class BlueButton extends StatelessWidget {
  const BlueButton({
    super.key,
    required this.buttonText,
    this.onTap,
    required this.buttonIsLoading,
    required this.width,
    this.customText,
    this.customWidget,
    this.hasCustomWidget = false,
    this.height = 55,
    this.isActive = true
  });

  final String buttonText;
  final customText;
  final VoidCallback? onTap;
  final bool buttonIsLoading;
  final double width;
  final double? height;
  final Widget? customWidget;
  final bool? hasCustomWidget;
  final bool? isActive;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height:  height,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        decoration: BoxDecoration(
          border: Border.all(color: isActive! ? const Color(0xFF1E62D4) : const Color(0xFF8E8E8E) , width: 3.w),
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          image: DecorationImage(
            image: AssetImage(
              isActive! ? ProductImageRoutes.blueButtonBg : ProductImageRoutes.inactiveBlueButtonBg,
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: !hasCustomWidget!
            ? buttonIsLoading
                ? Center(
                    child: SizedBox(
                        height: 20.w,
                        width: 20.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        )),
                  )
                : customText != null
                    ? customText
                    : Center(
                      child: Text(
                          buttonText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                    )
            : customWidget,
      ),
    );
  }
}
