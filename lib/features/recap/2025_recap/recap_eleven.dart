import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:bible_game/shared/features/user/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class RecapElevenScreen extends StatelessWidget {
  const RecapElevenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context,state) {
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.recapElevenBck),
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
                      'Longest Session',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontFamily: 'Mikado',
                        color: Color(0xFF3C4245),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 40.h,),
                    Text(
                      'Your Marathon session',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: 'Gochi hand',
                        color: Color(0xFF3C4245),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      "${state.userInsightYearlyRecap!.longestSession!.sessionTime}min",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 52.sp,
                        fontFamily: 'Mikado',
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      "on ${DateFormat('MMMM d').format(DateTime.parse(state.userInsightYearlyRecap!.longestSession!.sessionDate.toString()).toLocal())}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 44.sp,
                        fontFamily: 'Gochi hand',
                        color: Color(0xff3C4245),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Align(
              alignment: Alignment.bottomLeft,
                child:Image.asset(
                    ProductImageRoutes.recapElevenGifRoad,
                  scale: 0.42,
                ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child:Padding(
                padding: EdgeInsets.only(bottom: 250.h),
                child: Column(
                  children: [
                    Spacer(),
                    Image.asset(
                      ProductImageRoutes.recapElevenGifClock,
                      scale: 0.8,
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
                    Text(
                      'Your longest session showed pure dedication;\nyou ran the race with endurance!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: 'Mikado',
                        color: Colors.white,
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
