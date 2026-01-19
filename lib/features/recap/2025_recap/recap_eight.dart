import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:bible_game/shared/features/user/model/user.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecapEightScreen extends StatelessWidget {
  const RecapEightScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.recapEightBck),
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
                      'Total Coins Earned',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontFamily: 'Mikado',
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Image.asset(
                      ProductImageRoutes.recapEightGif,
                      scale: 0.8,
                    ),

                  ],
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
                child:Padding(
                  padding: EdgeInsets.only(bottom: 120.h),
                  child: Column(
                    children: [
                      Spacer(),
                      Text(
                        'You collected a total of',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontFamily: 'Gochi hand',
                          color: Color(0xFF22210D),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Countup(
                        begin: state.userInsightYearlyRecap!.totalCoinsGotten!.toDouble(),
                        end:  state.userInsightYearlyRecap!.totalCoinsGotten!.toDouble(),
                        duration: const Duration(seconds: 2),
                        separator: ',',
                        style: TextStyle(
                          fontSize: 60.sp,
                          fontFamily: 'Mikado',
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Coins',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 44.sp,
                          fontFamily: 'Gochi hand',
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Get more coins by playing more games!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontFamily: 'Gochi hand',
                          color: Colors.black,
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
