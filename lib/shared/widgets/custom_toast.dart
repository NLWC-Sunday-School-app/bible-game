import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stroke_text/stroke_text.dart';


void showCustomToast(BuildContext context, String message, {Color? color}) {
  FToast fToast = FToast();
  fToast.init(context);
  LinearGradient linearGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color.fromRGBO(34, 34, 34, 0.0),
      Color.fromRGBO(34, 34, 34, 0.2333),
      Color.fromRGBO(34, 34, 34, 0.141846),
      Color.fromRGBO(136, 136, 136, 0.0),
    ],
    stops: [
      0.0,
      0.375,
      0.62,
      1.0,
    ],
  );
  Widget toast = Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: linearGradient,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          color != null ?
       Row(
         children: [
           Container(
             height: 22.h,
             width: 22.w,
             decoration: BoxDecoration(
               shape: BoxShape.circle,
               border: Border.all(color: Colors.white),
               image: DecorationImage(
                 image: AssetImage(ProductImageRoutes.dp)
               )
             ),
           ),
           SizedBox(width: 5,),
           Text(
             message,
             style: TextStyle(
              color: Colors.black,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
                 ),
         ],
       )
              :
          StrokeText(
            text: message,
            textStyle: TextStyle(
              color: Color(0xFFFFD400),
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
            ),
            strokeColor: Color(0xFF000000),
            strokeWidth: 6,
          ),
        ],
      )
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.TOP,
    toastDuration: const Duration(seconds: 3),
  );
}


class ToastManager {
  static final FToast _fToast = FToast();

  static void init(BuildContext context) {
    _fToast.init(context);
  }

  static void showCustomToast(BuildContext context, String message) {
    LinearGradient linearGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color.fromRGBO(34, 34, 34, 0.0),
        Color.fromRGBO(34, 34, 34, 0.2333),
        Color.fromRGBO(34, 34, 34, 0.141846),
        Color.fromRGBO(136, 136, 136, 0.0),
      ],
      stops: [
        0.0,
        0.375,
        0.62,
        1.0,
      ],
    );
    Widget toast = Container(
        width: 375.w,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        decoration: BoxDecoration(
          gradient: linearGradient,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  height: 22.h,
                  width: 22.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white),
                      image: DecorationImage(
                          image: AssetImage(ProductImageRoutes.dp)
                      )
                  ),
                ),
                SizedBox(width: 5,),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          ],
        )
    );

    showToast(toast);
  }

  static void showToast(Widget child) {
    _fToast.showToast(
      child: child,
      gravity: ToastGravity.TOP,
      toastDuration: const Duration(seconds: 3),
    );
  }

  static void dismiss() {
    _fToast.removeCustomToast();
  }

  static void dismissAll() {
    _fToast.removeQueuedCustomToasts();
  }
}
