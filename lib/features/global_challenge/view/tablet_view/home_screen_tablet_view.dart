import 'package:bible_game/features/global_challenge/widget/tablet_view_widget/global_challenge_card_tablet_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_game/features/global_challenge/bloc/global_challenge_bloc.dart';
import 'package:bible_game/features/global_challenge/widget/global_challenge_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlobalChallengeHomeScreenTabletView extends StatefulWidget {
  const GlobalChallengeHomeScreenTabletView({super.key});

  @override
  State<GlobalChallengeHomeScreenTabletView> createState() =>
      _GlobalChallengeHomeScreenTabletViewState();
}

class _GlobalChallengeHomeScreenTabletViewState extends State<GlobalChallengeHomeScreenTabletView> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<GlobalChallengeBloc>(context).add(
        FetchGlobalChallengeGames());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalChallengeBloc, GlobalChallengeState>(
      builder: (context, state) {
        return  state.isFetchingGames ? Center(child: CircularProgressIndicator(color: Colors.white,)) : Container(
          child:  ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 90.w),
            itemCount: state.globalChallengeGames.length,
            itemBuilder: (BuildContext context, int index) {
              return GlobalChallengeCardTabletView(
                id: state.globalChallengeGames[index].id,
                imageUrl: state.globalChallengeGames[index].imageUrl,
                title: state.globalChallengeGames[index].title,
                text: state.globalChallengeGames[index].description,
                gameIsLive: state.globalChallengeGames[index].gameIsActive,
                campaignTag: state.globalChallengeGames[index].campaignTag,
                isComingSoon: state.globalChallengeGames[index].isComingSoon ?? false,
                startDate: state.globalChallengeGames[index].startDate,
                endDate: state.globalChallengeGames[index].endDate,

              );
            },
          ),
        );
      },
    );
  }
}
