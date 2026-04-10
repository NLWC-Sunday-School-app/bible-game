part of 'four_scriptures_one_word_bloc.dart';

sealed class FourScripturesOneWordEvent extends Equatable {
  const FourScripturesOneWordEvent();

  @override
  List<Object> get props => [];
}

class FetchQuestions extends FourScripturesOneWordEvent{}

class FetchTotalNoOfQuestions extends FourScripturesOneWordEvent {}

class ClearFourScripturesOneWordData extends FourScripturesOneWordEvent {}

class FetchBibleVerse extends FourScripturesOneWordEvent {
  final String bibleText;

  FetchBibleVerse(this.bibleText);
  @override
  List<Object> get props => [bibleText];
}

class SendGameData extends FourScripturesOneWordEvent{}

class UpdateGameLevel extends FourScripturesOneWordEvent{}

class PurchaseHint extends FourScripturesOneWordEvent{
  final int purchasePrice;

  PurchaseHint(this.purchasePrice);
  @override
  List<Object> get props => [purchasePrice];
}

class SetGameData extends FourScripturesOneWordEvent {
  final gameHintPurchasePrice;
  final noOfHintsUsed;

  SetGameData(this.gameHintPurchasePrice, this.noOfHintsUsed);
  @override
  List<Object> get props => [gameHintPurchasePrice, noOfHintsUsed];
}

