import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/image_routes.dart';

class PowerUpBarItem {
  final String label;
  final String iconPath;
  final int quantity;
  final bool isUsed;
  final bool isAuto;
  final Color accentColor;
  final VoidCallback? onTap;

  const PowerUpBarItem({
    required this.label,
    required this.iconPath,
    required this.quantity,
    required this.isUsed,
    this.isAuto = false,
    required this.accentColor,
    this.onTap,
  });
}

class PowerUpBar extends StatelessWidget {
  final List<PowerUpBarItem> items;

  const PowerUpBar({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    // Filter to only show items the user actually has (quantity > 0 or already used this game)
    final visibleItems = items.where((i) => i.quantity > 0 || i.isUsed).toList();
    if (visibleItems.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: visibleItems.map((item) {
        final canUse = !item.isUsed && item.quantity > 0 && !item.isAuto;
        return GestureDetector(
          onTap: canUse ? item.onTap : null,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: item.isUsed ? 0.35 : 1.0,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: item.isUsed
                    ? Colors.grey.shade800
                    : item.accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: item.isUsed
                      ? Colors.grey.shade600
                      : item.accentColor.withOpacity(0.6),
                  width: 1.5,
                ),
                boxShadow: canUse
                    ? [
                        BoxShadow(
                          color: item.accentColor.withOpacity(0.3),
                          blurRadius: 6,
                          spreadRadius: 1,
                        )
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    item.iconPath,
                    width: 16.w,
                    height: 16.w,
                    color: item.isUsed ? Colors.grey : null,
                  ),
                  SizedBox(width: 4.w),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w800,
                          color: item.isUsed ? Colors.grey : Colors.white,
                        ),
                      ),
                      Text(
                        item.isUsed
                            ? 'Used'
                            : item.isAuto
                                ? 'Auto'
                                : 'x${item.quantity}',
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: item.isUsed
                              ? Colors.grey.shade500
                              : Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
