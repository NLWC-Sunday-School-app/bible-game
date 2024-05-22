import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_bible_game/features/multi_player/widget/player_waiting_card.dart';
import 'package:the_bible_game/shared/widgets/blue_button.dart';
import 'package:the_bible_game/shared/widgets/game_summary_modal.dart';
import '../../../../shared/constants/image_routes.dart';

void showHostWaitingModal(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return PlayersWaitingModal(
          isWaitingForHost: false,
        );
      });
}

void showPlayersWaitingForHostModal(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return PlayersWaitingModal(
          isWaitingForHost: true,
        );
      });
}

class PlayersWaitingModal extends StatelessWidget {
  const PlayersWaitingModal({super.key, required this.isWaitingForHost});

  final bool isWaitingForHost;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      insetAnimationCurve: Curves.bounceInOut,
      insetAnimationDuration: const Duration(milliseconds: 500),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Container(
          color: Colors.black.withOpacity(0.8),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 250.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(isWaitingForHost
                            ? ProductImageRoutes.waitingForHostBg
                            : ProductImageRoutes.playersWaitingBg),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: isWaitingForHost
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 70.h,
                              ),
                              Image.asset(
                                ProductImageRoutes.multiplayerGembox,
                                width: 116.w,
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height: 70.h,
                              ),
                              Image.asset(
                                ProductImageRoutes.multiplayerGembox,
                                width: 70.w,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                'Code to join gameplay',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 13.sp),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Container(
                                width: 260.w,
                                height: 48.h,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xFFD8B98C)),
                                    borderRadius: BorderRadius.circular(4.r)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Spacer(),
                                    Text(
                                      '75KJA231',
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF014CA3),
                                      ),
                                    ),
                                    Spacer(),
                                    Icon(
                                      Icons.copy,
                                      color: Color(0xFF014CA3),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                  ),
                  Positioned(
                    right: 35.w,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        IconImageRoutes.redCircleClose,
                        width: 60.w,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: screenHeight - (250.h + 48.h + 85.h),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: 20,
                  itemBuilder: (BuildContext context, int index) {
                    return PlayerWaitingCard(
                      position: 1,
                      userName: 'Toblinkz',
                      countryName: 'NGA',
                      countryLogo:
                          'https://res.cloudinary.com/dd3hfa9ug/image/upload/v1714750941/Nigeria_NG_q4jizd.png',
                      userLevel: 'Babe',
                      userBadge: ProductImageRoutes.defaultBadge,
                      noOfCoins: '100',
                      userAvatar: 'https://api.multiavatar.com/Binx Bond.png',
                      isWaitingForHost: isWaitingForHost,
                    );
                  },
                ),
              ),
              !isWaitingForHost
                  ? BlueButton(
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return GameSummaryModal(
                                pointsEarned: '230',
                                bonusPoint: '10',
                                noOfCorrectionQuestions: '10',
                                totalQuestions: '20',
                                averageTimePerQuestion: '5',
                              );
                            });
                      },
                      buttonText: 'Start Game',
                      buttonIsLoading: false,
                      width: 280.w,
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
