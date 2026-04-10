part of 'pilgrim_progress_bloc.dart';

class PilgrimProgressEvent extends Equatable {
  const PilgrimProgressEvent();

  @override
  List<Object> get props => [];
}

class OptionSelected extends PilgrimProgressEvent {
  final int selectedOptionIndex;
  final GameQuestion gameQuestion;
  final int remainingTime;

  const OptionSelected( {required this.selectedOptionIndex, required this.gameQuestion, required this.remainingTime,});

  @override
  List<Object> get props => [selectedOptionIndex, gameQuestion];
}

class FetchPilgrimProgressLevelData extends PilgrimProgressEvent{}

class SetPilgrimProgressData extends PilgrimProgressEvent {}

class FetchPilgrimProgressQuestions extends PilgrimProgressEvent {
  final String selectedLevel;

  FetchPilgrimProgressQuestions(this.selectedLevel);
  @override
  List<Object> get props => [selectedLevel];
}

class SubmitPilgrimProgressScore extends PilgrimProgressEvent {}

class MoveToNextPage extends PilgrimProgressEvent {}

class CalculateGameScore extends PilgrimProgressEvent{}

class UpdateUserRank extends PilgrimProgressEvent{
  final String rank;

  UpdateUserRank(this.rank);
  @override
  List<Object> get props => [rank];
}

class ClearPilgrimProgressData extends PilgrimProgressEvent {}