import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecapNineScreen extends StatelessWidget {
  const RecapNineScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.recapNineBck),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 150.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Best Bible Game Streak',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontFamily: 'Mikado',
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 36.h,),
                    Text(
                      'Your Longest Streak...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: 'Gochi hand',
                        color: Color(0xFF2D2D2D),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 10.h,),
                    Image.asset(
                      ProductImageRoutes.recapNineGif,
                      width: 117.w,
                    ),

                  ],
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
                child:Padding(
                  padding: EdgeInsets.only(bottom: 150.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Spacer(),
                      Text(
                        '${state.userInsightYearlyRecap!.highestStreak}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 88.sp,
                          fontFamily: 'Mikado',
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'days',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 44.sp,
                          fontFamily: 'Gochi hand',
                          height: 0.5,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 21.h,),
                      Text(
                        "Like the widow's oil, your streak did\nnot run dry!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: 'Gochi hand',
                          color: Color(0xFF2D2D2D),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
            ),
          ],
        );
      }
    );
  }
}
