import 'package:bible_game/features/home/widget/tablet_view_widget/play_button_tablet_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/features/home/widget/play_button.dart';

class MultiplayerCard extends StatelessWidget {
  const MultiplayerCard({super.key, required this.bgColor, required this.gameType, required this.gameText, required this.gameImage, required this.gameImageWidth, required this.onTap});
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
        height: 164.h,
        margin: const EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border(
            bottom: BorderSide(color: Color(0xFFFFE9C7), width: 5.w),
      )
        //     border: Border.all(width: 1.w, color: Colors.white),
        // boxShadow: [
        //   BoxShadow(
        //     color: Color(0xFFFFE9C7),
        //     offset: Offset(0, 6),
        //     blurRadius: 0,
        //     spreadRadius: -1,
        //   ),
        // ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Curved White Shape at bottom
              Align(
                alignment: Alignment.topCenter,
                child: ClipPath(
                  clipper: DiagonalCurveClipper(),
                  child: Container(
                    height: 154.h,
                    color: bgColor,
                  ),
                ),
              ),

              // Content
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// Left Side: Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Text(
                              gameType,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF014CA3),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              gameText,
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xFF081625),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Right Side: Image
                      Image.asset(
                        gameImage,
                        height: 110.h,
                        width: 110.w,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom Clipper for Diagonal Curve
class DiagonalCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    // Start bottom-left
    path.moveTo(0, size.height * 0.9);

    // Curve downward toward middle
    path.quadraticBezierTo(
      size.width * 0.5, size.height*0.6, // control point (middle lower)
      size.width, size.height * 0.6, // end at right higher
    );

    // Close shape
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
