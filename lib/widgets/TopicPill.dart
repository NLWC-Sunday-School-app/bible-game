import 'package:bible_game/controllers/topic_pill_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class TopicPill extends StatefulWidget {
  const TopicPill({
    Key? key,
    required this.topic,
    required this.id,
  }) : super(key: key);

  final String topic;
  final int id;

  @override
  State<TopicPill> createState() => _TopicPillState();
}

class _TopicPillState extends State<TopicPill> {
  bool pillIsSelected = false;
  final TopicPillController _topicPillController =
      Get.put(TopicPillController());

  togglePillColor(id) {
    if (_topicPillController.selectedPill.isEmpty ||
        _topicPillController.selectedPill.length < 4 ||
        _topicPillController.selectedPill.contains(id)) {
      if (pillIsSelected) {
        setState(() => pillIsSelected = false);
        _topicPillController.selectedPill.remove(id);
      } else {
        setState(() => pillIsSelected = true);
        _topicPillController.selectedPill.add(id);
      }
    } else {
      Get.snackbar('Oops', 'You cannot select more than 4 topics',
          messageText: const Text(
            'You cannot select more than 4 topics',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          colorText: const Color(0xffFFFFFF),
          backgroundColor: const Color(0XFFE90404));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => togglePillColor(widget.id),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        height: 45.h,
        decoration: BoxDecoration(
          color: pillIsSelected
              ? const Color.fromRGBO(118, 99, 229, 1)
              : const Color.fromRGBO(226, 221, 254, 1),
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            pillIsSelected
                ? const Icon(
                    Icons.check_circle,
                    color: Color.fromRGBO(248, 229, 255, 1),
                  )
                : const SizedBox(),
            Padding(
              padding: EdgeInsets.only(left: 5.w),
              child: Text(
                widget.topic,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: pillIsSelected
                        ? const Color.fromRGBO(255, 255, 255, 1)
                        : const Color.fromRGBO(48, 35, 124, 1)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
