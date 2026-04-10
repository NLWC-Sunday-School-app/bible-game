import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/widgets/tablet_view_widget/blue_button_tablet_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';

import '../../../../shared/widgets/blue_button.dart';

class LeagueCardTabletView extends StatelessWidget {
  const LeagueCardTabletView({super.key, required this.onTap, required this.id, required this.name, required this.playerCount, required this.icon});
  final VoidCallback onTap;
  final int id;
  final String name;
  final int playerCount;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.symmetric(vertical: 5.h),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: Colors.white),
        gradient: LinearGradient(
          colors: [
            Color(0xFFF0FFFE),
            Color(0xFFD7EEED),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF7BB7B4),
            offset: Offset(2, 4),
            blurRadius: 0,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FadeInImage.assetNetwork(
            placeholder: ProductImageRoutes.defaultAvatar,
            image: icon,
            width: 40.w,
          ),
          SizedBox(
            width: 16.w,
          ),
          StrokeText(
            text: name,
            textStyle: TextStyle(
              color: Color(0xFF0D468A),
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
            strokeColor: Colors.white,
            strokeWidth: 1,
          ),
          Spacer(),
          Column(
            children: [
              Text(
                'Members',
                style: TextStyle(
                    fontSize: 10.sp,
                    color: Color(0xFF619290),
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 1.h,
              ),
              Container(
                width: 55.w,
                padding: EdgeInsets.symmetric(
                    horizontal: 2.w, vertical: 3.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  color: Color(0xFFDEEFEE),
                  border:
                  Border.all(color: Color(0xFFA6AEAE), width: 1.w),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x40000000),
                      offset: Offset(0, 2),
                      blurRadius: 4, // Blur effect
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '$playerCount/${context.read<SettingsBloc>().state.gamePlaySettings['league_members_limit']}',
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF554A0C)),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            width: 48.w,
          ),
          BlueButtonTabletView(
            onTap: onTap,
            height: 50.h,
            fontSize: 14.sp,
            buttonText: 'View',
            buttonIsLoading: false,
            width: 78.w,
          )
        ],
      ),
    );
  }
}
