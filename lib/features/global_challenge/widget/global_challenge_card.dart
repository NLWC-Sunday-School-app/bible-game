import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_bible_game/features/global_challenge/bloc/global_challenge_bloc.dart';
import 'package:the_bible_game/shared/constants/app_routes.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';
import 'locked_button.dart';
import 'modal/leaderboard_modal.dart';

class GlobalChallengeCard extends StatefulWidget {
  const GlobalChallengeCard({
    super.key,
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.text,
    required this.gameIsLive,
    required this.campaignTag,
    this.isComingSoon = false,
    this.startDate = '0000-00-00 00:00:00',
    this.endDate = '0000-00-00 00:00:00',
  });

  final int id;
  final String imageUrl;
  final String title;
  final String text;
  final bool gameIsLive;
  final bool isComingSoon;
  final String campaignTag;
  final String? startDate;
  final String? endDate;

  @override
  State<GlobalChallengeCard> createState() => _GlobalChallengeCardState();
}

class _GlobalChallengeCardState extends State<GlobalChallengeCard> {
  bool playedGame = false;
  Timer? _timer;
  Timer? _endGameTimer;
  Duration _duration = Duration();

  @override
  void initState() {
    super.initState();
    if (widget.isComingSoon) {
      _startGoLiveCountdown();
    }else if(widget.gameIsLive){
      _startEndGameCountdown();
    }
    getPlayedGameStatus();

  }

  getPlayedGameStatus()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    playedGame = await prefs.getBool('PLAYED_${widget.campaignTag}') ?? false;
  }

  void _startGoLiveCountdown() {
    DateTime targetDate = DateTime.parse(widget.startDate!);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final difference = targetDate.difference(now);
      if (difference.isNegative) {
        timer.cancel();
        context.read<GlobalChallengeBloc>().add(UpdateGlobalChallengeGame(
              widget.id,
              widget.title,
              widget.text,
              widget.imageUrl,
              widget.campaignTag,
              true,
              false,
              widget.startDate,
              widget.endDate,
            ));
      } else {
        setState(() {
          _duration = difference;
        });
      }
    });
  }

  void _startEndGameCountdown() {
    DateTime targetDate = DateTime.parse(widget.endDate!);
    _endGameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final difference = targetDate.difference(now);
      if (difference.isNegative) {
        timer.cancel();
        context.read<GlobalChallengeBloc>().add(UpdateGlobalChallengeGame(
          widget.id,
          widget.title,
          widget.text,
          widget.imageUrl,
          widget.campaignTag,
          false,
          false,
          widget.startDate,
          widget.endDate,
        ));
      } else {
        // setState(() {
        //   _duration = difference;
        // });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _endGameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _duration.inDays;
    final hours = _duration.inHours.remainder(24);
    final minutes = _duration.inMinutes.remainder(60);
    final seconds = _duration.inSeconds.remainder(60);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        margin: EdgeInsets.only(bottom: 25.h),
        height: 160.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFDEC839),
              offset: Offset(-3, 15),
              blurRadius: 0,
              spreadRadius: -10,
            ),
            BoxShadow(
              color: Color(0xFFDEC839),
              offset: Offset(-3, -15),
              blurRadius: 0,
              spreadRadius: -10,
            )
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8.r),
                bottomLeft: Radius.circular(8.r),
              ),
              child: Image.network(
                widget.imageUrl,
                width: 120.w,
                height: 160.h,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Container(
              padding: EdgeInsets.only(top: 10.h, bottom: 10.h, right: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                        fontFamily: 'Mikado',
                        color: const Color(0xFF0971C8),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  SizedBox(
                    width: 200.w,
                    child: Text(
                      widget.text,
                      textAlign: TextAlign.left,
                      softWrap: true,
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: 'Mikado',
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      widget.gameIsLive
                          ? GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.questionLoadingScreen,  arguments:{ 'gameType': widget.campaignTag});
                              },
                              child: playedGame == false
                                  ? Container(
                                      padding: EdgeInsets.all(10.w),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(24.r),
                                          color: const Color(0xFF558CD7)),
                                      child: Text(
                                        'Join Challenge',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12.sp),
                                      ),
                                    )
                                  : const GamesLockedButton(
                                      buttonText: 'Game Played',
                                    ),
                            )
                          : widget.isComingSoon
                              ? GamesLockedButton(
                                  buttonText:
                                      '${days}D | ${hours}H:${minutes}M:${seconds}s',
                                )
                              : GamesLockedButton(
                                  buttonText: 'Ended',
                                ),
                      SizedBox(
                        width: 10.w,
                      ),
                      widget.gameIsLive
                          ? GestureDetector(
                              onTap: () {
                                showGlobalChallengeLeaderboardModal(context, widget.campaignTag);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 30.w,
                                width: 30.w,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.center,
                                      colors: [
                                        Color(0xFF598DE7),
                                        Color(0xFF1861DE)
                                      ],
                                    )),
                                child: SvgPicture.asset(
                                  IconImageRoutes.trophy,
                                  width: 20.w,
                                ),
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                  SizedBox(
                    height: 5.h,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
    ;
  }
}
