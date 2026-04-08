part of 'story_mode_bloc.dart';

sealed class StoryModeEvent extends Equatable {
  const StoryModeEvent();

  @override
  List<Object?> get props => [];
}

class LoadStoryArcs extends StoryModeEvent {}

class SelectStory extends StoryModeEvent {
  final String arcId;
  const SelectStory({required this.arcId});
  @override
  List<Object?> get props => [arcId];
}

class SelectChapter extends StoryModeEvent {
  final String chapterId;
  const SelectChapter({required this.chapterId});
  @override
  List<Object?> get props => [chapterId];
}

class AnswerStoryQuestion extends StoryModeEvent {
  final int selectedOptionIndex;
  final int remainingTime;
  const AnswerStoryQuestion({
    required this.selectedOptionIndex,
    this.remainingTime = 0,
  });
  @override
  List<Object?> get props => [selectedOptionIndex, remainingTime];
}

class MoveToNextStoryQuestion extends StoryModeEvent {}

class CompleteChapter extends StoryModeEvent {}

class ResetStoryGame extends StoryModeEvent {}

class AdvanceNarrative extends StoryModeEvent {}

class UseFiftyFifty extends StoryModeEvent {}

class TimerExpired extends StoryModeEvent {}
