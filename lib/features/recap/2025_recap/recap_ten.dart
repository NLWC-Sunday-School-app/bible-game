import 'dart:math';

import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:bible_game/shared/features/user/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:stroke_text/stroke_text.dart';

class RecapTenScreen extends StatelessWidget {
  const RecapTenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.recapTenBck),
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
                      'Peak Playing Month',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontFamily: 'Mikado',
                        color: Color(0xFFFFD817),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                      SizedBox(height: 80.h,),
                    SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: Stack(
                          children: [
                            Transform.rotate(
                              angle: -pi/40,
                              child: StrokeText(
                                text: DateFormat.MMMM().format(DateTime.parse('${state.userInsightYearlyRecap!.peakPlayingMonth!.month}-01')).toUpperCase(),
                                textStyle: TextStyle(
                                    fontSize: 53.sp,
                                    fontFamily: 'Mikado',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    shadows: [Shadow(
                                      color: Color(0xFF000000),
                                      blurRadius: 0,
                                      offset: Offset(-2, 2),
                                    ),
                                      Shadow(
                                        color: Color(0xFF000000),
                                        blurRadius: 0,
                                        offset: Offset(-2, 2),
                                      )
                                    ]
                                ),
                                strokeColor: Color(0xFF97405C),
                                strokeWidth: 1.5,
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
                              child: Transform.rotate(
                                angle: -pi/40,
                                child: StrokeText(
                                  text: DateFormat.MMMM().format(DateTime.parse('${state.userInsightYearlyRecap!.peakPlayingMonth!.month}-01')).toUpperCase(),
                                  textStyle: TextStyle(
                                      fontSize: 52.sp,
                                      fontFamily: 'Mikado',
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      shadows: [Shadow(
                                        color: Color(0xFF000000),
                                        blurRadius: 0,
                                        offset: Offset(-2, 2),
                                      ),
                                        Shadow(
                                          color: Color(0xFF000000),
                                          blurRadius: 0,
                                          offset: Offset(-2, 2),
                                        )
                                      ]
                                  ),
                                  strokeColor: Color(0xFF97405C),
                                  strokeWidth: 1.5,
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
              child: Padding(
                padding: EdgeInsets.only(bottom: 150.h),
                child: Column(children: [
                  Spacer(),
                  Text(
                    'You played a total of',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontFamily: 'Mikado',
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 16.h,),
                  Text(
                    "${state.userInsightYearlyRecap!.peakPlayingMonth!.totalGames}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 72.sp,
                      fontFamily: 'Mikado',
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'games',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 44.sp,
                      fontFamily: 'Gochi hand',
                      color: Color(0xFFFFD817),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 52.h,),
                  Text(
                    'In your peak season, you were\nunstoppable, the grace was clearly there',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontFamily: 'Gochi hand',
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],),
              ),
            )
          ],
        );
      }
    );
  }
}
