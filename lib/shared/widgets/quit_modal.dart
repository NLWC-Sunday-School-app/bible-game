import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/features/global_challenge/bloc/global_challenge_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/features/four_scriptures/bloc/four_scriptures_one_word_bloc.dart';
import 'package:bible_game/features/pilgrim_progress/bloc/pilgrim_progress_bloc.dart';
import 'package:bible_game/features/quick_game/bloc/quick_game_bloc.dart';
import 'package:bible_game/features/who_is_who/bloc/who_is_who_bloc.dart';
import 'package:bible_game/shared/constants/app_routes.dart';
import 'package:bible_game/shared/constants/image_routes.dart';

import '../../navigation/cubit/navigation_cubit.dart';
import '../features/settings/bloc/settings_bloc.dart';

void showQuitModal(BuildContext context, {String? gameMode}) {
  final soundManager = context.read<SettingsBloc>().soundManager;
  showDialog(
      barrierDismissible: true,
      barrierColor: const Color.fromRGBO(40, 40, 40, 0.9),
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

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 25.w),
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: SizedBox(
          height: 450.h,
          width: double.infinity,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ProductImageRoutes.modalBg),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'ARE YOU SURE YOU\n WANT TO QUIT?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF4075BB),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'You will lose unsaved progress.',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                    soundManager.playClickSound();
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 200.w,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        color: const Color(0xFFE8F8FF),
                        border: Border.all(color: const Color(0xFF548CD7)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(40))),
                    child: Text(
                      'NO, I DONT',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: const Color(0xFF4075BB),
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    soundManager.playClickSound();
                    if (gameMode == 'fourScriptures') {
                      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home,
                          (Route<dynamic> route) => false);
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
                      BlocProvider.of<WhoIsWhoBloc>(context)
                          .add(ClearWhoIsWhoGameData());
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.whoIsWhoHomeScreen,
                        ModalRoute.withName('/home'),
                      );
                    } else if (gameMode == 'quickGame') {
                      BlocProvider.of<QuickGameBloc>(context)
                          .add(ClearQuickGameData());
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.quickGameHomeScreen,
                        ModalRoute.withName('/home'),
                      );
                    } else if (gameMode == 'globalchallenge') {
                      BlocProvider.of<GlobalChallengeBloc>(context)
                          .add(ClearGlobalChallengeGameData());
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.home
                      );
                      context.read<NavigationCubit>().selectTab(3);
                    } else {
                      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home,
                          (Route<dynamic> route) => false);
                    }
                  },
                  child: Container(
                    width: 200.w,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        color: const Color(0xFF548CD7),
                        border: Border.all(color: const Color(0xFF548CD7)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(40))),
                    child: Text(
                      'YES, QUIT',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: Colors.white,
                          fontSize: 14.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
