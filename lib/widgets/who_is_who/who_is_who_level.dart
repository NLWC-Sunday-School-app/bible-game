import 'package:bible_game/controllers/wiw_game_controller.dart';
import 'package:bible_game/screens/who_is_who/home.dart';
import 'package:bible_game/screens/who_is_who/question_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
class WhoIsWhoLevel extends StatelessWidget {
  const WhoIsWhoLevel({Key? key, required this.isUnLocked, required this.level, required this.backgroundUrl, required this.isSpecialLevel, required this.playTime}) : super(key: key);
  final bool isUnLocked;
  final String level;
  final String backgroundUrl;
  final bool isSpecialLevel;
  final int playTime;


  @override
  Widget build(BuildContext context) {
    WiwGameController wiwGameController = Get.put(WiwGameController());
    return GestureDetector(
      onTap: (){
        if(isUnLocked){
          wiwGameController.gameDuration.value = playTime;
          wiwGameController.getQuestions();
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
                        color: isUnLocked
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
                            placeholder: 'assets/images/aesthetics/haven.png',
                            image: backgroundUrl,
                            width: 136.w,
                          ),
                        ),
                      ),
                      !isUnLocked ? Positioned(
                        top: 0,
                        bottom: 0,
                        left: 45.w,
                        child: Image.asset(
                          'assets/images/icons/padlock.png',
                          width: 48.w,
                        ),
                      ): const SizedBox()
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
                  isUnLocked
                      ? Image.asset(
                          'assets/images/aesthetics/level_tag.png',
                          width: 144.w,
                        )
                      : Image.asset(
                          'assets/images/aesthetics/red_level_tag.png',
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
