import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';
import 'locked_button.dart';

class GlobalChallengeCard extends StatefulWidget {
  const GlobalChallengeCard(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.text,
      required this.gameIsLive,
      required this.campaignTag,
      this.startDate,
      this.endDate});

  final String imageUrl;
  final String title;
  final String text;
  final bool gameIsLive;
  final String campaignTag;
  final String? startDate;
  final String? endDate;

  @override
  State<GlobalChallengeCard> createState() => _GlobalChallengeCardState();
}

class _GlobalChallengeCardState extends State<GlobalChallengeCard> {
  late bool playedGame;
  Duration _remainingTime =
      const Duration(days: 0, hours: 0, minutes: 0, seconds: 0);

  @override
  Widget build(BuildContext context) {
    String days = (_remainingTime.inDays).toString().padLeft(2, '0');
    String hours = (_remainingTime.inHours % 24).toString().padLeft(2, '0');
    String minutes = (_remainingTime.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (_remainingTime.inSeconds % 60).toString().padLeft(2, '0');

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
                              onTap: () {},
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
                          : GamesLockedButton(
                              buttonText:
                                  '${days}D | ${hours}H:${minutes}M:${seconds}s',
                            ),
                      SizedBox(
                        width: 10.w,
                      ),
                      widget.gameIsLive
                          ? GestureDetector(
                              onTap: () {},
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
