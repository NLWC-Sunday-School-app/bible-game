import 'package:another_flushbar/flushbar.dart';
import 'package:bible_game_api/utils/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:the_bible_game/features/fantasy_league/widget/modal/fantasy_bible_league_guide.dart';
import 'package:the_bible_game/features/fantasy_league/widget/modal/leave_league_modal.dart';

import '../../../shared/constants/colors.dart';
import '../../../shared/constants/image_routes.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../shared/widgets/screen_app_bar.dart';
import '../bloc/fantasy_league_bloc.dart';
import '../widget/league_player_card.dart';

class MyLeagueScreen extends StatefulWidget {
  const MyLeagueScreen({super.key});

  @override
  State<MyLeagueScreen> createState() => _MyLeagueScreenState();
}

class _MyLeagueScreenState extends State<MyLeagueScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final leagueId = arguments['leagueId'];
    BlocProvider.of<FantasyLeagueBloc>(context).add(ViewLeagueData(leagueId));
  }

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    return Scaffold(
        backgroundColor: Color(0xFF014AA0),
        body: BlocConsumer<FantasyLeagueBloc, FantasyLeagueState>(
          listener: (context, state) {
            if (state.hasLeftLeague) {
              Navigator.pop(context);
              Flushbar(
                message: 'Left successfully',
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              ).show(context);
            }

            if (state.failedToLeave) {
              ApiException.showSnackBar(context);
            }
          },
          builder: (context, state) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(ProductImageRoutes.patternTwoBg),
                fit: BoxFit.cover,
              )),
              child: Container(
                child: Column(
                  children: [
                    ScreenAppBar(
                      widgets: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                soundManager.playClickSound();
                                Navigator.pop(context);
                              },
                              child: Image.asset(
                                IconImageRoutes.arrowCircleBack,
                                width: 44.w,
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: StrokeText(
                                  text: 'My leagues',
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 26.sp,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  strokeColor: AppColors.titleDropShadowColor,
                                  strokeWidth: 6,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                soundManager.playClickSound();
                                showFantasyBibleLeagueGuide(context);
                              },
                              child: Image.asset(
                                IconImageRoutes.infoCircle,
                                width: 44.w,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    state.isFetchingLeagueData
                        ? Container(
                            margin: EdgeInsets.only(top: 80.h),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Container(
                                  height: 215.h,
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 10.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4.r),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFFF0FFFE),
                                        Color(0xFFD7EEED),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Spacer(),
                                          FadeInImage.assetNetwork(
                                            placeholder: ProductImageRoutes
                                                .defaultAvatar,
                                            image: state.leagueData.league.icon,
                                            width: 65.w,
                                            height: 65.h,
                                          ),
                                          SizedBox(
                                            width: 50.w,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showLeaveLeagueModal(
                                                  context,
                                                  state.leagueData.league.id,
                                                  state.leagueData.league.icon);
                                            },
                                            child: Container(
                                              width: 70.w,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5.w,
                                                  vertical: 10.h),
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                    ProductImageRoutes
                                                        .leaveBtnBg,
                                                  ),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              child: Center(
                                                child: state.isLeavingLeague
                                                    ? SizedBox(
                                                        height: 20.h,
                                                        width: 20.w,
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.white,
                                                          strokeWidth: 2,
                                                        ))
                                                    : Text(
                                                        'Leave',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w900,
                                                          fontSize: 14.sp,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      StrokeText(
                                        text: state.leagueData.league.name,
                                        textStyle: TextStyle(
                                          color: const Color(0xFF014CA3),
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w900,
                                        ),
                                        strokeColor:
                                            Colors.black.withOpacity(0.25),
                                        strokeWidth: 1,
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w, vertical: 10.h),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFD7EEED),
                                            border: Border.all(
                                                color: Color(0xFFB9BDBD)),
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                        text: 'Members:',
                                                        style: TextStyle(
                                                          fontFamily: 'Mikado',
                                                          color:
                                                              Color(0xFF4A5240),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 14.sp,
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                              text:
                                                                  ' ${state.leagueData.metrics.membersCount}/${context.read<SettingsBloc>().state.gamePlaySettings['league_members_limit']}',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  color: Color(
                                                                      0xFF01200F),
                                                                  fontSize:
                                                                      14.sp))
                                                        ]),
                                                  ),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                        text: 'Coins:',
                                                        style: TextStyle(
                                                          fontFamily: 'Mikado',
                                                          color:
                                                              Color(0xFF4A5240),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 14.sp,
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                              text:
                                                                  '${state.leagueData.metrics.coinTrack}',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Mikado',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  color: Color(
                                                                      0xFF01200F),
                                                                  fontSize:
                                                                      14.sp))
                                                        ]),
                                                  )
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                        text: 'Weeks left: ',
                                                        style: TextStyle(
                                                          fontFamily: 'Mikado',
                                                          color:
                                                              Color(0xFF4A5240),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 14.sp,
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                              text: state
                                                                  .leagueData
                                                                  .metrics
                                                                  .weeksLeft,
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Mikado',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  color: Color(
                                                                      0xFF01200F),
                                                                  fontSize:
                                                                      14.sp))
                                                        ]),
                                                  ),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                        text: 'Type:',
                                                        style: TextStyle(
                                                          fontFamily: 'Mikado',
                                                          color:
                                                              Color(0xFF4A5240),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 14.sp,
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                              text: state
                                                                      .leagueData
                                                                      .league
                                                                      .isOpen
                                                                  ? ' • Open'
                                                                  : ' • Closed',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Mikado',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize:
                                                                      14.sp))
                                                        ]),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height -
                                    (150.h + 230.h + 20.h),
                                child: ListView.builder(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  itemCount:
                                      state.leagueData.leaderBoard.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return LeaguePlayerCard(
                                      username: state.leagueData
                                          .leaderBoard[index].username,
                                      userId: state
                                          .leagueData.leaderBoard[index].userId,
                                      points: state
                                          .leagueData.leaderBoard[index].points,
                                      position: state.leagueData
                                          .leaderBoard[index].position
                                          .toString(),
                                      goal: state.leagueData.league.goal
                                          .toString(),
                                    );
                                  },
                                ),
                              )
                            ],
                          )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
