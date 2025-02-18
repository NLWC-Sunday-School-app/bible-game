import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:bible_game/features/global_challenge/bloc/global_challenge_bloc.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/utils/avatar_credentials.dart';

import '../leaderboard_card.dart';

void showGlobalChallengeLeaderboardModal(BuildContext context, String gameType) {
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (BuildContext context) {
        return LeaderboardModal(gameType: gameType,);
      });
}

class LeaderboardModal extends StatefulWidget {
  final String gameType;
  const LeaderboardModal({
    Key? key, required this.gameType,
  }) : super(key: key);

  @override
  State<LeaderboardModal> createState() => _GamesBottomSheetModalState();
}

class _GamesBottomSheetModalState extends State<LeaderboardModal> {
  @override
  void initState() {
    super.initState();
    print(widget.gameType);
    BlocProvider.of<GlobalChallengeBloc>(context)
        .add(FetchGlobalChallengeLeaderboard(widget.gameType));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalChallengeBloc, GlobalChallengeState>(
      builder: (context, state) {
        return SizedBox(
          height: MediaQuery.of(context).size.height / 1.4,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 30.h,
                ),
                SvgPicture.asset(
                  IconImageRoutes.bottomHandle,
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  'Challenge Leaderboard',
                  style: TextStyle(
                      fontSize: 20.sp, fontWeight: FontWeight.w700, color: const Color(0xFF224C86)),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                  decoration: BoxDecoration(
                      color: const Color(0xFFB7FFBE),
                      borderRadius: BorderRadius.circular(24.r)),
                  child: Text(
                    'Live challenge is ongoing',
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  'Check out those taking the lead; Not joined? \nJoin the challenge to be a part of them!',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 20.h,
                ),
                SizedBox(
                  height: 350.h,
                  child: !state.isFetchingGlobalChallengeLeaderboard
                      ? state.globalChallengeLeaderboard.isNotEmpty
                          ? ListView.builder(
                              itemBuilder: (context, index) {
                                return LeaderBoardCard(
                                  playerPosition: state
                                      .globalChallengeLeaderboard[index]
                                      .playerPosition,
                                  playerName: state
                                      .globalChallengeLeaderboard[index]
                                      .playerName,
                                  playerPoint: state
                                      .globalChallengeLeaderboard[index]
                                      .playerScore,
                                  playerId: state
                                      .globalChallengeLeaderboard[index]
                                      .playerId,
                                  avatarUrl:
                                      '${state.globalChallengeLeaderboard[index].playerId}',
                                );
                              },
                              itemCount:
                                  state.globalChallengeLeaderboard.length,
                            )
                          : SizedBox(
                              // color: Colors.red,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    IconImageRoutes.emptyLeaderboardIcon,
                                    width: 50,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'No rankings to display yet',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFFC3BBBB)),
                                  )
                                ],
                              ),
                            )
                      : Center(
                          child: SizedBox(
                            child: Center(
                                child: CircularProgressIndicator(
                              color: Colors.blueAccent,
                            )),
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
