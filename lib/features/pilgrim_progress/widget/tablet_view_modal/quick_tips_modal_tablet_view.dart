import 'package:bible_game/shared/widgets/tablet_view_widget/blue_button_tablet_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:bible_game/features/pilgrim_progress/bloc/pilgrim_progress_bloc.dart';

import 'package:bible_game/shared/constants/app_routes.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:bible_game/shared/widgets/blue_button.dart';

void showPilgrimProgressTipsModalTabletView(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PilgrimProgressTipsModalTabletView();
      });
}

class PilgrimProgressTipsModalTabletView extends StatelessWidget {
  const PilgrimProgressTipsModalTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final settingsState = BlocProvider.of<SettingsBloc>(context).state;
    final soundManager = context.read<SettingsBloc>().soundManager;
    var formatter = NumberFormat('#,##,###');
    return BlocBuilder<PilgrimProgressBloc, PilgrimProgressState>(
      builder: (context, state) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
          backgroundColor: Colors.transparent,
          insetAnimationCurve: Curves.bounceInOut,
          insetAnimationDuration: const Duration(milliseconds: 500),
          child: SizedBox(
            height: 651.h,
            width: 500.w,
            child: Stack(
              children: [
                Align(
                  alignment:Alignment.bottomCenter,
                  child: Container(
                    height: 604.h,
                    padding: EdgeInsets.symmetric(horizontal: 82).w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12.r)),
                        color: Colors.white,
                        border: Border.all(color: Color(0xFFCD0E33))
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 80.h,
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
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
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
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
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
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
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
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
                        SizedBox(
                          height: 30.h,
                        ),
                        BlueButtonTabletView(
                          height: 72.h,
                          width: 1.sw,
                          buttonText: 'Play Now',
                          buttonIsLoading: false,
                          onTap: () {
                            soundManager.playClickSound();
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.pilgrimProgressQuestionScreen,
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Image.asset(
                    ProductImageRoutes.quickTipsTabletView,
                    fit: BoxFit.contain,
                    width: 358.w,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
