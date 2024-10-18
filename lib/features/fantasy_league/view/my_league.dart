import 'package:another_flushbar/flushbar.dart';
import 'package:bible_game/features/fantasy_league/widget/modal/edit_league_modal.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/widgets/custom_toast.dart';
import 'package:bible_game_api/utils/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/features/fantasy_league/widget/modal/fantasy_bible_league_guide.dart';
import 'package:bible_game/features/fantasy_league/widget/modal/leave_league_modal.dart';

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

  void _copyText(BuildContext context, leagueGoal, leagueName, leagueDuration, leagueCode) {
    showCustomToast(context, 'Copied');
    Clipboard.setData(ClipboardData(text: 'Can you get $leagueGoal coins before me in $leagueDuration ${int.parse(leagueDuration) > 1 ? 'weeks' : 'week'}? Join my League ($leagueName) on the Bible game app using this code $leagueCode \n\nhttps://linktr.ee/biblegame_'));

  }

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    double screenHeight = MediaQuery.of(context).size.height;
    final userId = BlocProvider.of<AuthenticationBloc>(context).state.user.id;
    final double usableHeight = screenHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          backgroundColor: AppColors.primaryColorShade, // Status bar color
        ),
        backgroundColor: Color(0xFF014AA0),
        body: BlocConsumer<FantasyLeagueBloc, FantasyLeagueState>(
          listener: (context, state) {
            if (state.hasLeftLeague) {
              Navigator.pop(context);
              if(userId == state.leagueData.league.adminId){
                showCustomToast(context, 'Ended successfully');
              }else{
                showCustomToast(context, 'Left successfully');
              }


            }

            if (state.failedToLeave) {
              ApiException.showSnackBar(context);
            }
          },
          builder: (context, state) {
            print('info ${state.leagueData.metrics}');
            return SafeArea(
              child: SingleChildScrollView(
                child: Container(
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
                          height: 80.h,
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
                                      strokeColor:
                                          AppColors.titleDropShadowColor,
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    child: Container(
                                      height: 222.h,
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 10.h),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(4.r),
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
                                              state.leagueData.league.status ==
                                                      'ENDED'
                                                  ? SizedBox()
                                                  : GestureDetector(
                                                      onTap: () {
                                                        soundManager
                                                            .playClickSound();
                                                      if( userId == state.leagueData.league.adminId ){

                                                        context.read<FantasyLeagueBloc>().add(EndFantasyLeague(state.leagueData.league.name, state.leagueData.league.isOpen,state.leagueData.league.id ));


                                                      }else{
                                                        context.read<FantasyLeagueBloc>().add(LeaveLeague(state.leagueData.league.id));
                                                      }
                                                      },
                                                      child: Container(
                                                        width: 70.w,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 5.w,
                                                                vertical: 8.h),
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: AssetImage(
                                                              ProductImageRoutes
                                                                  .leaveBtnBg,
                                                            ),
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: state
                                                                  .isLeavingLeague
                                                              ? SizedBox(
                                                                  height: 20.h,
                                                                  width: 20.w,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    color: Colors
                                                                        .white,
                                                                    strokeWidth:
                                                                        2,
                                                                  ))
                                                              : Text(
                                                                 userId == state.leagueData.league.adminId ? 'End' : 'Leave',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900,
                                                                    fontSize:
                                                                        14.sp,
                                                                  ),
                                                                ),
                                                        ),
                                                      ),
                                                    ),
                                              Spacer(),
                                              FadeInImage.assetNetwork(
                                                placeholder: ProductImageRoutes
                                                    .defaultAvatar,
                                                image: state
                                                    .leagueData.league.icon,
                                                width: 65.w,
                                                height: 65.h,
                                              ),
                                              Spacer(),
                                              state.leagueData.league.status ==
                                                      'ENDED'
                                                  ? SizedBox()
                                                  :  userId == state.leagueData.league.adminId ? GestureDetector(
                                                      onTap: () {
                                                        soundManager
                                                            .playClickSound();
                                                        showEditLeagueModal(context, state.leagueData);
                                                      },
                                                      child: Container(
                                                        width: 38.w,
                                                        height: 32.h,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: AssetImage(
                                                              ProductImageRoutes
                                                                  .inviteBtnBg,
                                                            ),
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                        child: Center(
                                                          child: Icon(
                                                              Icons.settings,
                                                              size: 20.w,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ),
                                                    ) : Spacer()
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
                                          state.leagueData.league.status ==
                                                  'ENDED'
                                              ? Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.w),
                                                  child: Container(
                                                    height: 58.h,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 25.w,
                                                            vertical: 19.5.h),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFD7EEED),
                                                      border: Border.all(
                                                          color: Color(
                                                              0xFFB9BDBD)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.r),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.3),
                                                          spreadRadius: 1,
                                                          blurRadius: 1,
                                                          offset: Offset(0, 1),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        RichText(
                                                          text: TextSpan(
                                                              text: 'Members:',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Mikado',
                                                                color: Color(
                                                                    0xFF4A5240),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
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
                                                        RichText(
                                                          text: TextSpan(
                                                              text:
                                                                  'Weeks left: ',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Mikado',
                                                                color: Color(
                                                                    0xFF4A5240),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 14.sp,
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                    text:
                                                                        'ENDED',
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
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.w),
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 10.w,
                                                      vertical: 10.h,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Color(0xFFD7EEED),
                                                      border: Border.all(
                                                          color: Color(
                                                              0xFFB9BDBD)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.r),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.3),
                                                          spreadRadius: 1,
                                                          blurRadius: 4,
                                                          offset: Offset(0, 2),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            RichText(
                                                              text: TextSpan(
                                                                  text:
                                                                      'Members:',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Mikado',
                                                                    color: Color(
                                                                        0xFF4A5240),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        14.sp,
                                                                  ),
                                                                  children: [
                                                                    TextSpan(
                                                                        text:
                                                                            ' ${state.leagueData.metrics.membersCount}/${context.read<SettingsBloc>().state.gamePlaySettings['league_members_limit']}',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w900,
                                                                            color: Color(0xFF01200F),
                                                                            fontSize: 14.sp))
                                                                  ]),
                                                            ),
                                                            SizedBox(
                                                              height: 10.h,
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {

                                                                soundManager
                                                                    .playClickSound();
                                                                _copyText(
                                                                    context,
                                                                    state.leagueData.metrics.coinTrack.split('/').last,
                                                                    state
                                                                        .leagueData
                                                                        .league
                                                                        .name,
                                                                  state.leagueData.metrics.weeksLeft.split('/').last,

                                                                  state.leagueData.league.code
                                                                );
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  RichText(
                                                                    text: TextSpan(
                                                                        text: 'League code:',
                                                                        style: TextStyle(
                                                                          fontFamily:
                                                                              'Mikado',
                                                                          color:
                                                                              Color(0xFF4A5240),
                                                                          fontWeight:
                                                                              FontWeight.w700,
                                                                          fontSize:
                                                                              14.sp,
                                                                        ),
                                                                        children: [
                                                                          TextSpan(
                                                                              text: ' ${state.leagueData.league.code}',
                                                                              style: TextStyle(fontFamily: 'Mikado', fontWeight: FontWeight.w900, color: Color(0xFF01200F), fontSize: 14.sp))
                                                                        ]),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 4.w,
                                                                  ),
                                                                  Image.asset(
                                                                    IconImageRoutes
                                                                        .blueCopyIcon,
                                                                    width: 16.w,
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            RichText(
                                                              text: TextSpan(
                                                                  text:
                                                                      'Weeks left: ',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Mikado',
                                                                    color: Color(
                                                                        0xFF4A5240),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        14.sp,
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
                                                                                FontWeight.w900,
                                                                            color: Color(0xFF01200F),
                                                                            fontSize: 14.sp))
                                                                  ]),
                                                            ),
                                                            SizedBox(
                                                              height: 10.h,
                                                            ),
                                                            RichText(
                                                              text: TextSpan(
                                                                  text: 'Type:',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Mikado',
                                                                    color: Color(
                                                                        0xFF4A5240),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        14.sp,
                                                                  ),
                                                                  children: [
                                                                    TextSpan(
                                                                      text: state
                                                                              .leagueData
                                                                              .league
                                                                              .isOpen
                                                                          ? ' ● Open'
                                                                          : ' ● Closed',
                                                                      style: TextStyle(
                                                                          fontFamily: 'Mikado',
                                                                          fontWeight: FontWeight.w900,
                                                                          color: state.leagueData.league.status.toLowerCase() == 'active'
                                                                              ? state.leagueData.league.isOpen
                                                                                  ? Color(0xFF1A7E1C)
                                                                                  : Colors.red
                                                                              : Colors.red,
                                                                          fontSize: 14.sp),
                                                                    )
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
                                    height:
                                        usableHeight - (80.h + 230.h + 20.h),
                                    child: ListView.builder(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      itemCount:
                                          state.leagueData.leaderBoard.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return LeaguePlayerCard(
                                          username: state.leagueData
                                              .leaderBoard[index].username,
                                          userId: state.leagueData
                                              .leaderBoard[index].userId,
                                          points: state.leagueData
                                              .leaderBoard[index].points,
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
                ),
              ),
            );
          },
        ));
  }
}
