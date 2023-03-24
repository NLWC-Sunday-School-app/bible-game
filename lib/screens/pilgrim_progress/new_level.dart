import 'package:bible_game/controllers/user_controller.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
class NewLevelScreen extends StatefulWidget {
  final String newLevel;
  final String newLevelBadge;
  const NewLevelScreen({Key? key, required this.newLevel, required this.newLevelBadge}) : super(key: key);

  @override
  State<NewLevelScreen> createState() => _NewLevelScreenState();
}

class _NewLevelScreenState extends State<NewLevelScreen> {
  final UserController _userController = Get.put(UserController());
  final confettiController = ConfettiController();
  final _player = AudioPlayer();

  @override
  void initState() {
    confettiController.play();
    _userController.toggleGameMusic();
    _player.setAsset('assets/audios/next_level.wav');
    _player.play();

    super.initState();
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/pilgrim_levels/new_level.png'),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 100.h,
              ),
              Text(
                'NEW LEVEL ALERT!',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: 'neuland',
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    decoration: TextDecoration.none),
              ),
              SizedBox(
                height: 160.h,
              ),
              Image.asset(
                widget.newLevelBadge,
                width: 55.w,
              ),
              SizedBox(
                height: 60.h,
              ),
              Text(
                'awesome! You have \nunlocked a new level.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: 'neuland',
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    decoration: TextDecoration.none),
              ),
              SizedBox(
                height: 60.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEDD7),
                  borderRadius: BorderRadius.all(Radius.circular(40.r))
                ),
                child: Text(
                  widget.newLevel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'neuland',
                      color: const Color(0xFF214E8A),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      decoration: TextDecoration.none),
                ),
              ),
              SizedBox(
                height: 100.h,
              ),
              GestureDetector(
                onTap: () =>  {
                  _userController.toggleGameMusic(),
                  Get.back()
                },
                child: Text(
                  'Tap to continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontFamily: 'neuland',
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      decoration: TextDecoration.none),
                ),
              ),
            ],
          ),
        ),
        ConfettiWidget(
          confettiController: confettiController,
          shouldLoop: true,
          blastDirectionality: BlastDirectionality.explosive,
        ),
      ],
    );
  }
}
