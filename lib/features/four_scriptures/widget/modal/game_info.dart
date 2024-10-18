import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/shared/constants/image_routes.dart';

void showFourScripturesOneWordInfo(BuildContext context){
   showModalBottomSheet(
     context: context,
     isScrollControlled: true,
     backgroundColor: Colors.transparent,
     isDismissible: false,
     builder: (BuildContext context) {
       return FourScripturesGuide();
     },

   );
}

class FourScripturesGuide extends StatelessWidget {
  const FourScripturesGuide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.black.withOpacity(0.86),
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
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
                  text: 'How to play',
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w900,
                    shadows: const [
                      Shadow(
                        color: Color(0xFF673125),
                        blurRadius: 5.0,
                        offset: Offset(0, 3),
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
                        ProductImageRoutes.scroll,
                        width: 80.w,
                      ),
                      SizedBox(
                        width: 30.w,
                      ),
                      Text(
                        'Find the central\n truth the passage\n have in common!',
                        style: TextStyle(
                          color: Colors.white,
                          height: 1.2,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                        ),
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
                    width: 70.w,
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
                      'Win coins as you play\neach level, it will\ncome in handy!',
                      style: TextStyle(
                        color: Colors.white,
                        height: 1.2,
                        fontFamily: 'Mikado',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(
                      width: 30.w,
                    ),
                    Image.asset(
                      ProductImageRoutes.treasureBox,
                      width: 70.w,
                    ),
                  ],
                ),
                SizedBox(
                  height: 50.h,
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: StrokeText(
                    text: 'Tap to continue',
                    textStyle: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.5,
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
      ),
    );
  }
}
