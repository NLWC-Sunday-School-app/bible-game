import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:the_bible_game/features/fantasy_league/bloc/fantasy_league_bloc.dart';
import 'package:the_bible_game/features/fantasy_league/widget/league_card.dart';
import 'package:the_bible_game/shared/constants/app_routes.dart';

import '../../../shared/constants/image_routes.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../shared/widgets/green_button.dart';

class MyLeagues extends StatefulWidget {
  const MyLeagues({super.key, required this.screenHeight});

  final double screenHeight;

  @override
  State<MyLeagues> createState() => _MyLeaguesState();
}

class _MyLeaguesState extends State<MyLeagues> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FantasyLeagueBloc>(context).add(FetchUserLeagues());
  }

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    return BlocBuilder<FantasyLeagueBloc, FantasyLeagueState>(
      builder: (context, state) {
        return Container(
          child: state.isFetchingUserLeagues
              ? Container(
                  margin: EdgeInsets.only(top: 20.h),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : state.userLeagues.isNotEmpty
                  ? SizedBox(
                      height:
                          widget.screenHeight - (150.h + 20.h + 72.h + 125.h),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: state.userLeagues.length,
                        itemBuilder: (BuildContext context, int index) {
                          return LeagueCard(
                            onTap: () {
                              soundManager.playClickSound();
                              Navigator.pushNamed(
                                  context, AppRoutes.myLeagueScreen,
                                  arguments: {
                                    'leagueId': state.userLeagues[index].id
                                  });
                              soundManager.playClickSound();
                            },
                            id: state.userLeagues[index].id,
                            name: state.userLeagues[index].name,
                            playerCount: state.userLeagues[index].playerCount,
                            icon: state.userLeagues[index].icon,
                          );
                        },
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Container(
                        width: double.infinity,
                        height:widget.screenHeight - (150.h + 20.h + 72.h + 170.h),
                        margin: EdgeInsets.only(top: 20.h, bottom: 10.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Color(0xFF032956)),
                          color: Color(0xFF093D7B),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 30.h,
                            ),
                            Image.asset(
                              ProductImageRoutes.broLukeInfo,
                              width: 65.w,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              'You are not a part \nof any active league',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.sp,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            GreenButton(
                              buttonIsLoading: false,
                              width: 260.w,
                              onTap: () {
                                soundManager.playClickSound();
                                // Navigator.pushNamed(context,
                                //     AppRoutes.fantasyBibleLeagueHomeScreen);
                              },
                              customWidget: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StrokeText(
                                    text: 'Create a league',
                                    textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    strokeColor: const Color(0xFF272D39),
                                    strokeWidth: 1,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
        );
      },
    );
  }
}
