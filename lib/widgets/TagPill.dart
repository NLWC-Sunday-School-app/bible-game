import 'package:assets_audio_player/assets_audio_player.dart';
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

  togglePillColor(id) {
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
    return GestureDetector(
      onTap: () => {
        player.setAsset('assets/audios/select_tag.mp3'),
        player.play(),
        togglePillColor(widget.tag)
      },
      child: ShowUpAnimation(
        delayStart: const Duration(milliseconds: 100),
        animationDuration: const Duration(milliseconds: 1000),
        curve: Curves.easeOutSine,
        direction: Direction.horizontal,
        offset: 0.5,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          height: 45.h,
          decoration: BoxDecoration(
            color: pillIsSelected
                ? const Color(0xFF4075BB)
                : const Color(0xFFCFEDFD),
            borderRadius: BorderRadius.all(Radius.circular(20.r)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // pillIsSelected
              //     ? const Icon(
              //         Icons.check_circle,
              //         color: Color.fromRGBO(248, 229, 255, 1),
              //       )
              //     : const SizedBox(),
              Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: Text(
                  widget.tag,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: pillIsSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
