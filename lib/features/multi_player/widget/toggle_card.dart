import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/constants/image_routes.dart';

class ToggleCard extends StatefulWidget {
  const ToggleCard({super.key, required this.onTap, required this.selectedOption, required this.hasTwoOptions, required this.options,this.onValueSelected, this.width, this.height});
  final VoidCallback? onTap;
  final ValueChanged<String>? onValueSelected;
  final bool? selectedOption;
  final bool hasTwoOptions;
  final List<String> options;

  /// Defaults keep every existing caller as it was; the compact rows in the
  /// create-gameplay modal pass a narrower size.
  final double? width;
  final double? height;

  @override
  State<ToggleCard> createState() => _ToggleCardState();
}

class _ToggleCardState extends State<ToggleCard> {
  int currentIndex = 0;

  void toggleListForward() {
    setState(() {
      currentIndex = (currentIndex + 1) % widget.options.length;
      widget.onValueSelected!(widget.options[currentIndex]);
    });
  }
 void toggleListBackward() {
    setState(() {
      currentIndex = (currentIndex - 1) % widget.options.length;
      widget.onValueSelected!(widget.options[currentIndex]);
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
              width: 26.w,
            ),
          ),

         Expanded(
           child: Text(
             widget.hasTwoOptions
                 ? (widget.selectedOption!
                     ? 'against a bible gamer'
                     : 'more than 2+ players')
                 : widget.options[currentIndex],
             textAlign: TextAlign.center,
             maxLines: 1,
             overflow: TextOverflow.ellipsis,
             style: TextStyle(
                 fontSize: 14.sp,
                 color: const Color(0xFF014CA3),
                 fontWeight: FontWeight.w600),
           ),
         ),
          InkWell(
            onTap:widget.hasTwoOptions ? widget.onTap : () => toggleListForward(),
            child: Image.asset(
              IconImageRoutes.greenRightCircleArrow,
              width: 26.w,
            ),
          ),
        ],
      ),
      height: widget.height ?? 50.h,
      width: widget.width ?? 255.w,
      // Matches the text fields: a real border on white, rather than a
      // borderless box outlined by a blurred black26 shadow.
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE7CDBF), width: 1.5),
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }
}
