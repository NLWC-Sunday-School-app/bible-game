part of 'who_is_who_bloc.dart';

sealed class WhoIsWhoEvent extends Equatable {
  const WhoIsWhoEvent();

  @override
  List<Object> get props => [];
}

class FetchGameLevels extends WhoIsWhoEvent {}

class FetchGameQuestions extends WhoIsWhoEvent {}

class OptionSelected extends WhoIsWhoEvent {
   final int selectedOptionIndex;
   final GameQuestion gameQuestion;


   const OptionSelected({required this.selectedOptionIndex, required this.gameQuestion});
   @override
   List<Object> get props => [selectedOptionIndex, gameQuestion];
}

class MoveToNextPage extends WhoIsWhoEvent {}

class SetGameData extends WhoIsWhoEvent {
   final int gameDuration;
   final int selectedGameLevel;

   SetGameData({required this.gameDuration, required this.selectedGameLevel});

   @override
   List<Object> get props => [gameDuration, selectedGameLevel];
}

class SetUserCompletedLeveLState extends WhoIsWhoEvent{
   final bool hasCompletedSelectedLevel;

   SetUserCompletedLeveLState(this.hasCompletedSelectedLevel);
   @override
   List<Object> get props => [hasCompletedSelectedLevel];
}

class PurchaseExtraTime extends WhoIsWhoEvent{
   final int userID;
   final int gameTimePurchasePrice;
   PurchaseExtraTime(this.userID, this.gameTimePurchasePrice);

   @override
   List<Object> get props => [userID, gameTimePurchasePrice];
}

class SubmitWhoIsWhoScore extends WhoIsWhoEvent {}

class SubmitSpecialLevelScore extends WhoIsWhoEvent {
   final int reward;

   SubmitSpecialLevelScore(this.reward);
   @override
   List<Object> get props => [reward];
}

class ClearWhoIsWhoGameData extends WhoIsWhoEvent{}

