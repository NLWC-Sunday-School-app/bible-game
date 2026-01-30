import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecapSevenScreen extends StatelessWidget {
  const RecapSevenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ProductImageRoutes.recapSevenBck),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(top: 120.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Accuracy Rate',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontFamily: 'Mikado',
                    color: Color(0xFF6B6B6B),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 74.h,),
                Text(
                  'You got',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontFamily: 'Mikado',
                    color: Color(0xFF636363),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  '78%',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 88.sp,
                    fontFamily: 'Mikado',
                    color: Color(0xff6F2DCB),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'of Questions right!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36.sp,
                    fontFamily: 'Mikado',
                    color: Color(0xFF636363),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),

        Align(
          alignment: Alignment.bottomCenter,
            child:Padding(
              padding: EdgeInsets.only(bottom: 120.h),
              child: Column(
                children: [
                  Spacer(),
                  Image.asset(
                      ProductImageRoutes.recapSevenGif,
                    scale: 0.8,
                  ),
                ],
              ),
            ),
        ),
      ],
    );
  }
}
