import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/constants/image_routes.dart';

class ToggleCard extends StatefulWidget {
  const ToggleCard({super.key, required this.onTap, required this.selectedOption, required this.hasTwoOptions, required this.options});
  final VoidCallback? onTap;
  final bool? selectedOption;
  final bool hasTwoOptions;
  final List<String> options;

  @override
  State<ToggleCard> createState() => _ToggleCardState();
}

class _ToggleCardState extends State<ToggleCard> {
  int currentIndex = 0;

  void toggleListForward() {
    setState(() {
      currentIndex = (currentIndex + 1) % widget.options.length;
    });
  }
 void toggleListBackward() {
    setState(() {
      currentIndex = (currentIndex - 1) % widget.options.length;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap:  widget.hasTwoOptions ? widget.onTap : () => toggleListBackward(),
            child: Image.asset(
              IconImageRoutes.greenLeftCircleArrow,
              width: 29.w,
            ),
          ),

         widget.hasTwoOptions ? Text(
            widget.selectedOption! ? 'against a bible gamer' : 'more than 2+ players',
            style: TextStyle(
                fontSize: 14.sp,
                color: Color(0xFF014CA3),
                fontWeight: FontWeight.w500),
          ) : Text(
             widget.options[currentIndex],
           style: TextStyle(
               fontSize: 14.sp,
               color: Color(0xFF014CA3),
               fontWeight: FontWeight.w500),
         ),
          InkWell(
            onTap:widget.hasTwoOptions ? widget.onTap : () => toggleListForward(),
            child: Image.asset(
              IconImageRoutes.greenRightCircleArrow,
              width: 29.w,
            ),
          ),
        ],
      ),
      height: 50.h,
      width: 255.w,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFF8E7DE)),
        borderRadius: BorderRadius.circular(4.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
          ),
          BoxShadow(
            color: Color(0xFFFEEDE4),
            offset: Offset(0, 1),
            spreadRadius: 1.0,
            blurRadius: 5.0,
          ),
        ],
      ),
    );
  }
}
