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
                  image: AssetImage(ProductImageRoutes.recapFourBg),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Positioned(
              top: 430.h,
              left: 30.w,
              child: Countup(
                begin: 0,
                end: state.userYearlyRecap['total_number_of_games_played'].toDouble(),
                duration: const Duration(seconds: 2),
                separator: ',',
                style: TextStyle(
                    fontSize: 70.sp,
                    fontFamily: 'Mikado',
                    color: Colors.white,
                    fontWeight: FontWeight.w900
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
