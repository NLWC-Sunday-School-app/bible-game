part of 'lightning_mode_bloc.dart';

class LightningModeEvent extends Equatable{
  const LightningModeEvent();

  @override
  List<Object?> get props => [];
}

class StartGame extends LightningModeEvent{}


class OptionSelected extends LightningModeEvent {
  final int selectedOptionIndex;
  final Datum gameQuestion;

  const OptionSelected( {required this.selectedOptionIndex, required this.gameQuestion});

  @override
  List<Object> get props => [selectedOptionIndex, gameQuestion];
}

class SubmitGlobalChallengeScore extends LightningModeEvent  {}

class MoveToNextPage extends LightningModeEvent  {}
