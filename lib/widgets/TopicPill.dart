import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopicPill extends StatefulWidget {
  const TopicPill({
    Key? key,
    required this.topic,
  }) : super(key: key);

  final String topic;

  @override
  State<TopicPill> createState() => _TopicPillState();
}

class _TopicPillState extends State<TopicPill> {
  bool isSelected = false;

  togglePillColor() {
    setState(() {
      isSelected = !isSelected;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => togglePillColor(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        height: 45.h,
        decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromRGBO(118, 99, 229, 1)
                : const Color.fromRGBO(226, 221, 254, 1),
            borderRadius: BorderRadius.all(Radius.circular(20.r))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
           isSelected ? const Icon(
              Icons.check_circle,
              color: Color.fromRGBO(248, 229, 255, 1),
            ) : const SizedBox(),
            Padding(
              padding: EdgeInsets.only(left: 5.w),
              child: Text(
                widget.topic,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: isSelected
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
