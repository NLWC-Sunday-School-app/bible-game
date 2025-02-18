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
      },
      child: Container(
        height: 65.h,
        margin: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFFEEF36A),
          borderRadius:
          BorderRadius.circular(8.r),
          boxShadow: const [
            BoxShadow(
                color: Color(0xFF504136),
                offset: Offset(0, 15),
                blurRadius: 0,
                spreadRadius: -10),
            BoxShadow(
              color: Color(0xFF504136),
              offset: Offset(0, -15),
              blurRadius: 0,
              spreadRadius: -10,
            )
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 25.w),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
            children: [
              StrokeText(
                text:
                'Your Bible Game Recap?',
                textStyle: TextStyle(
                  color:
                  const Color(0xFF047AF3),
                  fontFamily: 'Mikado',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                ),
                strokeColor: Colors.white,
                strokeWidth: 4,
              ),
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
