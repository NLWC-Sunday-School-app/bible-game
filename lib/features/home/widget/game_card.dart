import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_bible_game/features/home/widget/play_button.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';
import '../../../shared/constants/colors.dart';

class GameCard extends StatelessWidget {
  const GameCard({super.key, required this.bgColor, required this.gameType, required this.gameText, required this.gameImage, required this.gameImageWidth, required this.onTap});
  final Color bgColor;
  final String gameType;
  final String gameText;
  final String gameImage;
  final double gameImageWidth;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 120.h,
          margin: EdgeInsets.only(bottom: 20.h),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFBFBDC3),
                  offset: Offset(0, 8),
                  blurRadius: 0,
                  spreadRadius: -2,
                ),
              ]),
          child: Column(
            children: [
              ClipPath(
                clipper: InnerCurveClipper(),
                child: Container(
                  height: 85.h,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),
              ),
              Container(
                height: 35.h,
                padding: EdgeInsets.symmetric(
                  horizontal: 15.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                     gameText,
                      style: TextStyle(
                        fontSize: 13.sp,
                      ),
                    ),
                    PlayButton(
                      onTap: onTap,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Text(
                gameType,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
            Image.asset(
              gameImage,
              width: gameImageWidth,
            )
          ],
        )
      ],
    );
  }
}

class InnerCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 15); // Start point
    path.quadraticBezierTo(size.width / 2, size.height - 30, size.width,
        size.height - 10); // Control point and end point
    path.lineTo(size.width, 0); // End point
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
