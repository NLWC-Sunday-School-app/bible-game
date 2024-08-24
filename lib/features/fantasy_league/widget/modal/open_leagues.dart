import 'package:another_flushbar/flushbar.dart';
import 'package:bible_game_api/utils/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:the_bible_game/features/fantasy_league/bloc/fantasy_league_bloc.dart';
import 'package:the_bible_game/features/fantasy_league/widget/league_player_card.dart';
import 'package:the_bible_game/shared/widgets/blue_button.dart';

import '../../../../shared/constants/colors.dart';
import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../../shared/utils/avatar_credentials.dart';
import 'leave_league_modal.dart';

void showOpenLeagueModal(BuildContext context, int leagueId) {
  showDialog(
      context: context,
      barrierColor: const Color.fromRGBO(40, 40, 40, 0.95),
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          backgroundColor: Colors.transparent,
          insetAnimationCurve: Curves.easeIn,
          insetAnimationDuration: const Duration(milliseconds: 500),
          child: OpenLeagueModal(
            leagueId: leagueId,
          ),
        );
      });
}

class OpenLeagueModal extends StatefulWidget {
  const OpenLeagueModal({super.key, required this.leagueId});

  final int leagueId;

  @override
  State<OpenLeagueModal> createState() => _OpenLeagueModalState();
}

class _OpenLeagueModalState extends State<OpenLeagueModal> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FantasyLeagueBloc>(context)
        .add(ViewLeagueData(widget.leagueId));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 630.h,
        width: 500.w,
        child: BlocConsumer<FantasyLeagueBloc, FantasyLeagueState>(
          listener: (context, state) {
           if( state.failedToJoin){
             ApiException.showSnackBar(context);
           }
           if(state.hasJoinedLeague){
             Navigator.pop(context);
             Flushbar(
               message: 'Joined successfully',
               flushbarPosition: FlushbarPosition.TOP,
               flushbarStyle: FlushbarStyle.GROUNDED,
               backgroundColor: Colors.green,
               duration: Duration(seconds: 3),
             ).show(context);
           }
           if(state.hasLeftLeague){
             Navigator.pop(context);
             Flushbar(
               message: 'Left successfully',
               flushbarPosition: FlushbarPosition.TOP,
               flushbarStyle: FlushbarStyle.GROUNDED,
               backgroundColor: Colors.green,
               duration: Duration(seconds: 3),
             ).show(context);
           }

           if(state.failedToLeave){
             ApiException.showSnackBar(context);
           }
          },
          builder: (context, state) {
            return Container(
              child: state.isFetchingLeagueData
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          height: 200.h,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Image.asset(
                                      IconImageRoutes.closeModal,
                                      width: 35.w,
                                    ),
                                  ),
                                  Spacer(),
                                  FadeInImage.assetNetwork(
                                    placeholder:
                                        ProductImageRoutes.defaultAvatar,
                                    image: state.leagueData.league.icon.toString(),
                                    width: 65.w,
                                    height: 65.h,
                                  ),
                                  SizedBox(
                                    width: 50.w,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (state.leagueData.isAuthUserMember) {
                                        showLeaveLeagueModal(context, state.leagueData.league.id, state.leagueData.league.icon);
                                      } else {
                                        context.read<FantasyLeagueBloc>().add(
                                            JoinLeague(
                                                state.leagueData.league.id));
                                      }
                                    },
                                    child: Container(
                                      width: state.leagueData.isAuthUserMember
                                          ? 70.w
                                          : 85.w,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5.w, vertical: 10.h),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(state
                                                  .leagueData.isAuthUserMember
                                              ? ProductImageRoutes.leaveBtnBg
                                              : ProductImageRoutes.joinBtnBg),
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
                                                !state.leagueData
                                                        .isAuthUserMember
                                                    ? 'Join league'
                                                    : 'Leave',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 14.sp,
                                                ),
                                              ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              StrokeText(
                                text: state.leagueData.league.name,
                                textStyle: TextStyle(
                                  color: const Color(0xFF014CA3),
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                                strokeColor: Colors.black.withOpacity(0.25),
                                strokeWidth: 1,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: Color(0xFFD7EEED),
                                  border: Border.all(color: Color(0xFFB9BDBD)),
                                  borderRadius: BorderRadius.circular(5.r),
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
                                                color: Color(0xFF4A5240),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 13.sp,
                                              ),
                                              children: [
                                                TextSpan(
                                                    text:
                                                        ' ${state.leagueData.metrics.membersCount}/${context.read<SettingsBloc>().state.gamePlaySettings['league_members_limit']}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: Color(0xFF01200F),
                                                      fontSize: 13.sp,
                                                    ))
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
                                                color: Color(0xFF4A5240),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 13.sp,
                                              ),
                                              children: [
                                                TextSpan(
                                                    text:
                                                        '${state.leagueData.metrics.coinTrack}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color:
                                                            Color(0xFF01200F),
                                                        fontSize: 13.sp))
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
                                                color: Color(0xFF4A5240),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14.sp,
                                              ),
                                              children: [
                                                TextSpan(
                                                    text: state.leagueData
                                                        .metrics.weeksLeft,
                                                    style: TextStyle(
                                                        fontFamily: 'Mikado',
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color:
                                                            Color(0xFF01200F),
                                                        fontSize: 14.sp))
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
                                                color: Color(0xFF4A5240),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14.sp,
                                              ),
                                              children: [
                                                TextSpan(
                                                    text: state.leagueData
                                                            .league.isOpen
                                                        ? ' • Open'
                                                        : ' • Closed',
                                                    style: TextStyle(
                                                        fontFamily: 'Mikado',
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: state.leagueData
                                                                .league.isOpen
                                                            ? Color(0xFF1A7E1C)
                                                            : Colors.red,
                                                        fontSize: 14.sp))
                                              ]),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height -
                              (200.h + 100.h + 123.h),
                          child: ListView.builder(
                            itemCount: state.leagueData.leaderBoard.length,
                            itemBuilder: (BuildContext context, int index) {
                              return LeaguePlayerCard(
                                username: state
                                    .leagueData.leaderBoard[index].username,
                                userId:
                                    state.leagueData.leaderBoard[index].userId,
                                points:
                                    state.leagueData.leaderBoard[index].points,
                                position: state
                                    .leagueData.leaderBoard[index].position
                                    .toString(),
                                goal: state.leagueData.league.goal
                                    .toString(),
                              );
                            },
                          ),
                        )
                      ],
                    ),
            );
          },
        ));
  }
}
