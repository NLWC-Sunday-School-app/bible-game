import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CountdownTimerWidget extends StatefulWidget {
  final DateTime targetDate;

  const CountdownTimerWidget({Key? key, required this.targetDate})
      : super(key: key);

  @override
  _CountdownTimerWidgetState createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late Timer _timer;
  Duration _remainingTime = const Duration();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime = widget.targetDate.difference(DateTime.now());
        if (_remainingTime <= Duration.zero) {
          _timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String days = (_remainingTime.inDays).toString().padLeft(2, '0');
    String hours = (_remainingTime.inHours % 24).toString().padLeft(2, '0');
    String minutes = (_remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (_remainingTime.inSeconds % 60).toString().padLeft(2, '0');

    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 30.w),
      decoration: BoxDecoration(
          borderRadius:
          BorderRadius.circular(24.r),
          color:  const Color(0xFFBCD8FF)),
      child: Text(
        'Join Challenge',
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12.sp),
      ),
    );
  }
}
