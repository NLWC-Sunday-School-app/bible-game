import 'package:bible_game/features/multi_player/view/group_game_category.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../../shared/constants/colors.dart';
import '../../../../shared/widgets/screen_app_bar.dart';

/// Tablet chrome around [GroupGameCategoryBody].
///
/// The mode grid and its bloc wiring are shared with the phone screen; only
/// the app bar sizing and the content width cap differ.
class GroupGameCategoryTabletView extends StatelessWidget {
  const GroupGameCategoryTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: AppColors.primaryColorShade,
      ),
      backgroundColor: const Color(0xFF2D6BB6),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ProductImageRoutes.patternTwoBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            ScreenAppBar(
              height: 90.h,
              widgets: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        IconImageRoutes.arrowCircleBack,
                        width: 56.w,
                      ),
                    ),
                    const Spacer(),
                    StrokeText(
                      text: 'Group Game',
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 34.sp,
                        fontWeight: FontWeight.w900,
                      ),
                      strokeColor: AppColors.titleDropShadowColor,
                      strokeWidth: 6,
                    ),
                    const Spacer(),
                    SizedBox(width: 56.w),
                  ],
                ),
                SizedBox(height: 24.h),
              ],
            ),
            SizedBox(height: 16.h),
            Expanded(child: GroupGameCategoryBody(maxContentWidth: 700.w)),
          ],
        ),
      ),
    );
  }
}
