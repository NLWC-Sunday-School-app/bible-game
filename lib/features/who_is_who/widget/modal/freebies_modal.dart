import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';

import '../../../../shared/features/settings/bloc/settings_bloc.dart';

void showWhoIsWhoFreebiesModal(BuildContext context, int pointsRewarded) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (BuildContext context) {
        return WiwFreebiesModal(
          pointsRewarded: pointsRewarded,
        );
      });
}

class WiwFreebiesModal extends StatelessWidget {
  const WiwFreebiesModal({Key? key, required this.pointsRewarded})
      : super(key: key);

  final int pointsRewarded;

  @override
  Widget build(BuildContext context) {
    final soundManager =  BlocProvider.of<SettingsBloc>(context).soundManager;
    if(soundManager.isSoundOn || soundManager.isMusicOn){
       soundManager.playAchievementSound();
    }
    return Stack(
      children: [
        SizedBox(
          height: Get.height,
          width: Get.width,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.freebiesModalBg),
                  fit: BoxFit.fill),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 80.h,
                ),
                Image.asset(
                  ProductImageRoutes.freebieBanner,
                  width: 200.w,
                ),
                SizedBox(
                  height: 150.h,
                ),
                Image.asset(
                  ProductImageRoutes.walletPurse,
                  width: 160.w,
                ),
                Text(
                  '$pointsRewarded coins won!',
                  style: TextStyle(
                      fontFamily: 'Mikado',
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w900),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: StrokeText(
                    text: 'Tap to continue',
                    textStyle: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontFamily: 'Mikado',
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w900,
                    ),
                    strokeColor: const Color(0xFFF1B30C),
                    strokeWidth: 5,
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
              ],
            ),
          ),
        ),
        // ConfettiWidget(
        //   confettiController: wiwGameController.confettiController,
        //   shouldLoop: true,
        //   blastDirectionality: BlastDirectionality.explosive,
        // ),
      ],
    );
  }
}
