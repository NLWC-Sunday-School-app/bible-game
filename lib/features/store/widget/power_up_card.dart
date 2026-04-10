import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import '../../../shared/constants/image_routes.dart';
import '../model/power_up.dart';

class PowerUpCard extends StatelessWidget {
  const PowerUpCard({
    super.key,
    required this.item,
    required this.quantity,
    required this.onBuy,
    required this.isPurchasing,
  });

  final PowerUpItem item;
  final int quantity;
  final VoidCallback onBuy;
  final bool isPurchasing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A3A6B),
            const Color(0xFF0D2550),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFF4A8AD4).withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: emoji + quantity badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Center(
                  child: Text(
                    item.emoji,
                    style: TextStyle(fontSize: 22.sp),
                  ),
                ),
              ),
              if (quantity > 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7FB800),
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7FB800).withOpacity(0.4),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Text(
                    'x$quantity',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 10.h),

          // Name
          Text(
            item.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4.h),

          // Description
          Text(
            item.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),

          // Buy button
          GestureDetector(
            onTap: isPurchasing ? null : onBuy,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B8BEB), Color(0xFF1A65C4)],
                ),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: const Color(0xFFA6CAF6).withOpacity(0.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A65C4).withOpacity(0.3),
                    offset: const Offset(0, 3),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: isPurchasing
                  ? Center(
                      child: SizedBox(
                        height: 14.w,
                        width: 14.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          item.usesGems
                              ? IconImageRoutes.gemIcon
                              : IconImageRoutes.coinIcon,
                          width: 16.w,
                        ),
                        SizedBox(width: 5.w),
                        Text(
                          '${item.price}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
