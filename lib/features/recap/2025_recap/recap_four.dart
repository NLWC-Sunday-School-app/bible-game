import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';

class RecapFourScreen extends StatelessWidget {
  const RecapFourScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.recapFourBck),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Positioned(
            //   top: 430.h,
            //   left: 30.w,
            //   child: Countup(
            //     begin: 0,
            //     end: state.userYearlyRecap['total_number_of_games_played'].toDouble(),
            //     duration: const Duration(seconds: 2),
            //     separator: ',',
            //     style: TextStyle(
            //         fontSize: 70.sp,
            //         fontFamily: 'Mikado',
            //         color: Colors.white,
            //         fontWeight: FontWeight.w900
            //     ),
            //   ),
            // )
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(top: 120.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'You spent a total of',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontFamily: 'Gochi Hand',
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 32.h,),
                    Text(
                      "${state.userInsightYearlyRecap!.totalMinutesSpent}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 88.sp,
                        fontFamily: 'Mikado',
                        color: Color(0xffD5FFF6),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'minutes',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontFamily: 'Mikado',
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 36.h,),
                    Text(
                      '...that is ${(state.userInsightYearlyRecap!.totalMinutesSpent!/60).toStringAsFixed(2)} hours\ngrowing in faith!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: 'Mikado',
                        color: Color(0xFFFEE6C2),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              bottom: 140.h,
                left: 65.w,
                child:Image.asset(
                    ProductImageRoutes.recapFourSandTimeBg,
                  width: 240.w,
                ),
            ),
            Positioned(
              bottom: 180.h,
              left: 120.w,
              child: Image.asset(
                  ProductImageRoutes.recapFourSandTimeGif,
                width: 199.w,
                // height: 202.h,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 120.h),
                child: Text.rich(
                    TextSpan(
                      text:'you indeed',
                      style: TextStyle(
                        color: Color(0xFFF3A829),
                      ),
                      children: [
                        TextSpan(
                          text:" redeemed your time!",
                          style: TextStyle(
                            color: Colors.white
                          )
                        )
                      ]
                    ),
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontFamily: 'Gochi Hand',
                    // color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
