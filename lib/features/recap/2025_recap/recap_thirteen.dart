import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';

class RecapThirteenScreen extends StatelessWidget {
  const RecapThirteenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.recapThirteenBck),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.recapThirteenStar),
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
                      'Global Winner',
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
                      'You completed 3 Global challenges and\nwon',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: 'Gochi hand',
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    StrokeText(
                        text: "${state.userInsightYearlyRecap!.globalWinner}",
                      textStyle: TextStyle(
                        fontSize: 88.sp,
                        fontFamily: 'Mikado',
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        shadows: [Shadow(
                          color: Color(0xFFD8D8D8),
                          blurRadius: 0,
                          offset: Offset(-2, 2),
                        ),
                          Shadow(
                            color: Color(0xFFD8D8D8),
                            blurRadius: 0,
                            offset: Offset(-2, 2),
                          )
                        ]
                      ),
                      strokeColor: Color(0xFFB2B2B2),
                    ),
                    Image.asset(ProductImageRoutes.recapThirteenGif)
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
                      'You took on global challenges;\nyour faith was rewarded!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontFamily: 'Gochi hand',
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
