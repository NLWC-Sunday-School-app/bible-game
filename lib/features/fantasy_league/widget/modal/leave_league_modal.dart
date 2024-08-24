import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:the_bible_game/features/fantasy_league/bloc/fantasy_league_bloc.dart';
import 'package:the_bible_game/shared/widgets/green_button.dart';

import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/features/settings/bloc/settings_bloc.dart';

void showLeaveLeagueModal(BuildContext context, int leagueId, String icon) {
  showDialog(
      context: context,
      barrierColor: const Color.fromRGBO(40, 40, 40, 0.95),
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          backgroundColor: Colors.transparent,
          insetAnimationCurve: Curves.easeIn,
          insetAnimationDuration: const Duration(milliseconds: 500),
          child: LeaveLeagueModal(
            leagueId: leagueId,
            leagueIcon: icon,
          ),
        );
      });
}

class LeaveLeagueModal extends StatelessWidget {
  const LeaveLeagueModal(
      {super.key, required this.leagueId, required this.leagueIcon});

  final int leagueId;
  final String leagueIcon;

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    return SizedBox(
      height: 350.h,
      width: 400.w,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ProductImageRoutes.fblModalBg),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 15.h,
            ),
            GestureDetector(
              onTap: () {
                soundManager.playClickSound();
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      IconImageRoutes.closeModal,
                      width: 35.w,
                    )
                  ],
                ),
              ),
            ),
            FadeInImage.assetNetwork(
              placeholder: ProductImageRoutes.defaultAvatar,
              image: leagueIcon,
              width: 120.w,
              height: 120.h,
            ),
            SizedBox(
              height: 15.h,
            ),
            Center(
              child:

              StrokeText(
                text: 'Are you sure you want to \n        leave this league?',
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                ),
                strokeColor: Colors.black.withOpacity(0.25),
                strokeWidth: 1,
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            BlocBuilder<FantasyLeagueBloc, FantasyLeagueState>(
              builder: (context, state) {
                return GreenButton(
                    buttonIsLoading: state.isLeavingLeague,
                    onTap: () {
                      Navigator.pop(context);
                      BlocProvider.of<FantasyLeagueBloc>(context)
                          .add(LeaveLeague(leagueId));
                      Navigator.pop(context);
                    },
                    width: 320.w,
                    customWidget: Center(
                      child: StrokeText(
                        text: 'Yes, I want to',
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        strokeColor: Color(0xFF272D39),
                        strokeWidth: 1,
                      ),
                    ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
