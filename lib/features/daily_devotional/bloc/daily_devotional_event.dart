part of 'daily_devotional_bloc.dart';

sealed class DailyDevotionalEvent extends Equatable {
  const DailyDevotionalEvent();

  @override
  List<Object?> get props => [];
}

class LoadDailyDevotional extends DailyDevotionalEvent {}

class AnswerDevotional extends DailyDevotionalEvent {
  final int selectedOptionIndex;

  const AnswerDevotional({required this.selectedOptionIndex});

  @override
  List<Object?> get props => [selectedOptionIndex];
}
