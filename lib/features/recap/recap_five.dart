import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../shared/constants/image_routes.dart';
import '../../shared/features/user/bloc/user_bloc.dart';
import '../../shared/utils/avatar_credentials.dart';


class RecapFiveScreen extends StatelessWidget {
  const RecapFiveScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      ProductImageRoutes.recapFiveBg),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 110.h,
              right: 0.w,
              left: 0.w,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border:
                      Border.all(width: 3.w, color: const Color(0xFF366ABC)),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border:
                        Border.all(width: 2.w, color: const Color(0xFF4A91FF)),
                      ),
                      child: SvgPicture.network(
                        '${AvatarCredentials.BaseURL}/${state.user.id}.svg?apikey=${AvatarCredentials.APIKey}/',
                        width: 70.w,
                        semanticsLabel: 'Logo',
                        placeholderBuilder: (BuildContext context) => Image.asset(ProductImageRoutes.defaultAvatar, width: 50.w,),
                      ),
                      padding: EdgeInsets.all(5.w),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    state.user.name,
                    style: TextStyle(
                        fontFamily: 'Mikado',
                        fontWeight: FontWeight.w500,
                        fontSize: 20.sp),
                  ).animate()
                      .fadeIn(duration: 500.ms)
                      .scale(delay: 300.ms),
                ],
              ),
            ),
            Positioned(
              top: 420.h,
              right: 0.w,
              left: 0.w,
              child: Column(
                children: [
                  Text(
                    '${BlocProvider.of<UserBloc>(context).state.userYearlyRecap['total_number_of_user_game_plays']} Games',
                    style: TextStyle(
                      fontSize: 48.sp,
                      fontFamily: 'Mikado',
                      fontWeight: FontWeight.w700,
                    ),
                  ).animate()
                      .fadeIn(delay: 600.ms, duration: 900.ms),
                  // .scale(delay: 500.ms),
                  Text(
                    'this year',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 620.h,
              left: 0.w,
              right: 0.w,
              child: Column(
                children: [
                  Text.rich(
                    TextSpan(
                        text: 'makes you',
                        style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Gochi Hand'
                        ),
                        children: [
                          TextSpan(
                              text: ' top ${BlocProvider.of<UserBloc>(context).state.userYearlyRecap['user_percentile']}%',
                              style: const TextStyle(
                                  color: Color(0xFFFFF500)
                              )
                          ),
                          const TextSpan(
                              text: ' of all \nBible Gamers round the world'
                          )
                        ]
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
