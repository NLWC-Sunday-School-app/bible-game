import 'package:flutter/material.dart';
import '../../../shared/constants/image_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GroupGameCard extends StatelessWidget {
  const GroupGameCard({super.key, required this.title, required this.backgroundColor, required this.cardImage, required this.onTap, this.isEnabled = true, this.onInfoTap});

  final String title;
  final Color backgroundColor;
  final String cardImage;
  final VoidCallback onTap;
  final bool isEnabled;

  /// Opens the explanation of this mode. The icon is only drawn when this is
  /// supplied, and it sits above the card's own tap target so it still works
  /// on a disabled card -- a mode you cannot play yet is exactly the one you
  /// are most likely to want explained.
  final VoidCallback? onInfoTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          // passthrough, not the default loose fit: a Stack hands non-positioned
          // children loose constraints, which let the card shrink to its
          // intrinsic width and stranded the info icon in the gap beside it.
          child: Stack(
            fit: StackFit.passthrough,
            children: [
          Container(
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
                // Same 32.h footprint as the Create button, so swapping it out
                // does not shift the card or the grid around it.
                if (isEnabled)
                  Image.asset(
                    ProductImageRoutes.groupCardButton,
                    height: 32.h,
                  )
                else
                  Container(
                    height: 32.h,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00418B).withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: const Color(0xFF00418B).withValues(alpha: 0.28),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Coming soon',
                      style: TextStyle(
                        color: const Color(0xFF00418B),
                        fontWeight: FontWeight.w700,
                        fontSize: 12.sp,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
              ],
            ),
          ),
              if (onInfoTap != null)
                Positioned(
                  top: 2.h,
                  right: 2.w,
                  child: GestureDetector(
                    onTap: onInfoTap,
                    behavior: HitTestBehavior.opaque,
                    // Generous padding: the icon itself is well under the 44pt
                    // minimum tap target.
                    child: Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Image.asset(
                        IconImageRoutes.infoCircle,
                        width: 18.w,
                        height: 18.w,
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

