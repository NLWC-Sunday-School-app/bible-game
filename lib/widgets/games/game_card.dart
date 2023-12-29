import 'package:bible_game/controllers/auth_controller.dart';
import 'package:bible_game/controllers/global_game_controller.dart';
import 'package:bible_game/widgets/games/game_leaderboard_card.dart';
import 'package:bible_game/widgets/games/games_bottom_sheet.dart';
import 'package:bible_game/widgets/modals/auth_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class GameCard extends StatefulWidget {
  const GameCard(
      {Key? key,
      required this.imageUrl,
      required this.title,
      required this.text,
      required this.gameIsLive,
      required this.campaignTag})
      : super(key: key);
  final String imageUrl;
  final String title;
  final String text;
  final bool gameIsLive;
  final String campaignTag;

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  late bool playedGame;

  @override
  void initState() {
    super.initState();
    setState(() => {
          playedGame =
              GetStorage().read('PLAYED_${widget.campaignTag}') ?? false
        });
  }

  @override
  Widget build(BuildContext context) {
    GlobalGameController globalGameController = Get.put(GlobalGameController());
    AuthController authController = Get.put(AuthController());
    return Container(
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
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                Spacer(),
                Row(
                  children: [
                    widget.gameIsLive
                        ? GestureDetector(
                            onTap: () {
                              if (authController.isLoggedIn.isTrue &&
                                  playedGame == false) {
                                globalGameController
                                    .prepareQuestions(widget.campaignTag);
                              } else if (playedGame == true) {
                              } else {
                                Get.dialog(const AuthModal(
                                  title: 'LOG IN TO JOIN \nTHE CHALLENGE',
                                  text:
                                      'Log in to your profile to join \nthis live challenge.',
                                ));
                              }
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
                        : const GamesLockedButton(
                            buttonText: 'Ended',
                          ),
                    SizedBox(
                      width: 10.w,
                    ),
                    widget.gameIsLive
                        ? GestureDetector(
                            onTap: () {
                              if (authController.isLoggedIn.isTrue) {
                                Get.bottomSheet(
                                  GamesBottomSheetModal(
                                    campaignType: widget.campaignTag,
                                  ),
                                  isScrollControlled: true,
                                );
                              } else {
                                Get.dialog(const AuthModal(
                                  title: 'LOG IN TO JOIN \nTHE CHALLENGE',
                                  text:
                                      'Log in to your profile to join \nthis live challenge.',
                                ));
                              }
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
                                'assets/images/icons/trophy.svg',
                                width: 20.w,
                              ),
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
                SizedBox(height: 5.h,)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class GamesLockedButton extends StatelessWidget {
  const GamesLockedButton({
    Key? key,
    required this.buttonText,
  }) : super(key: key);
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical:6.h, horizontal: 30.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color: const Color(0xFFBCD8FF)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            color: const Color(0xFF5A82B8),
            size: 16.w,
          ),
          SizedBox(
            width: 10.w,
          ),
          Text(
            buttonText,
            style: TextStyle(
              fontSize: 12.sp,
              color: const Color(0xFF5A82B8),
              fontWeight: FontWeight.w600,
              fontFamily: 'Mikado'
            ),
          ),
        ],
      ),
    );
  }
}
