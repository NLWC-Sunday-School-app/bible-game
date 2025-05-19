import 'dart:async';

import 'package:another_flushbar/flushbar.dart';
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

void showStreakModalTabletView(BuildContext context) {
  showDialog(
      context: context,
      barrierColor: const Color.fromRGBO(40, 40, 40, 0.95),
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          backgroundColor: Colors.transparent,
          insetAnimationCurve: Curves.easeIn,
          insetAnimationDuration: const Duration(milliseconds: 500),
          child: BgStreakModalTabletView(),
        );
      });
}

class BgStreakModalTabletView extends StatefulWidget {
  const BgStreakModalTabletView({super.key});

  @override
  State<BgStreakModalTabletView> createState() => _BgStreakModalTabletViewState();
}

class _BgStreakModalTabletViewState extends State<BgStreakModalTabletView> {
  late DateTime expiryTime;
  late Duration timeLeft;
  late Timer timer;
  bool showTimer = false;
  bool lostStreakAfterRestoreTime = false;

  @override
  @override
  void initState() {
    super.initState();
    timeLeft = Duration(hours: 0, minutes: 0, seconds: 0);
    manageStreakTime();
  }

  manageStreakTime(){
    final streakDetails = BlocProvider.of<UserBloc>(context).state.userStreakDetails;
    final lastStreakTime = streakDetails['lastStreakTime'];
    if (lastStreakTime != null) {
      if (streakDetails['restoreTimeExpiry'] == null) {
        DateTime startTime = DateTime.parse(streakDetails['lastStreakTime']);
        expiryTime = startTime.add(Duration(hours: 24));
        timeLeft = expiryTime.difference(DateTime.now());
        timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
          setState(() {
            timeLeft = expiryTime.difference(DateTime.now());
            if (timeLeft.isNegative) {
              timer.cancel();
            }else{
              setState(() {
                showTimer = true;
              });
            }
          });
        });
      } else {
        DateTime restoreTime =
        DateTime.parse(streakDetails['restoreTimeExpiry']);
        DateTime lastStreakTime = DateTime.parse(streakDetails['lastStreakTime']);
        timeLeft = restoreTime.difference(DateTime.now());

        timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
          setState(() {
            timeLeft = restoreTime.difference(DateTime.now());
            if (timeLeft.isNegative) {
              showTimer = false;
              lostStreakAfterRestoreTime = true;
              timeLeft = Duration.zero;
              timer.cancel();
            }else{
              setState(() {
                showTimer = true;
              });
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
    timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Container(
          height: state.userStreakDetails['restoreTimeExpiry'] != null
              ? 624.h
              : 560.h,
          width: 638.w,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ProductImageRoutes.streakModalBgTabletView),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 60.h,
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
                width: state.userStreakDetails['restoreTimeExpiry'] != null
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
                    state.userStreakDetails['restoreTimeExpiry'] != null
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
                padding: EdgeInsets.symmetric(horizontal: 153.w),
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
                                  state.userStreakDetails['streak']
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 92.sp,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 3.w
                                      ..color = Color(0xFF925B58),
                                  ),
                                ),
                                Text(
                                  state.userStreakDetails['streak']
                                      .toString(),
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
                                state.userStreakDetails['streak'] == 1 ? 'Day' : 'Days',
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
                padding: EdgeInsets.symmetric(horizontal: 153.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      ProductImageRoutes.streakLineDivider,
                      width: 64.w,
                    ),
                    Text(
                      "Don't lose your streak;\nPlay a game today.",
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
              state.userStreakDetails['restoreTimeExpiry'] != null
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
                                          ' ${state.userStreakDetails['previousStreak']} ${state.userStreakDetails['previousStreak'] == 1 ? 'day ' : 'days '}',
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
                  if (state.userStreakDetails['isLost'] &&
                      state.userStreakDetails['restoreTimeExpiry'] != null) {
                    if (BlocProvider.of<AuthenticationBloc>(context)
                            .state
                            .user
                            .gems <
                        1) {
                      Flushbar(
                        message: 'Not enough gems',
                        flushbarPosition: FlushbarPosition.TOP,
                        flushbarStyle: FlushbarStyle.GROUNDED,
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 3),
                      ).show(context);
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
                  padding: EdgeInsets.symmetric(horizontal: 150.w),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          !state.userStreakDetails['isLost'] &&
                                  state.userStreakDetails[
                                          'restoreTimeExpiry'] ==
                                      null
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
                                  color: !state.userStreakDetails['isLost'] &&
                                          state.userStreakDetails[
                                                  'restoreTimeExpiry'] ==
                                              null
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
                                text: '1',
                                textStyle: TextStyle(
                                  color: !state.userStreakDetails['isLost'] &&
                                          state.userStreakDetails[
                                                  'restoreTimeExpiry'] ==
                                              null
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
