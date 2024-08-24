part of 'global_challenge_bloc.dart';

sealed class GlobalChallengeEvent extends Equatable {
  const GlobalChallengeEvent();

  @override
  List<Object?> get props => [];
}

class FetchGlobalChallengeGames extends GlobalChallengeEvent {}

class UpdateGlobalChallengeGame extends GlobalChallengeEvent {
  final int id;
  final String title;
  final String description;
  final String image;
  final String campaignTag;
  final bool isActive;
  final bool isComingSoon;
  final String? startDate;
  final String? endDate;

  UpdateGlobalChallengeGame(
    this.id,
    this.title,
    this.description,
    this.image,
    this.campaignTag,
    this.isActive,
    this.isComingSoon,
    this.startDate,
    this.endDate,
  );

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        image,
        campaignTag,
        isActive,
        isComingSoon,
        startDate,
        endDate
      ];
}

class FetchGlobalChallengeQuestions extends GlobalChallengeEvent {
  final String campaignType;
  FetchGlobalChallengeQuestions(this.campaignType);

  @override
  List<Object?> get props => [campaignType];
}

class OptionSelected extends GlobalChallengeEvent {
  final int selectedOptionIndex;
  final GameQuestion gameQuestion;
  final int remainingTime;

  const OptionSelected( {required this.selectedOptionIndex, required this.gameQuestion, required this.remainingTime,});

  @override
  List<Object> get props => [selectedOptionIndex, gameQuestion, remainingTime];
}

class SubmitGlobalChallengeScore extends GlobalChallengeEvent {}

class MoveToNextPage extends GlobalChallengeEvent {}

class ClearGlobalChallengeGameData extends GlobalChallengeEvent {}

class FetchGlobalChallengeLeaderboard extends GlobalChallengeEvent{
  final String gameType;
  FetchGlobalChallengeLeaderboard(this.gameType);
  @override
  List<Object> get props => [gameType];
}
