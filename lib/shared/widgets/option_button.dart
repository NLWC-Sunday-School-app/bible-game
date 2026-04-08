import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors.dart';

class OptionButton extends StatefulWidget {
  const OptionButton({
    super.key,
    required this.text,
    required this.index,
    required this.onTap,
    this.isCorrect,
    required this.isSelected,
    required this.correctAnswer,
    required this.hasAnswered,
  });

  final String text;
  final String correctAnswer;
  final int index;
  final bool? isCorrect;
  final bool isSelected;
  final VoidCallback onTap;
  final bool hasAnswered;

  @override
  State<OptionButton> createState() => _OptionButtonState();
}

class _OptionButtonState extends State<OptionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    const List<String> labels = ['A', 'B', 'C', 'D'];

    final bool isCorrectOption = widget.text == widget.correctAnswer;
    final bool isWrongSelected =
        widget.hasAnswered && widget.isCorrect == false && widget.isSelected;
    // Unselected options that are also wrong — dimmed after answer
    final bool isUnselectedAfterAnswer =
        widget.hasAnswered && !isCorrectOption && !widget.isSelected;

    Color backgroundColor = Colors.white;
    Color borderColor = AppColors.primaryColor;
    Color textColor = AppColors.darkBrownText;
    Color labelBgColor = Colors.white;
    Color labelBorderColor = Colors.black;
    Color labelTextColor = Colors.black;
    BoxShadow boxShadow = const BoxShadow(
      color: Colors.transparent,
      offset: Offset(0, 5),
      blurRadius: 0,
      spreadRadius: -2,
    );

    if (widget.hasAnswered) {
      if (isCorrectOption) {
        backgroundColor = AppColors.correctAnswer;
        borderColor = const Color(0xFFC8FF46);
        boxShadow = const BoxShadow(
          color: Color(0xFF73A206),
          offset: Offset(0, 5),
          blurRadius: 0,
          spreadRadius: -2,
        );
        labelBgColor = const Color(0xFF73A206);
        labelBorderColor = const Color(0xFF73A206);
        labelTextColor = Colors.white;
      } else if (isWrongSelected) {
        backgroundColor = AppColors.wrongAnswer;
        borderColor = const Color(0xFFFF5B5B);
        boxShadow = const BoxShadow(
          color: Color(0xFF7E0606),
          offset: Offset(0, 5),
          blurRadius: 0,
          spreadRadius: -2,
        );
        textColor = Colors.white;
        labelBgColor = const Color(0xFF7E0606);
        labelBorderColor = const Color(0xFF7E0606);
        labelTextColor = Colors.white;
      }
    }

    final bool shakeIt = isWrongSelected;
    final double scale = _isPressed && !widget.hasAnswered ? 0.96 : 1.0;

    Widget button = GestureDetector(
      onTap: widget.hasAnswered ? null : widget.onTap,
      onTapDown:
          widget.hasAnswered ? null : (_) => setState(() => _isPressed = true),
      onTapUp:
          widget.hasAnswered ? null : (_) => setState(() => _isPressed = false),
      onTapCancel:
          widget.hasAnswered ? null : () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 100),
        child: Opacity(
          opacity: isUnselectedAfterAnswer ? 0.5 : 1.0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Container(
              margin: EdgeInsets.only(bottom: 10.h),
              width: double.infinity,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [boxShadow],
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: labelBgColor,
                      border: Border.all(color: labelBorderColor),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      labels[widget.index],
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: labelTextColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      widget.text,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    if (shakeIt) {
      button = button.animate().shakeX(duration: 500.ms, hz: 4, amount: 5);
    }

    return button;
  }
}
