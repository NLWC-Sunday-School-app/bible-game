import 'dart:math';

import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecapTwoScreen extends StatefulWidget {
  const RecapTwoScreen({Key? key}) : super(key: key);

  @override
  State<RecapTwoScreen> createState() => _RecapTwoScreenState();
}

class _RecapTwoScreenState extends State<RecapTwoScreen> {
  double height = 0;
  double width = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2),
        (){
          setState(() {
            height = 380.h;
            width = 380.w;
          });
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc,UserState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.brown,
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.recapTwoBck),
                  fit: BoxFit.cover,
                ),
              ),
            ),
        
            Positioned(
              top: 80.h,
              left: 10.w,
              child: Image.asset(
                ProductImageRoutes.recapTwoBook,
                height: 150,
                width: 150,
              ).animate(
                  delay: Duration(seconds: 2)
              )
                  .fade()
                  .slideX(
                begin: -1,
              ),
            ),
        
            Positioned(
                top: 200.h,
                left: 35.w,
                child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Transform.rotate(
                      angle: -pi/40,
                      child: Text(
                        'Top\nBible Game\nPlayers',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 58.sp,
                          fontFamily: 'Mikado',
                          height: 1.2,
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ).animate(
                          delay: Duration(milliseconds: 100)
                      )
                      .scaleXY(
                        begin: 1,
                        end: 0.7,
                        curve: Curves.bounceOut
                      )
                      ,
                    ),
                  ],
                )
            ),
            Positioned(
                top: 400.h,
                left: 50.w,
                child: Text(
                  "You're in the top ${state.userInsightYearlyRecap!.userPercentile}% of Bible scholars",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: 'Mikado',
                    color: Color(0xFF313736),
                    fontWeight: FontWeight.w900,
                  ),
                ).animate(
                    delay: Duration(seconds: 2)
                )
                    .fade()
                    .slideX(
                  begin: 1,
                ),
            ),
            Positioned(
              top: 400.h,
              right: 10.w,
              child: Image.asset(
                ProductImageRoutes.recapTwoHat,
                height: 150,
                width: 150,
              ).animate(
                delay: Duration(seconds: 2)
              )
                  .fade()
                  .slideX(
                begin: 1,
              ),
            ),
            Align(
                alignment: Alignment.bottomRight,
                child:AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  height: height,
                  width: width,
                  child: Image.asset(
                    ProductImageRoutes.recapTwoStar
                  ),
                )
        
            )
          ],
        );
      }
    );
  }
}
