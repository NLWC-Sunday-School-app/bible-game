import 'package:bible_game/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../services/base_url_service.dart';

class RecapFiveScreen extends StatelessWidget {
  const RecapFiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.put(UserController());
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/aesthetics/recap_five_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 110.h,
          right: 0.w,
          left: 0.w,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border:
                      Border.all(width: 3.w, color: const Color(0xFF366ABC)),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border:
                        Border.all(width: 2.w, color: const Color(0xFF4A91FF)),
                  ),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/images/aesthetics/default_avatar.png',
                    image:
                        '${BaseUrlService.avatarBaseUrl}/${userController.myUser['id']}.png?apikey=${BaseUrlService.avatarApiKey}',
                    width: 70.w,
                  ),
                  padding: EdgeInsets.all(5.w),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                userController.myUser['name'],
                style: TextStyle(
                    fontFamily: 'Mikado',
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp),
              ).animate()
                  .fadeIn(duration: 500.ms)
                  .scale(delay: 300.ms),
            ],
          ),
        ),
        Positioned(
          top: 420.h,
          right: 0.w,
          left: 0.w,
          child: Column(
            children: [
              Text(
                '${GetStorage().read('game_recap')['total_number_of_user_game_plays']} Games',
                style: TextStyle(
                  fontSize: 48.sp,
                  fontFamily: 'Mikado',
                  fontWeight: FontWeight.w700,
                ),
              ).animate()
                  .fadeIn(delay: 600.ms, duration: 900.ms),
                  // .scale(delay: 500.ms),
              Text(
                'this year',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18.sp,
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: 620.h,
          left: 0.w,
          right: 0.w,
          child: Column(
            children: [
              Text.rich(
                TextSpan(
                  text: 'makes you',
                  style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Gochi Hand'
                  ),
                  children: [
                    TextSpan(
                      text: ' top ${GetStorage().read('game_recap')['user_percentile']}%',
                      style: const TextStyle(
                        color: Color(0xFFFFF500)
                      )
                    ),
                    const TextSpan(
                      text: ' of all \nBible Gamers round the world'
                    )
                  ]
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        )
      ],
    );
  }
}
