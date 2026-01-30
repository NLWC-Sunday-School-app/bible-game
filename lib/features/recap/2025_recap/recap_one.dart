import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecapOneScreen extends StatelessWidget {
  const RecapOneScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.recapOneBck),
                  fit: BoxFit.cover,
                ),
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
                      'Hello ${state.user.name},',
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontFamily: 'Mikado',
                        height: 1,
                        color: Color(0xFF00EDB9),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Transform.rotate(
                      angle: -pi/40,
                    child: AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          ' Your\n Bible Game\n recap!',
                          textStyle: TextStyle(
                            fontSize: 50.sp,
                            fontFamily: 'Mikado',
                            height: 1,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                          speed: const Duration(milliseconds: 100),
                        ),
                      ],
                      isRepeatingAnimation: false,
                      pause: const Duration(milliseconds: 1000),
                      displayFullTextOnTap: true,
                      stopPauseOnTap: true,
                    )
                  ),
                  Transform.rotate(
                    angle: -pi/40,
                    child: Text(
                      '  2025',
                      style: TextStyle(
                        fontSize: 52.sp,
                        fontFamily: 'Mikado',
                        color: Color(0xFF00EDB9),
                        fontWeight: FontWeight.w900,
                      ),
                    ).animate()
                    .fadeIn(duration: Duration(seconds: 1)),
                  ),
                ],
              )
            )
          ],
        );
      }
    );
  }
}
