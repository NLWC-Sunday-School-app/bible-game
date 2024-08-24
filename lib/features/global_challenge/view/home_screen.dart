import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_bible_game/features/global_challenge/bloc/global_challenge_bloc.dart';
import 'package:the_bible_game/features/global_challenge/widget/global_challenge_card.dart';

class GlobalChallengeHomeScreen extends StatefulWidget {
  const GlobalChallengeHomeScreen({super.key});

  @override
  State<GlobalChallengeHomeScreen> createState() =>
      _GlobalChallengeHomeScreenState();
}

class _GlobalChallengeHomeScreenState extends State<GlobalChallengeHomeScreen> {
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
            padding: EdgeInsets.zero,
            itemCount: state.globalChallengeGames.length,
            itemBuilder: (BuildContext context, int index) {
              return GlobalChallengeCard(
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
