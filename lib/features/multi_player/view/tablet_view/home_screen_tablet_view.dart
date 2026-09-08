import 'package:bible_game/features/arcade/cubit/arcade_tab_cubit.dart';
import 'package:bible_game/features/multi_player/view/home_screen.dart';
import 'package:bible_game/navigation/cubit/navigation_cubit.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../../shared/constants/app_routes.dart';
import '../../../../shared/constants/colors.dart';
import '../../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../../shared/widgets/screen_app_bar.dart';

/// Tablet chrome around [MultiplayerHomeBody].
///
/// The body itself is shared with the phone screen and the arcade tab, so the
/// create/join/requests behaviour cannot drift between layouts. Only the app
/// bar sizing and the content width cap differ here.
class MultiplayerHomeScreenTabletView extends StatelessWidget {
  const MultiplayerHomeScreenTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;

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
                      onTap: () {
                        soundManager.playClickSound();
                        context.read<ArcadeTabCubit>().showMultiplayer();
                        context.read<NavigationCubit>().selectTab(3);
                        Navigator.pushNamedAndRemoveUntil(
                            context, AppRoutes.home, (route) => false);
                      },
                      child: Image.asset(
                        IconImageRoutes.arrowCircleBack,
                        width: 56.w,
                      ),
                    ),
                    const Spacer(),
                    StrokeText(
                      text: 'Multiplayer',
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
            Expanded(
              child: MultiplayerHomeBody(
                maxContentWidth: 620.w,
                bottomSpacing: 40.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
