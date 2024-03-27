import 'package:bible_game/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stroke_text/stroke_text.dart';
import '../../screens/who_is_who/home.dart';

class FourScripturesGuide extends StatelessWidget {
  const FourScripturesGuide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.put(UserController());
    return Dialog(
      insetPadding: EdgeInsets.all(2.w),
      backgroundColor: Colors.black.withOpacity(0.86),
      child: SingleChildScrollView(
        child: SizedBox(
          height: Get.height,
          width: Get.width,
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
                    fontFamily: 'Mikado',
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w900,
                    shadows: const [
                      Shadow(
                        color: Color(0xFF673125),
                        // Choose the color of the shadow
                        blurRadius: 5.0,
                        // Adjust the blur radius for the shadow effect
                        offset: Offset(0,
                            3), // Set the horizontal and vertical offset for the shadow
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
                        'assets/images/scroll.png',
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
                    'assets/images/icons/turn_left.png',
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
                      'assets/images/aesthetics/treasure_box.png',
                      width: 70.w,
                    ),
                  ],
                ),
                SizedBox(
                  height: 50.h,
                ),
                InkWell(
                  onTap: () {
                    userController.soundIsOff.isFalse
                        ? userController.playGameSound()
                        : null;
                    var firstTime =
                        GetStorage().read('wiw_info_first_time') ?? true;
                    if (firstTime) {
                      Get.back();
                      Get.to(() => const WhoIsWhoHomeScreen());
                      GetStorage().write('wiw_info_first_time', false);
                    } else {
                      Get.back();
                    }
                  },
                  child: StrokeText(
                    text: 'Tap to continue',
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
      ),
    );
  }
}
