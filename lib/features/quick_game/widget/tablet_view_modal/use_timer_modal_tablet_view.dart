import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/shared/widgets/green_button.dart';

import '../../../../shared/constants/app_routes.dart';
import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/features/settings/bloc/settings_bloc.dart';

void showUseTimerModalTabletView(BuildContext context) {
  showDialog(
      context: context,
      barrierColor: const Color.fromRGBO(40, 40, 40, 0.95),
      builder: (BuildContext context) {
        return UserTimerModalTabletView();
      });
}

class UserTimerModalTabletView extends StatelessWidget {
  const UserTimerModalTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    final soundManager = context
        .read<SettingsBloc>()
        .soundManager;
    return Dialog(
      // insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: 467.h,
        width: 638.h,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ProductImageRoutes.streakModalBg),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
            SizedBox(
            height: 20.h,
          ),
          Row(
            children: [
            SizedBox(
            width: 40.w,
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              soundManager.playClickSound();
              Navigator.pop(context);
            },
            child: Image.asset(
            IconImageRoutes.blueCircleCancel,
            width: 35.w,
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        ],
      ),
      SizedBox(
        height: 20.h,
      ),
      SizedBox(
        height: 20.h,
      ),
      Text(
        'How do you want to play \nyour quick game?',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 20.sp,
          color: Colors.white,
        ),
      ),
      SizedBox(
        height: 30.h,
      ),
      GreenButton(
        onTap: (){
          soundManager.playClickSound();
          Navigator.pushNamed(context, AppRoutes.questionLoadingScreen, arguments:{ 'gameType': 'quick_game', 'hasTimer': true});
        },
        buttonIsLoading: false,
        width: 310.w,
        customWidget: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(IconImageRoutes.greenTimer, width: 20.w,),
            SizedBox(width: 10.w,),
            StrokeText(
              text: 'Play with a timer',
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
              strokeColor: const Color(0xFF272D39),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
      SizedBox(height: 20.h,),
      GestureDetector(
        onTap: () {
          soundManager.playClickSound();
          Navigator.pushNamed(context, AppRoutes.questionLoadingScreen, arguments:{ 'gameType': 'quick_game', 'hasTimer': false});
        },
        child: Container(
          width: 310.w,
          padding: EdgeInsets.symmetric(vertical: 15.h),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  ProductImageRoutes.newBlueBtnBg),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child:
            StrokeText(
              text: 'Play without a timer',
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
              strokeColor: const Color(0xFF272D39),
              strokeWidth: 3,
            ),
          ),
        ),
      ),
      ],
    ),)
    ,
    )
    ,
    );
  }
}
