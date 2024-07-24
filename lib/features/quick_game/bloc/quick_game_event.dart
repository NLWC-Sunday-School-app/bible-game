part of 'quick_game_bloc.dart';

sealed class QuickGameEvent extends Equatable {
  const QuickGameEvent();

  @override
  List<Object> get props => [];
}

class FetchQuickGameTopics extends QuickGameEvent {}

class FetchQuickGameQuestions extends QuickGameEvent {}

class SelectQuickGameTopic extends QuickGameEvent {
  final QuickGameTopic topic;

  SelectQuickGameTopic(this.topic);

  @override
  List<Object> get props => [topic];
}

class OptionSelected extends QuickGameEvent {
  final int selectedOptionIndex;
  final GameQuestion gameQuestion;
  final int remainingTime;

  const OptionSelected( {required this.selectedOptionIndex, required this.gameQuestion, required this.remainingTime,});

  @override
  List<Object> get props => [selectedOptionIndex, gameQuestion];
}

class MoveToNextPage extends QuickGameEvent {}

class ClearQuickGameData extends QuickGameEvent {}

class ShowMaximumTopicPrompt extends QuickGameEvent{}

class InitializeControllers extends QuickGameEvent {}
