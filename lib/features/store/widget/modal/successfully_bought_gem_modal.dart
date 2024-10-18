import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/constants/image_routes.dart';

import '../../../../shared/features/settings/bloc/settings_bloc.dart';

void showSuccessfullyBoughtGemModal(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: const Color.fromRGBO(40, 40, 40, 0.86),
      builder: (BuildContext context) {
        return SuccessfullyBoughtGemModal();
      });
}

class SuccessfullyBoughtGemModal extends StatefulWidget {
  const SuccessfullyBoughtGemModal({super.key});

  @override
  State<SuccessfullyBoughtGemModal> createState() => _SuccessfullyBoughtGemModalState();
}

class _SuccessfullyBoughtGemModalState extends State<SuccessfullyBoughtGemModal> {
  final confettiController = ConfettiController();
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;


    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),
                    Image.asset(IconImageRoutes.bigGemIcon, width: 111.w,),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      'You bought a gem! \nYou can use it anytime',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900),
                    )
                  ],
                ),
              ),
            ),
            ConfettiWidget(
              confettiController: confettiController,
              shouldLoop: false,
              blastDirectionality: BlastDirectionality.explosive,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final soundManager =  BlocProvider.of<SettingsBloc>(context).soundManager;
    soundManager.playAchievementSound();
    confettiController.play();
  }
}
