import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/shared/constants/app_routes.dart';
import 'package:bible_game/shared/constants/colors.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/widgets/blue_button.dart';
import 'package:bible_game/shared/widgets/screen_app_bar.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
import '../bloc/true_or_false_bloc.dart';

class TrueOrFalseHomeScreen extends StatefulWidget {
  const TrueOrFalseHomeScreen({super.key});

  @override
  State<TrueOrFalseHomeScreen> createState() => _TrueOrFalseHomeScreenState();
}

class _TrueOrFalseHomeScreenState extends State<TrueOrFalseHomeScreen> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<TrueOrFalseBloc>();
    if (!bloc.state.isLoaded) {
      bloc.add(LoadTrueOrFalseData());
    }
  }

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: AppColors.primaryColorShade,
      ),
      backgroundColor: const Color(0xFF014AA0),
      body: BlocBuilder<TrueOrFalseBloc, TrueOrFalseState>(
        builder: (context, state) {
          return SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.patternTwoBg),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  // App bar header
                  ScreenAppBar(
                    widgets: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              soundManager.playClickSound();
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              IconImageRoutes.arrowCircleBack,
                              width: 44.w,
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: StrokeText(
                                text: 'True or False',
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                                strokeColor: AppColors.titleDropShadowColor,
                                strokeWidth: 6,
                              ),
                            ),
                          ),
                          SizedBox(width: 44.w),
                        ],
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 30.h),
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),

                          // Stats cards
                          Row(
                            children: [
                              Expanded(
                                child: _StatCard(
                                  label: 'High Score',
                                  value: state.highScore.toString(),
                                  icon: IconImageRoutes.coinIcon,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: _StatCard(
                                  label: 'Games Played',
                                  value: state.totalGamesPlayed.toString(),
                                  icon: IconImageRoutes.purpleBook,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12.h),
                          _StatCard(
                            label: 'Best Streak',
                            value: state.bestStreak.toString(),
                            icon: IconImageRoutes.streakIcon,
                            isWide: true,
                          ),

                          SizedBox(height: 40.h),

                          // How to play section
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'How to Play',
                                  style: TextStyle(
                                    fontFamily: 'Mikado',
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.accentColor,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'Read each Bible statement and decide\nif it is TRUE or FALSE.\n\nAnswer quickly for bonus points!\nBuild streaks for multipliers!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Mikado',
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 40.h),

                          // Play button
                          BlueButton(
                            buttonText: 'Play Now',
                            buttonIsLoading: !state.isLoaded,
                            width: 280.w,
                            onTap: state.isLoaded
                                ? () {
                                    soundManager.playClickSound();
                                    context
                                        .read<TrueOrFalseBloc>()
                                        .add(StartTrueOrFalseGame());
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.trueOrFalseQuestionScreen,
                                    );
                                  }
                                : null,
                          ),

                          SizedBox(height: 30.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Stat card widget
// -----------------------------------------------------------------------------

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    this.isWide = false,
  });

  final String label;
  final String value;
  final String icon;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isWide ? double.infinity : null,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.deepBlue.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColors.accentColor.withValues(alpha: 0.3),
          width: 2.w,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            offset: const Offset(0, 4),
            blurRadius: 0,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment:
            isWide ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Image.asset(icon, width: 32.w),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Mikado',
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Mikado',
                  fontWeight: FontWeight.w900,
                  color: AppColors.accentColor,
                  fontSize: 22.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
