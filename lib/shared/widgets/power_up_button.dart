import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PowerUpButton extends StatelessWidget {
  final String label;
  final String subLabel;
  final bool isUsed;
  final bool hasEnoughCoins;
  final VoidCallback onTap;
  final Color activeColor;

  const PowerUpButton({
    super.key,
    required this.label,
    required this.subLabel,
    required this.isUsed,
    required this.hasEnoughCoins,
    required this.onTap,
    this.activeColor = const Color(0xFF366ABC),
  });

  @override
  Widget build(BuildContext context) {
    final bool canUse = !isUsed && hasEnoughCoins;

    return GestureDetector(
      onTap: canUse ? onTap : null,
      child: Opacity(
        opacity: isUsed ? 0.35 : (hasEnoughCoins ? 1.0 : 0.5),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: isUsed ? Colors.grey.shade700 : activeColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isUsed ? Colors.grey : Colors.white.withValues(alpha: 0.5),
              width: 1.5,
            ),
            boxShadow: canUse
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.5),
                      blurRadius: 6,
                      spreadRadius: 1,
                    )
                  ]
                : [],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Neuland',
                ),
              ),
              Text(
                isUsed ? 'used' : subLabel,
                style: TextStyle(
                  fontSize: 9.sp,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
