import 'package:bible_game/features/global_challenge/bloc/global_challenge_bloc.dart';
import 'package:bible_game/features/story_mode/bloc/story_mode_bloc.dart';
import 'package:bible_game/features/true_or_false/bloc/true_or_false_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/features/four_scriptures/bloc/four_scriptures_one_word_bloc.dart';
import 'package:bible_game/features/pilgrim_progress/bloc/pilgrim_progress_bloc.dart';
import 'package:bible_game/features/quick_game/bloc/quick_game_bloc.dart';
import 'package:bible_game/features/who_is_who/bloc/who_is_who_bloc.dart';
import 'package:bible_game/shared/constants/app_routes.dart';
import 'package:bible_game/shared/constants/colors.dart';

import '../../navigation/cubit/navigation_cubit.dart';
import '../features/settings/bloc/settings_bloc.dart';

void showQuitModal(BuildContext context, {String? gameMode}) {
  showDialog(
      barrierDismissible: true,
      barrierColor: const Color.fromRGBO(0, 0, 0, 0.7),
      context: context,
      builder: (BuildContext context) {
        return QuitModal(
          gameMode: gameMode ?? '',
        );
      });
}

class QuitModal extends StatelessWidget {
  const QuitModal({Key? key, this.gameMode = ''}) : super(key: key);
  final String gameMode;

  void _handleQuit(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    soundManager.playClickSound();

    if (gameMode == 'fourScriptures') {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.home, (Route<dynamic> route) => false);
      BlocProvider.of<FourScripturesOneWordBloc>(context)
          .add(ClearFourScripturesOneWordData());
    } else if (gameMode == 'pilgrimProgress') {
      BlocProvider.of<PilgrimProgressBloc>(context)
          .add(ClearPilgrimProgressData());
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.pilgrimProgressHomeScreen,
        ModalRoute.withName('/home'),
      );
    } else if (gameMode == 'whoIsWho') {
      BlocProvider.of<WhoIsWhoBloc>(context).add(ClearWhoIsWhoGameData());
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.whoIsWhoHomeScreen,
        ModalRoute.withName('/home'),
      );
    } else if (gameMode == 'quickGame') {
      BlocProvider.of<QuickGameBloc>(context).add(ClearQuickGameData());
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.quickGameHomeScreen,
        ModalRoute.withName('/home'),
      );
    } else if (gameMode == 'globalchallenge') {
      BlocProvider.of<GlobalChallengeBloc>(context)
          .add(ClearGlobalChallengeGameData());
      Navigator.pushReplacementNamed(context, AppRoutes.home);
      context.read<NavigationCubit>().selectTab(3);
    } else if (gameMode == 'storyMode') {
      BlocProvider.of<StoryModeBloc>(context).add(ResetStoryGame());
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.chapterMapScreen,
        ModalRoute.withName(AppRoutes.storySelectionScreen),
      );
    } else if (gameMode == 'trueOrFalse') {
      BlocProvider.of<TrueOrFalseBloc>(context).add(ResetTrueOrFalseGame());
      Navigator.pop(context); // close modal
      Navigator.pop(context); // back to home
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.home, (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 40.w),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A3A6B),
              Color(0xFF0F2957),
              Color(0xFF0A1E42),
            ],
          ),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 30,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Text(
              '😢',
              style: TextStyle(fontSize: 40.sp),
            ),

            SizedBox(height: 18.h),

            // Title
            Text(
              'Leaving so soon?',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),

            SizedBox(height: 8.h),

            // Subtitle
            Text(
              'Your progress in this round\nwon\'t be saved.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.white54,
                height: 1.5,
              ),
            ),

            SizedBox(height: 28.h),

            // Primary — Keep Playing
            GestureDetector(
              onTap: () {
                soundManager.playClickSound();
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4A90D9), Color(0xFF366ABC)],
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF366ABC).withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  'Keep Playing',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 15.sp,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // Secondary — Quit
            GestureDetector(
              onTap: () => _handleQuit(context),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 13.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: Text(
                  'Quit',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white38,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
