import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';

class RecapFourScreen extends StatelessWidget {
  const RecapFourScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/aesthetics/recap_four_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),

        Positioned(
          top: 400.h,
          left: 30.w,
          child: Countup(
            begin: 0,
            end: (GetStorage().read('game_recap')['total_number_of_games_played']).toDouble(),
            duration: const Duration(seconds: 2),
            separator: '',
            style: TextStyle(
              fontSize: 88.sp,
              fontFamily: 'Mikado',
              color: Colors.white,
              fontWeight: FontWeight.w900
            ),
          ),
        )
      ],
    );
  }
}
