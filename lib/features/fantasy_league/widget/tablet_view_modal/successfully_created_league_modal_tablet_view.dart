import 'package:another_flushbar/flushbar.dart';
import 'package:bible_game/shared/widgets/tablet_view_widget/blue_button_tablet_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/features/fantasy_league/bloc/fantasy_league_bloc.dart';
import 'package:bible_game/shared/widgets/blue_button.dart';
import 'package:intl/intl.dart';
import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../../shared/widgets/custom_toast.dart';

void showSuccessfullyCreatedModalTabletView(BuildContext context) {
  showDialog(
      context: context,
      // barrierDismissible: false,
      barrierColor: const Color.fromRGBO(40, 40, 40, 0.95),
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          backgroundColor: Colors.transparent,
          insetAnimationCurve: Curves.easeIn,
          insetAnimationDuration: const Duration(milliseconds: 500),
          child: SuccessfullyCreatedLeagueTabletView(),
        );
      });
}

 dynamic getWeeksLeft(seasonEndDate){
   final leagueSeasonEndDate = DateFormat('yyyy-MM-dd').parse(seasonEndDate);
   final currentDate = DateTime.now();
   final differenceInDays = leagueSeasonEndDate.difference(currentDate).inDays;
   final weeksLeft = (differenceInDays / 7).ceil();
   return weeksLeft;
 }

class SuccessfullyCreatedLeagueTabletView extends StatelessWidget {
  const SuccessfullyCreatedLeagueTabletView({super.key});

  void _copyText(BuildContext context, leagueGoal, leagueName, leagueDuration,
      leagueCode) {
    showCustomToast(context, 'Copied');
    Clipboard.setData(ClipboardData(
        text:
            'Can you get ${NumberFormat('#,##0').format(leagueGoal)} coins before me in $leagueDuration ${leagueDuration > 1 ? 'weeks' : 'week'}? Join my League ($leagueName) on the Bible game app using this code $leagueCode \n\nhttps://linktr.ee/biblegame_'));
  }

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    return BlocBuilder<FantasyLeagueBloc, FantasyLeagueState>(
      builder: (context, state) {
        return SizedBox(
          height: 480.h,
          width: 638.w,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ProductImageRoutes.leagueSuccessModalBgTabletView),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 17.h,
                ),
                StrokeText(
                  text: state.createdLeagueData!['name'],
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  strokeColor: Colors.black.withOpacity(0.25),
                  strokeWidth: 1,
                ),
                SizedBox(
                  height: 70.h,
                ),
                Image.asset(
                  ProductImageRoutes.multiplayerGembox,
                  width: 99.w,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Get your friends to join your league! \nShare your league code!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp),
                ),
                SizedBox(
                  height: 12.h,
                ),
                Container(
                  width: 354.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFD8B98C)),
                      borderRadius: BorderRadius.circular(4.r)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.createdLeagueData!['code'],
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF014CA3),
                        ),
                      ),
                      SizedBox(width: 44.w,),
                      InkWell(
                        onTap: () {
                          soundManager.playClickSound();
                          _copyText(
                            context,
                            state.createdLeagueData!['goal'],
                            state.createdLeagueData!['name'],
                            getWeeksLeft(state.createdLeagueData!['seasonEnd']),
                            state.createdLeagueData!['code'],
                          );
                        },
                        child: Icon(
                          Icons.copy,
                          color: Color(0xFF014CA3),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40.h,
                ),
                BlueButtonTabletView(
                  buttonText: 'Open my fantasy league',
                  buttonIsLoading: false,
                  width: 354.w,
                  onTap: () {
                    soundManager.playClickSound();
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
