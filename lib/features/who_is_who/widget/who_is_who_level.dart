import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_bible_game/features/who_is_who/bloc/who_is_who_bloc.dart';
import 'package:the_bible_game/features/who_is_who/widget/modal/freebies_modal.dart';
import 'package:the_bible_game/features/who_is_who/widget/modal/wiw_time_up_modal.dart';
import 'package:the_bible_game/shared/constants/app_routes.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';

class WhoIsWhoLevel extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        BlocProvider.of<WhoIsWhoBloc>(context).add(
          SetGameData(
            gameDuration: playTime,
            selectedGameLevel: int.parse(level),
          ),
        );
        BlocProvider.of<WhoIsWhoBloc>(context).add(
          SetUserCompletedLeveLState(isUnLocked),
        );
        if (isSpecialLevel && isUnLocked && !nextLevelIsLocked) {
          BlocProvider.of<WhoIsWhoBloc>(context)
              .add(SubmitSpecialLevelScore(reward));
          showWhoIsWhoFreebiesModal(context, reward);
          BlocProvider.of<WhoIsWhoBloc>(context)
              .add(FetchGameLevels());
        } else if (isUnLocked && !isSpecialLevel) {
          Navigator.pushNamed(context, AppRoutes.questionLoadingScreen,
              arguments: {'gameType': 'wiw_game'});
        }
      },
      child: Container(
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
                        color: isSpecialLevel
                            ? const Color(0xFFF7A252)
                            : isUnLocked
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
                          opacity: !isUnLocked ? 0.4 : 1,
                          child: FadeInImage.assetNetwork(
                            placeholder: ProductImageRoutes.placeholderWIW,
                            image: backgroundUrl,
                            width: 136.w,
                          ),
                        ),
                      ),
                      !isUnLocked
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
                  isSpecialLevel
                      ? Image.asset(
                          ProductImageRoutes.specialLevelTag,
                          width: 144.w,
                        )
                      : isUnLocked
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
                      level,
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
