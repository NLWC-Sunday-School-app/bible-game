import 'package:bible_game/features/home/widget/tablet_view_widget/play_button_tablet_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/features/home/widget/play_button.dart';

class GameCardTabletView extends StatelessWidget {
  const GameCardTabletView({super.key, required this.bgColor, required this.gameType, required this.gameText, required this.gameImage, required this.gameImageWidth, required this.onTap});
  final Color bgColor;
  final String gameType;
  final String gameText;
  final String gameImage;
  final double gameImageWidth;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 240.h,
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
                padding: EdgeInsets.only(left: 20.w),
                height: 130.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    alignment: Alignment.topRight,
                    image: AssetImage(gameImage),
                    fit: BoxFit.contain,
                  ),
                  color: bgColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    gameType,
                    style: TextStyle(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 100.h,
              padding: EdgeInsets.symmetric(
                horizontal: 30.w,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                   gameText,
                    style: TextStyle(
                      fontSize: 20.sp,
                    ),
                  ),
                  PlayButtonTabletView(
                    onTap: onTap,
                  )
                ],
              ),
            ),
            SizedBox(height: 5.h,)
          ],
        ),
      ),
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
