import 'dart:async';

import 'package:bible_game/shared/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:bible_game/shared/features/user/model/user.dart';

import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../../shared/utils/custom_toast.dart';

void showStreakModal(BuildContext context) {
  showDialog(
      context: context,
      barrierColor: const Color.fromRGBO(40, 40, 40, 0.95),
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          backgroundColor: Colors.transparent,
          insetAnimationCurve: Curves.easeIn,
          insetAnimationDuration: const Duration(milliseconds: 500),
          child: BgStreakModal(),
        );
      });
}

class BgStreakModal extends StatefulWidget {
  const BgStreakModal({super.key});

  @override
  State<BgStreakModal> createState() => _BgStreakModalState();
}

class _BgStreakModalState extends State<BgStreakModal> {
  late DateTime expiryTime;
  late Duration timeLeft;
  Timer? timer;
  bool showTimer = false;
  bool lostStreakAfterRestoreTime = false;

  @override
  void initState() {
    super.initState();
    timeLeft = Duration.zero;
    manageStreakTime();
  }

  manageStreakTime(){
    timer?.cancel();
    final streakDetails = BlocProvider.of<UserBloc>(context).state.userStreakDetails;
    final lastStreakTime = streakDetails['lastStreakTime'];
    if (lastStreakTime != null) {
      if (streakDetails['restoreTimeExpiry'] == null) {
        DateTime startTime = DateTime.parse(streakDetails['lastStreakTime']);
        expiryTime = startTime.add(Duration(hours: 24));
        timeLeft = expiryTime.difference(DateTime.now());
        showTimer = !timeLeft.isNegative;
        timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
          setState(() {
            timeLeft = expiryTime.difference(DateTime.now());
            if (timeLeft.isNegative) {
              showTimer = false;
              t.cancel();
            } else {
              showTimer = true;
            }
          });
        });
      } else {
        DateTime restoreTime =
        DateTime.parse(streakDetails['restoreTimeExpiry']);
        timeLeft = restoreTime.difference(DateTime.now());
        showTimer = !timeLeft.isNegative;
        // Settle this up front: it used to flip only on the first timer
        // tick, so an already-expired window offered a gem restore for a
        // second before correcting itself.
        lostStreakAfterRestoreTime = timeLeft.isNegative;
        if (timeLeft.isNegative) timeLeft = Duration.zero;
        timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
          setState(() {
            timeLeft = restoreTime.difference(DateTime.now());
            if (timeLeft.isNegative) {
              showTimer = false;
              lostStreakAfterRestoreTime = true;
              timeLeft = Duration.zero;
              t.cancel();
            } else {
              showTimer = true;
            }
          });
        });
      }
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    final settings = context.read<SettingsBloc>().state.gamePlaySettings;
    final restoreGemPrice = settings is Map && settings.containsKey('streak_restore_gem_price')
        ? int.tryParse(settings['streak_restore_gem_price'].toString()) ?? 1
        : 1;
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        // userStreakDetails is the raw API map and defaults to {}, so every
        // key is null until the fetch lands. isLost was read straight as a
        // bool, which threw a TypeError on that first build.
        final details = state.userStreakDetails;
        final streak = (details['streak'] as num?)?.toInt() ?? 0;
        final previousStreak = (details['previousStreak'] as num?)?.toInt() ?? 0;
        final isLost = details['isLost'] == true;
        final hasRestoreWindow = details['restoreTimeExpiry'] != null;
        // Restoring needs a lost streak AND a window that has not run out.
        final canRestore =
            isLost && hasRestoreWindow && !lostStreakAfterRestoreTime;
        return Container(
          width: 500.w,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ProductImageRoutes.streakModalBg),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                SizedBox(
                  height: 15.h,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 40.w,
                    ),
                    Spacer(),
                    StrokeText(
                      text: 'BG Streaks',
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700),
                      strokeColor: const Color(0xFF3C73BD),
                      strokeWidth: 3,
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        soundManager.playClickSound();
                        setState(() {
                          lostStreakAfterRestoreTime = false;
                          showTimer = false;
                        });
                        Navigator.pop(context);

                      },
                      child: Image.asset(
                        IconImageRoutes.blueCircleCancel,
                        width: 35.w,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
               showTimer ?
               lostStreakAfterRestoreTime ? SizedBox() : Container(
                  width: hasRestoreWindow
                      ? 220.w
                      : 160.w,
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                  decoration: BoxDecoration(
                      color: Color(0xFFDEE5E5),
                      borderRadius: BorderRadius.circular(32.r)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        IconImageRoutes.greenTimer,
                        width: 18.w,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      hasRestoreWindow
                          ? Text(
                              'Time left for restore ${formatDuration(timeLeft)}',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          : Text(
                              'Time left ${formatDuration(timeLeft)}',
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                    ],
                  ),
                ) : SizedBox(),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Container(
                    height: 135.h,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ProductImageRoutes.streakBoardBg),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Row(
                      children: [
                        RichText(
                          text: TextSpan(children: [
                            WidgetSpan(
                              child: Stack(
                                children: [
                                  Text(
                                    '$streak',
                                    style: TextStyle(
                                      fontSize: 92.sp,
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 3.w
                                        ..color = Color(0xFF925B58),
                                    ),
                                  ),
                                  Text(
                                    '$streak',
                                    style: TextStyle(
                                      fontSize: 92.sp,
                                      color: Color(0xFFC48D8A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            WidgetSpan(
                              child: Transform.translate(
                                offset: const Offset(0, -30),
                                // Adjust offset for subscript
                                child: Text(
                                  streak == 1 ? 'Day' : 'Days',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Color(0xFF925B58),
                                  ),
                                ),
                              ),
                            )
                          ]),
                        ),
                        Spacer(),
                        Image.asset(
                          IconImageRoutes.streakBoardIcon,
                          width: 40.w,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        ProductImageRoutes.streakLineDivider,
                        width: 64.w,
                      ),
                      Text(
                        isLost
                            ? 'Your streak has ended;\nPlay a game to start again.'
                            : "Don't lose your streak;\nPlay a game today.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                        ),
                      ),
                      Image.asset(
                        ProductImageRoutes.streakLineDivider,
                        width: 64.w,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                isLost
                    ? Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 18.h, bottom: 18.h),
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 75.w,
                                  right: 20.w,
                                  top: 5.h,
                                  bottom: 5.h),
                              decoration: BoxDecoration(
                                  color: Color(0xFFF8FFEE),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.r),
                                      bottomLeft: Radius.circular(30.r))),
                              child: RichText(
                                  text: TextSpan(
                                      text: 'You’ve lost your',
                                      style: TextStyle(
                                          height: 1.5,
                                          color: Color(0xFFE08921),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Mikado',
                                          fontSize: 12.sp),
                                      children: [
                                    TextSpan(
                                        text:
                                            ' $previousStreak ${previousStreak == 1 ? 'day ' : 'days '}',
                                        style: TextStyle(
                                            color: Color(0xFF436B98))),
                                    TextSpan(
                                        text:
                                            lostStreakAfterRestoreTime ? 'streak!\nPlay a game to start your streak' : 'streak!\nYou can restore it with a gem.'),
                                  ])),
                            ),
                          ),
                          Positioned(
                            top: 5.h,
                            left: 0.w,
                            bottom: 5.h,
                            child: Image.asset(
                              ProductImageRoutes.broLukeInfo,
                              width: 65.w,
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
                SizedBox(
                  height: 20.h,
                ),
               showTimer ? lostStreakAfterRestoreTime ? SizedBox() : GestureDetector(
                  onTap: () {
                    soundManager.playClickSound();
                    if (state.isRestoringStreak) return;
                    if (canRestore) {
                      if (BlocProvider.of<AuthenticationBloc>(context)
                              .state
                              .user
                              .gems <
                          restoreGemPrice) {
                        CustomToast.showBanner(context, 'Not enough gems', isError: true);
                      } else {
                        context.read<UserBloc>().add(RestoreStreak());
                        showCustomToast(context, 'Restored Successfully');
                        Future.delayed(Duration(seconds: 2), (){
                          context.read<AuthenticationBloc>().add(FetchUserDataRequested());
                          context.read<UserBloc>().add(FetchUserStreakDetails());
                          manageStreakTime();
                        });
                      }
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            !canRestore
                                ? ProductImageRoutes
                                    .streakRestoreButtonInactiveBg
                                : ProductImageRoutes.streakRestoreButtonBg,
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: state.isRestoringStreak
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                StrokeText(
                                  text: 'Restore  for',
                                  textStyle: TextStyle(
                                    color: !canRestore
                                        ? Colors.white.withOpacity(0.5)
                                        : Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  strokeColor: const Color(0xFF272D39),
                                  strokeWidth: 3,
                                ),
                                SizedBox(
                                  width: 15.w,
                                ),
                                Image.asset(
                                  IconImageRoutes.gemIcon,
                                  width: 27.w,
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                StrokeText(
                                  text: '$restoreGemPrice',
                                  textStyle: TextStyle(
                                    color: !canRestore
                                        ? Colors.white.withOpacity(0.5)
                                        : Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  strokeColor: const Color(0xFF272D39),
                                  strokeWidth: 3,
                                ),
                              ],
                            ),
                    ),
                  ),
                ): SizedBox(),
                SizedBox(
                  height: 20.h,
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 10.w),
                //   child: Container(
                //     padding: EdgeInsets.symmetric(vertical: 15.h),
                //     decoration: BoxDecoration(
                //       image: DecorationImage(
                //         image: AssetImage(ProductImageRoutes.streakFreezeButtonBg),
                //         fit: BoxFit.fill,
                //       ),
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         StrokeText(
                //           text: 'Freeze for',
                //           textStyle: TextStyle(
                //             color: Colors.white,
                //             fontSize: 18.sp,
                //             fontWeight: FontWeight.w700,
                //           ),
                //           strokeColor: const Color(0xFF272D39),
                //           strokeWidth: 3,
                //         ),
                //         SizedBox(width: 15.w,),
                //         Image.asset(
                //           IconImageRoutes.coinIcon,
                //           width: 27.w,
                //         ),
                //         SizedBox(width: 5.w,),
                //         StrokeText(
                //           text: '1000',
                //           textStyle: TextStyle(
                //             color: Colors.white,
                //             fontSize: 18.sp,
                //             fontWeight: FontWeight.w700,
                //           ),
                //           strokeColor: const Color(0xFF272D39),
                //           strokeWidth: 3,
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          );
        },
      );
    }
}
