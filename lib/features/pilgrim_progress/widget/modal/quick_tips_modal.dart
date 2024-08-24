import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:the_bible_game/features/pilgrim_progress/bloc/pilgrim_progress_bloc.dart';

import 'package:the_bible_game/shared/constants/app_routes.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';
import 'package:the_bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:the_bible_game/shared/widgets/blue_button.dart';

void showPilgrimProgressTipsModal(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PilgrimProgressTipsModal();
      });
}

class PilgrimProgressTipsModal extends StatelessWidget {
  const PilgrimProgressTipsModal({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final settingsState = BlocProvider.of<SettingsBloc>(context).state;
    var formatter = NumberFormat('#,##,###');
    return BlocBuilder<PilgrimProgressBloc, PilgrimProgressState>(
      builder: (context, state) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
          backgroundColor: Colors.transparent,
          insetAnimationCurve: Curves.bounceInOut,
          insetAnimationDuration: const Duration(milliseconds: 500),
          child: SizedBox(
            height: 500.h,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(ProductImageRoutes.quickTipsBigBg),
                      fit: BoxFit.fill)),
              child: Column(
                children: [
                  SizedBox(
                    height: 80.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                          color: const Color(0xFFE7E2FF),
                          border: Border.all(color: Color(0xFFBE9F37)),
                          borderRadius: BorderRadius.circular(8.r)),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10.w, top: 10.h, bottom: 10.h),
                            child: RichText(
                              text: TextSpan(
                                  text: 'You have',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: const Color(0xFF22210D),
                                      height: 1.5),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            ' ${state.roundsLeftForSelectedLevel}/${state.noOfTrialForSelectedLevel} trials',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF22210D))),
                                    TextSpan(
                                        text: ' left, \nGod speed Sojourner!',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: const Color(0xFF22210D))),
                                  ]),
                            ),
                          ),
                          Spacer(),
                          Image.asset(
                            IconImageRoutes.coinIcon,
                            width: 56.w,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                          color: const Color(0xFFF8E193),
                          border: Border.all(color: Color(0xFFBE9F37)),
                          borderRadius: BorderRadius.circular(8.r)),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10.w, top: 10.h, bottom: 10.h),
                            child: RichText(
                              text: TextSpan(
                                  text: 'Get ',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: const Color(0xFF22210D),
                                      height: 1.5),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            '${settingsState.gamePlaySettings['pass_on_first_trial_score']} points',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF22210D))),
                                    TextSpan(
                                      text:
                                          ' in one game \nplay to unlock new level!',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          color: const Color(0xFF22210D)),
                                    )
                                  ]),
                            ),
                          ),
                          Spacer(),
                          Image.asset(
                            IconImageRoutes.coinIcon,
                            width: 56.w,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                          color: const Color(0xFFF9ACBB),
                          border: Border.all(color: Color(0xFFBE9F37)),
                          borderRadius: BorderRadius.circular(8.r)),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10.w, top: 10.h, bottom: 10.h),
                            child: RichText(
                              text: TextSpan(
                                  text: 'Or Get ',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: const Color(0xFF22210D),
                                      height: 1.5),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            '${formatter.format(state.totalCoinsAvailableForSelectedLevel)} points',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF22210D))),
                                    TextSpan(
                                      text:
                                          ' in ${state.noOfTrialForSelectedLevel} \ntrials to unlock new level!',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          color: const Color(0xFF22210D)),
                                    )
                                  ]),
                            ),
                          ),
                          Spacer(),
                          Image.asset(
                            IconImageRoutes.coinIcon,
                            width: 56.w,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                          color: const Color(0xFFE7E2FF),
                          border: Border.all(color: Color(0xFFBE9F37)),
                          borderRadius: BorderRadius.circular(8.r)),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 10.w, top: 10.h, bottom: 10.h),
                            child: RichText(
                              text: TextSpan(
                                  text:
                                      'Your points will be deleted \nif you don’t complete level\n',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: const Color(0xFF22210D),
                                      height: 1.5),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text:
                                            ' after ${state.noOfTrialForSelectedLevel} trials.',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF22210D))),
                                  ]),
                            ),
                          ),
                          Spacer(),
                          Image.asset(
                            IconImageRoutes.coinIcon,
                            width: 56.w,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  BlueButton(
                    buttonText: 'Play Now',
                    buttonIsLoading: false,
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.pilgrimProgressQuestionScreen,
                    ),
                    width: 280.w,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
