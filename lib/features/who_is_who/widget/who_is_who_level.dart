import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/features/who_is_who/bloc/who_is_who_bloc.dart';
import 'package:bible_game/features/who_is_who/widget/modal/freebies_modal.dart';
import 'package:bible_game/features/who_is_who/widget/modal/wiw_time_up_modal.dart';
import 'package:bible_game/shared/constants/app_routes.dart';
import 'package:bible_game/shared/constants/image_routes.dart';

import '../../../shared/features/settings/bloc/settings_bloc.dart';

class WhoIsWhoLevel extends StatefulWidget {
  const WhoIsWhoLevel(
      {Key? key,
      required this.isUnLocked,
      required this.level,
      required this.backgroundUrl,
      required this.isSpecialLevel,
      required this.playTime,
      required this.reward,
      required this.nextLevelIsLocked})
      : super(key: key);
  final bool isUnLocked;
  final String level;
  final String backgroundUrl;
  final bool isSpecialLevel;
  final int playTime;
  final int reward;
  final bool nextLevelIsLocked;

  @override
  State<WhoIsWhoLevel> createState() => _WhoIsWhoLevelState();
}

class _WhoIsWhoLevelState extends State<WhoIsWhoLevel> {
  void showCustomToast(BuildContext context, String message) {
    FToast fToast = FToast();
    fToast.init(context);
    LinearGradient linearGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color.fromRGBO(34, 34, 34, 0.0),
        Color.fromRGBO(34, 34, 34, 0.2333),
        Color.fromRGBO(34, 34, 34, 0.141846),
        Color.fromRGBO(136, 136, 136, 0.0),
      ],
      stops: [
        0.0,
        0.375,
        0.62,
        1.0,
      ],
    );
    Widget toast = Container(
        width: 375.w,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        decoration: BoxDecoration(
          gradient: linearGradient,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StrokeText(
              text: message,
              textStyle: TextStyle(
                color: Color(0xFFFFD400),
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
              ),
              strokeColor: Color(0xFF000000),
              strokeWidth: 6,
            ),
          ],
        ));

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    return InkWell(
      onTap: () async {
        soundManager.playClickSound();
        BlocProvider.of<WhoIsWhoBloc>(context).add(
          SetGameData(
            gameDuration: widget.playTime,
            selectedGameLevel: int.parse(widget.level),
          ),
        );
        BlocProvider.of<WhoIsWhoBloc>(context).add(
          SetUserCompletedLeveLState(widget.isUnLocked),
        );
        if (widget.isSpecialLevel &&
            widget.isUnLocked &&
            !widget.nextLevelIsLocked) {
          BlocProvider.of<WhoIsWhoBloc>(context)
              .add(SubmitSpecialLevelScore(widget.reward));
          showWhoIsWhoFreebiesModal(context, widget.reward);
          BlocProvider.of<WhoIsWhoBloc>(context).add(FetchGameLevels());
        } else if (widget.isSpecialLevel &&
            widget.isUnLocked &&
            widget.nextLevelIsLocked) {
          showCustomToast(context, "You've already used your freebie");
        } else if (widget.isUnLocked && !widget.isSpecialLevel) {
          Navigator.pushNamed(context, AppRoutes.questionLoadingScreen,
              arguments: {'gameType': 'wiw_game'});
        } else if (!widget.isUnLocked) {
          showCustomToast(context, 'Pass the previous level to play this!');
        }
      },
      child: Container(
        height: 180.h,
        alignment: Alignment.center,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 20.w),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 3.w),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: widget.isSpecialLevel
                            ? const Color(0xFFF7A252)
                            : widget.isUnLocked
                                ? const Color(0xFF3CE04D)
                                : const Color(0xFFD90429),
                        width: 3.w),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3.w),
                        ),
                        child: Opacity(
                          opacity: !widget.isUnLocked ? 0.4 : 1,
                          child: FadeInImage.assetNetwork(
                            placeholder: ProductImageRoutes.placeholderWIW,
                            image: widget.backgroundUrl,
                            width: 136.w,
                          ),
                        ),
                      ),
                      !widget.isUnLocked
                          ? Positioned(
                              top: 0,
                              bottom: 0,
                              left: 45.w,
                              child: Image.asset(
                                IconImageRoutes.padlock,
                                width: 48.w,
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 4.w,
              right: 4.w,
              child: Stack(
                children: [
                  widget.isSpecialLevel
                      ? Image.asset(
                          ProductImageRoutes.specialLevelTag,
                          width: 144.w,
                        )
                      : widget.isUnLocked
                          ? Image.asset(
                              ProductImageRoutes.greenLevelTag,
                              width: 144.w,
                            )
                          : Image.asset(
                              ProductImageRoutes.redLevelTag,
                              width: 144.w,
                            ),
                  Positioned(
                    top: 2.h,
                    left: 65.w,
                    bottom: 0,
                    child: Text(
                      widget.level,
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontFamily: 'Mikado',
                          color: Colors.white,
                          fontSize: 20.sp),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
