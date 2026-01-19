import 'package:bible_game/features/recap/home.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../shared/features/user/bloc/user_bloc.dart';

class RecapButton extends StatelessWidget {
  const RecapButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        showRecapModal(context);
        BlocProvider.of<UserBloc>(context)
            .add(FetchUserYearlyRecap());
        BlocProvider.of<UserBloc>(context)
            .add(FetchUserInsightYearlyRecap());
      },
      child: Container(
        height: 65.h,
        margin: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ProductImageRoutes.recap2025Bck),
            fit: BoxFit.cover,
            opacity: 0.3
          ),
          color: const Color(0xFFEEF36A),
          gradient: LinearGradient(
            colors: [
              Color(0xFFDCFF7D),
              Color(0xFFCFE8FF),
              Color(0xFFCCFFBD),
            ]
          ),
          borderRadius:
          BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.white,
            width: 0.5
          )
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                ProductImageRoutes.recap2025,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StrokeText(
                    text:
                    'Your 2025 Bible Game Recap!',
                    textStyle: TextStyle(
                      color:
                      const Color(0xFF047AF3),
                      fontFamily: 'Mikado',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                    ),
                    strokeColor: Colors.white,
                    strokeWidth: 4,
                  ),
                  SizedBox(height: 4.h,),
                  Text(
                    "A year of wins, growth, and grace. Let’s celebrate!",
                    style: TextStyle(
                      color:
                      const Color(0xFF3B3B3B),
                      fontFamily: 'Mikado',
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              Spacer(),
              Image.asset(
                IconImageRoutes.blueForwardArrowIcon,
                width: 32.w,
              )
            ],
          ),
        ),
      ),
    );
  }
}
