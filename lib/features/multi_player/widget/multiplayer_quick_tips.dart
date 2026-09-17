import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/constants/image_routes.dart';

/// How a multiplayer round scores, shown in the waiting room.
///
/// This used to be a modal on the loading screen that auto-routed into the
/// game three seconds later -- long enough to see, not to read. Giving it a
/// button would not have helped either: the per-question clock starts when
/// each player's question screen mounts, so a player who taps straight through
/// begins answering seconds ahead of one who actually reads, and these tips
/// say speed is what wins. The waiting room is the one place where reading is
/// free: nobody's clock is running and everybody is waiting anyway.
class MultiplayerQuickTips extends StatelessWidget {
  const MultiplayerQuickTips({super.key, this.secondsPerQuestion});

  /// The host's configured seconds per question, or null when this side of
  /// the room has not been told. The copy drops the number rather than
  /// inventing one: the tip used to read "7seconds" hard-coded, while the
  /// host's own form defaults to 8 and goes up from there.
  final int? secondsPerQuestion;

  @override
  Widget build(BuildContext context) {
    final seconds = secondsPerQuestion;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lightbulb_outline_rounded,
                  size: 15.sp, color: const Color(0xFF122F52)),
              SizedBox(width: 5.w),
              Text(
                'Quick Tips',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF122F52),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          _Tip(
            text: 'First place gets the most points\n- be fast and accurate!',
            background: const Color(0xFFF8E193),
            border: const Color(0xFFBE9F37),
            asset: IconImageRoutes.quickTipsIconOne,
          ),
          SizedBox(height: 8.h),
          _Tip(
            text: "Speed is crucial - you're racing\nother players",
            background: const Color(0xFFE7F2E6),
            border: const Color(0xFF7FB57A),
            asset: ProductImageRoutes.rocket,
          ),
          SizedBox(height: 8.h),
          _Tip(
            // "quickyly" in the original.
            text: seconds == null
                ? 'Questions vanish fast\n- answer quickly!'
                : 'Questions vanish after $seconds seconds\n- answer quickly!',
            background: Colors.white,
            border: const Color(0xFF7FB57A),
            asset: IconImageRoutes.quickTipsIconTwo,
          ),
        ],
      ),
    );
  }
}

class _Tip extends StatelessWidget {
  const _Tip({
    required this.text,
    required this.background,
    required this.border,
    required this.asset,
  });

  final String text;
  final Color background;
  final Color border;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10.w),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Image.asset(asset, width: 48.w),
        ],
      ),
    );
  }
}
