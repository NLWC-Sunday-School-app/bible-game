import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecapSixScreen extends StatelessWidget {
  const RecapSixScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.recapSixBckGif),
                  fit: BoxFit.cover,
                  opacity: 0.2,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.recapSixBck),
                  opacity: 0.9,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.recapSixStarBck),
                  // opacity: 0.9,
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
                      'Total Questions Answered',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontFamily: 'Mikado',
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 74.h,),
                    Text(
                      'You answered',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontFamily: 'Gochi hand',
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Countup(
                      begin: 0,
                      end:  state.userInsightYearlyRecap!.totalQuestionsGotten!.toDouble(),
                      duration: const Duration(seconds: 2),
                      separator: ',',
                      style: TextStyle(
                        fontSize: 88.sp,
                        fontFamily: 'Mikado',
                        color: Color(0xffD5FFF6),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                          text:'Questions',
                          style: TextStyle(
                            color: Colors.white
                          ),
                          children: [
                            TextSpan(
                                text:" Correctly!",
                                style: TextStyle(
                                  color: Color(0xFFF3A829),
                                )
                            )
                          ]
                      ),
                      style: TextStyle(
                        fontSize: 36.sp,
                        fontFamily: 'Gochi hand',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
                child:Padding(
                  padding: EdgeInsets.only(bottom: 160.h),
                  child: Column(
                    children: [
                      Spacer(),
                      Image.asset(
                          ProductImageRoutes.recapSixGif,
                        scale: 0.7,
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
