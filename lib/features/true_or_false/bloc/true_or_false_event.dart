part of 'true_or_false_bloc.dart';

sealed class TrueOrFalseEvent extends Equatable {
  const TrueOrFalseEvent();

  @override
  List<Object?> get props => [];
}

class LoadTrueOrFalseData extends TrueOrFalseEvent {}

class StartTrueOrFalseGame extends TrueOrFalseEvent {}

class AnswerTrueOrFalse extends TrueOrFalseEvent {
  final bool selectedAnswer;
  final int remainingTime;
  const AnswerTrueOrFalse({
    required this.selectedAnswer,
    this.remainingTime = 0,
  });
  @override
  List<Object?> get props => [selectedAnswer, remainingTime];
}

class TrueOrFalseTimerExpired extends TrueOrFalseEvent {}

class NextTrueOrFalseQuestion extends TrueOrFalseEvent {}

class CompleteTrueOrFalseGame extends TrueOrFalseEvent {}

class ResetTrueOrFalseGame extends TrueOrFalseEvent {}
