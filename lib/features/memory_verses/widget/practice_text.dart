import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum PracticeLevel { read, fillBlanks, firstLetters }

/// Renders a verse with progressively hidden words for memorization
/// practice. Hidden words can be tapped to reveal them.
class PracticeText extends StatefulWidget {
  final String text;
  final PracticeLevel level;

  const PracticeText({super.key, required this.text, required this.level});

  @override
  State<PracticeText> createState() => _PracticeTextState();
}

class _PracticeTextState extends State<PracticeText> {
  final Set<int> _revealed = {};

  @override
  void didUpdateWidget(covariant PracticeText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.level != widget.level || oldWidget.text != widget.text) {
      _revealed.clear();
    }
  }

  bool _isHidden(int index) {
    switch (widget.level) {
      case PracticeLevel.read:
        return false;
      case PracticeLevel.fillBlanks:
        return index.isOdd;
      case PracticeLevel.firstLetters:
        return true;
    }
  }

  String _masked(String word) {
    // Keep leading/trailing punctuation visible so the verse keeps its shape.
    final match = RegExp(r"^([^\w]*)([\w'’-]+)([^\w]*)$", unicode: true)
        .firstMatch(word);
    if (match == null) return word;
    final core = match.group(2)!;
    final hidden = widget.level == PracticeLevel.firstLetters
        ? core[0] + '_' * (core.length - 1).clamp(1, 8).toInt()
        : '_' * core.length.clamp(2, 10).toInt();
    return '${match.group(1)}$hidden${match.group(3)}';
  }

  @override
  Widget build(BuildContext context) {
    final words = widget.text.split(RegExp(r'\s+'));
    return Wrap(
      spacing: 5.w,
      runSpacing: 7.h,
      children: [
        for (var i = 0; i < words.length; i++)
          _isHidden(i) && !_revealed.contains(i)
              ? GestureDetector(
                  onTap: () => setState(() => _revealed.add(i)),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Text(
                      _masked(words[i]),
                      style: TextStyle(
                        color: const Color(0xFFFFD97B),
                        fontSize: 16.sp,
                        height: 1.5,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                )
              : Text(
                  words[i],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    height: 1.5,
                  ),
                ),
      ],
    );
  }
}
