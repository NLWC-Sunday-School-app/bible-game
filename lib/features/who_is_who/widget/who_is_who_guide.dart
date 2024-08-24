import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';

 void showWhoIsWhoGuidModal(BuildContext context){
   showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (BuildContext context){
        return WhoIsWhoGuide();
      }
    );
 }

class WhoIsWhoGuide extends StatelessWidget {
  const WhoIsWhoGuide({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return

      Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.black.withOpacity(0.96),
      child:  SizedBox(
          height: screenHeight,
          width: screenWidth,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 50.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                StrokeText(
                  text:'How to play',
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Mikado',
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w900,
                    shadows: const [
                      Shadow(
                        color: Color(0xFF673125),      // Choose the color of the shadow
                        blurRadius: 5.0,          // Adjust the blur radius for the shadow effect
                        offset: Offset(0, 3), // Set the horizontal and vertical offset for the shadow
                      ),
                    ],
                  ),
                  strokeColor: const Color(0xFFF1B30C),
                  strokeWidth: 5,
                ),

                SizedBox(
                  height: 40.h,
                ),
                AnimatedContainer(
                  duration: const Duration(seconds: 2),
                  curve: Curves.bounceIn,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        ProductImageRoutes.hourGlass,
                        width: 48.w,
                      ),
                      SizedBox(
                        width: 30.w,
                      ),
                      Text(
                        'Answer more than 20 \nquestions correctly \nto move to next level.',
                        style: TextStyle(
                            color: Colors.white,
                            height: 1.2,
                            fontFamily: 'Mikado',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Image.asset(
                   ProductImageRoutes.guideLeft,
                    width: 26.w,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      ProductImageRoutes.treasureBox,
                      width: 79.w,
                    ),
                    SizedBox(
                      width: 30.w,
                    ),
                    Text(
                      'Win gems as you\n play, it will come in\n handy!',
                      style: TextStyle(
                          color: Colors.white,
                          height: 1.2,
                          fontFamily: 'Mikado',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900),
                    )
                  ],
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Image.asset(
                    ProductImageRoutes.guideRight,
                    width: 30.w,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      'Retry as many times\n to progress to next \nlevel',
                      style: TextStyle(
                          color: Colors.white,
                          height: 1.2,
                          fontFamily: 'Mikado',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      width: 30.w,
                    ),
                    Image.asset(
                      ProductImageRoutes.guideFlag,
                      width: 48.w,
                    ),
                  ],
                ),
                SizedBox(height: 50.h,),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: StrokeText(
                    text:'Tap to continue',
                    textStyle: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontFamily: 'Mikado',
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w900,
                    ),
                    strokeColor: const Color(0xFFF1B30C),
                    strokeWidth: 5,
                  ),
                ),
                // const Spacer(),
              ],
            ),
          ),
        ),

    );
  }
}
