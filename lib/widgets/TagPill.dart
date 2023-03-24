import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:show_up_animation/show_up_animation.dart';

import '../controllers/tags_pill_controller.dart';

class TagPill extends StatefulWidget {
  const TagPill({
    Key? key,
    required this.tag,
    required this.id,
  }) : super(key: key);

  final String tag;
  final int id;

  @override
  State<TagPill> createState() => _TagPillState();
}

class _TagPillState extends State<TagPill> {
  bool pillIsSelected = false;
  final TagsPillController _tagsPillController = Get.put(TagsPillController());
  final player = AudioPlayer();

  togglePillColor(id){
    if (_tagsPillController.selectedPill.isEmpty ||
        _tagsPillController.selectedPill.length < 4 ||
        _tagsPillController.selectedPill.contains(id)) {
      if (pillIsSelected) {
        setState(() => pillIsSelected = false);
        _tagsPillController.selectedPill.remove(id);
      } else {
        setState(() => pillIsSelected = true);
        _tagsPillController.selectedPill.add(id);
      }
    } else {
      Get.snackbar('Oops', 'You cannot select more than 4 topics',
          messageText: Text(
            'You cannot select more than 4 topics',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          colorText: const Color(0xffFFFFFF),
          backgroundColor: const Color(0XFFE90404));
    }
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final assetsAudioPlayer = AssetsAudioPlayer();
    UserController userController = Get.put(UserController());
    return GestureDetector(
      onTap: () => {
      if(userController.soundIsOff.isFalse){
        player.setAsset('assets/audios/select_tag.mp3'),
        player.play(),
        player.setVolume(0.5)
      },
        togglePillColor(widget.tag)
      },
      child: ShowUpAnimation(
        delayStart: const Duration(milliseconds: 100),
        animationDuration: const Duration(milliseconds: 500),
        curve: Curves.easeOutSine,
        direction: Direction.horizontal,
        offset: 0.5,
        child: Container(
          height: 90.w,
          width: 90.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2, color: const Color(0xFF548BD5).withOpacity(0.3)),
            color: pillIsSelected
                ? const Color(0xFF558CD7)
                : const Color(0xFFE0EDFF),
          ),
          child: Center(
            child: Text(
                widget.tag,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: pillIsSelected ? Colors.white : Colors.black,
                ),
              ),
          ),

        ),
      ),
    );
  }
}
