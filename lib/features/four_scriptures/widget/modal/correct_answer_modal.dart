import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/constants/image_routes.dart';

import '../../../../shared/features/settings/bloc/settings_bloc.dart';

void showCorrectAnswerBottomSheetModal(
    BuildContext context, String answer, VoidCallback onTap) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    isDismissible: false,
    builder: (BuildContext context) {
      return CorrectAnswerModal(
        answer: answer,
        onTap: onTap,
      );
    },
  );
}

class CorrectAnswerModal extends StatefulWidget {
  const CorrectAnswerModal({
    Key? key,
    required this.answer,
    required this.onTap,
  }) : super(key: key);

  final String answer;
  final VoidCallback onTap;

  @override
  State<CorrectAnswerModal> createState() => _CorrectAnswerModalState();
}

class _CorrectAnswerModalState extends State<CorrectAnswerModal> {
  final confettiController = ConfettiController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromRGBO(39, 97, 164, 1).withOpacity(0.8),
              const Color.fromRGBO(39, 97, 164, 0).withOpacity(0.8),
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              children: [
                SizedBox(height: 100.h),
                Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Image.asset(
                      ProductImageRoutes.thumbsUp,
                      width: 80.w,
                    )),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  '${widget.answer.toUpperCase()}!',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Awesome! You got the answer correctly.',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18.sp,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32.r)),
                    child: Text(
                      'Tap to continue',
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF2761A4),
                          fontSize: 16.sp),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100.h,
                ),
              ],
            ),
            ConfettiWidget(
              confettiController: confettiController,
              shouldLoop: true,
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
