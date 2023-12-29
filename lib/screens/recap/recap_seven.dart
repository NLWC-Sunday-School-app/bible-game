import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';

import '../../utilities/string_converter.dart';

class RecapSevenScreen extends StatelessWidget {
  const RecapSevenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/aesthetics/recap_seven_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 270.h,
          left: 0.w,
          right: 0.w,
          child: Column(
            children: [
              Image.asset( formatUserTopGameModeImage(GetStorage().read('game_recap')['user_top_game_mode']), width: 150.w,).animate().slide(duration: 900.ms),
              SizedBox(height: 20.h,),
              Text(
                formatUserTopGameMode(GetStorage().read('game_recap')['user_top_game_mode']),
               style: TextStyle(
                 fontSize: 36.sp,
                 fontFamily: 'Mikado',
                 color: const Color(0xFFDC2A41),
                 fontWeight: FontWeight.w900
               ),
              ).animate().slide(delay: 1000.ms, duration: 900.ms)
            ],
          ),
        )
      ],
    );
  }
}
