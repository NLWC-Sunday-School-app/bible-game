import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:countup/countup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../shared/features/user/bloc/user_bloc.dart';
import '../../../shared/utils/avatar_credentials.dart';
import '../../../shared/widgets/multi_avatar.dart';

class RecapThreeScreen extends StatefulWidget {
  const RecapThreeScreen({Key? key}) : super(key: key);

  @override
  State<RecapThreeScreen> createState() => _RecapThreeScreenState();
}

class _RecapThreeScreenState extends State<RecapThreeScreen> {
  double bottom1 = 135.h;
  double bottom2 = 100.h;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2),
            (){
          setState(() {
            bottom1= 125.h;
            bottom2= 90.h;
          });
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.recapThreeBck),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 80.h,
              left: 0,
              child: Image.asset(
                  ProductImageRoutes.recapThreeLeft,
                height: 200.h,
              ).animate()
              .fadeIn(
                delay: Duration(seconds: 2),
              )
                  .slideX(
                begin: -1,
              ),
            ),
            Positioned(
              bottom: 200.h,
              right: 0,
              child: Image.asset(
                ProductImageRoutes.recapThreeRight,
                height: 200.h,
              ).animate(
              )
                  .fadeIn(
                delay: Duration(seconds: 2),
              )
                  .slideX(
                begin: 1,
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
                      'Total Games Played',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontFamily: 'Mikado',
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 32.h,),
                    Container(
                      width: 98.w,
                      height: 98.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                            color: Colors.white,
                            width: 8.w,
                        )
                      ),
                      child: AvatarWidget(seed: state.user.id.toString(), width: 35.w, height: 35.h,)
                    ),
                    SizedBox(height: 16.h,),
                    Text(
                      '@${state.user.name}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontFamily: 'Mikado',
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 36.h,),
                    Text(
                      'You have played a total of',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: 'Mikado',
                        color: Colors.black,
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 48.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlocBuilder<UserBloc,UserState>(
                            builder: (context, state) {
                              return Countup(
                                begin: 0,
                                end: state.userInsightYearlyRecap!.totalNumberOfUserGamePlays!.toDouble(),
                                duration: const Duration(seconds: 2),
                                separator: ',',
                                style: TextStyle(
                                    fontSize: 48.sp,
                                    fontFamily: 'Mikado',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900
                                ),
                              );
                            }
                        ),
                        Text(
                          " Games",
                          style:TextStyle(
                              fontSize: 48.sp,
                              fontFamily: 'Mikado',
                              color: Colors.white,
                              fontWeight: FontWeight.w900
                          ),
                        )
                      ],
                    ),
                    Text(
                      'this year',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: 'Mikado',
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              bottom: bottom1,
              right: 235.w,
                duration: Duration(milliseconds: 500),
              child: Image.asset(
                ProductImageRoutes.recapThreeOne,
                width: 113,
              )
            ),
            AnimatedPositioned(
              bottom: bottom2,
              right: 152.w,
                duration: Duration(milliseconds: 700),
                child: Image.asset(
                ProductImageRoutes.recapThreeTwo,
                width: 113,
              )
            ),
            AnimatedPositioned(
              bottom: bottom1,
              right: 79.w,
              duration: Duration(milliseconds: 500),
              child: Image.asset(
                ProductImageRoutes.recapThreeThree,
                width: 113,
              )
            ),
            AnimatedPositioned(
              bottom: bottom2,
              right: 26,
                duration: Duration(milliseconds: 700),
                child: Image.asset(
                ProductImageRoutes.recapThreeFour,
                width: 113,
              )
            ),
          ],
        );
      }
    );
  }
}
