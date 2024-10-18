import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScoreBox extends StatelessWidget {
  const ScoreBox({
    Key? key, required this.coinsAvailable,
  }) : super(key: key);

  final int coinsAvailable;

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('#,###,###');
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(8.w),
          child: Container(
              width: 110.w,
              padding: EdgeInsets.only(left: 15.w, top: 5.h, bottom: 5.h),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.fromRGBO(89, 141, 231, 1),
                      Color.fromRGBO(239, 121, 138, 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(36.r)),
                  border: Border.all(color: Colors.white, width: 1.5)),
              child: Text(
                  formatter.format(coinsAvailable),
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16.sp,
                      color: Colors.white),
                ),
              ),
        ),
        Positioned(
          top: 5,
          right: 0,
          child: Image.asset(
            IconImageRoutes.coinIcon,
            width: 40.w,
          ),
        )
      ],
    );
  }
}