import 'dart:math';

import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:stroke_text/stroke_text.dart';

class RecapTwelveScreen extends StatelessWidget {
  const RecapTwelveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.recapTwelveBck),
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
                      'First Game of 2025',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontFamily: 'Mikado',
                        color: Color(0xFF191919),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 28.h,),
                    Text(
                      'Your year started with a Lightning\nRound victory on',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: 'Mikado',
                        color: Color(0xFF898989),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 20.h,),
                    SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Stack(
                          children: [
                            Text(
                              DateFormat('d\nMMMM').format(DateTime.parse('${state.userInsightYearlyRecap!.firstGameOfYear}')).toUpperCase(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 53.sp,
                                  fontFamily: 'Mikado',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                              ),
                            ).animate(
                                autoPlay: true
                            )
                                .scaleXY(
                                begin: 0,
                                end: 1,
                                curve: Curves.elasticInOut,
                                duration: Duration(milliseconds: 2000),
                                alignment: Alignment.bottomRight
                            ),
                            Positioned(
                              left: 4,
                              bottom: 5,
                              child: Text(
                                DateFormat('d\nMMMM').format(DateTime.parse('${state.userInsightYearlyRecap!.firstGameOfYear}')).toUpperCase(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 52.sp,
                                    fontFamily: 'Mikado',
                                    color: Color(0xFF737373),
                                    fontWeight: FontWeight.w900,

                                ),
                              ),
                            ).animate(
                                autoPlay: true
                            )
                                .scaleXY(
                                begin: 0,
                                end: 1,
                                curve: Curves.elasticInOut,
                                duration: Duration(milliseconds: 3000),
                                alignment: Alignment.bottomRight
                            )

                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child:Padding(
                padding: EdgeInsets.only(bottom: 130.h),
                child: Column(
                  children: [
                    Spacer(),
                    Image.asset(
                        ProductImageRoutes.recapTwelvePad,
                      width: 266.w,
                    ),
                    SizedBox(height: 64.h,),
                    Text(
                      'You started the year in victory; first fruits\nof the year',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: 'Gochi hand',
                        color: Color(0xFF898989),
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
