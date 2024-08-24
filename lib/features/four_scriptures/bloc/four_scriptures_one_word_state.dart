part of 'four_scriptures_one_word_bloc.dart';

class FourScripturesOneWordState extends Equatable {
  final List<FourScripturesOneWordQuestion>? fourScripturesOneWordQuestions;
  final bool? isLoadingGameQuestions;
  final bool? gameQuestionsLoaded;
  final int? gameLevel;
  final int? totalNoOfQuestions;
  final int? coinsGained;
  final String? correctAnswer;
  final bool? isCorrectAnswer;
  final bool? isFetchingBibleVerse;
  final int bookId;
  final String bibleText;
  final String textKey;
  final int gameHintPurchasePrice;
  final int noOfHintsUsed;

  const FourScripturesOneWordState(
      {this.fourScripturesOneWordQuestions = const [],
      this.isLoadingGameQuestions = false,
      this.gameQuestionsLoaded = false,
      this.gameLevel = 0,
      this.totalNoOfQuestions = 0,
      this.coinsGained = 0,
      this.correctAnswer,
      this.isCorrectAnswer,
      this.isFetchingBibleVerse = false,
      this.bookId = 0,
      this.bibleText = '',
      this.textKey = '',
      this.gameHintPurchasePrice = 0,
      this.noOfHintsUsed = 0});

  FourScripturesOneWordState copyWith({
    List<FourScripturesOneWordQuestion>? fourScripturesOneWordQuestions,
    bool? isLoadingGameQuestions,
    bool? gameQuestionsLoaded,
    int? gameLevel,
    int? totalNoOfQuestions,
    int? coinsGained,
    String? correctAnswer,
    bool? isCorrectAnswer,
    bool? isFetchingBibleVerse,
    int? bookId,
    String? bibleText,
    String? textKey,
    int? gameHintPurchasePrice,
    int? noOfHintsUsed,
  }) {
    return FourScripturesOneWordState(
        fourScripturesOneWordQuestions: fourScripturesOneWordQuestions ??
            this.fourScripturesOneWordQuestions,
        isLoadingGameQuestions:
            isLoadingGameQuestions ?? this.isLoadingGameQuestions,
        gameQuestionsLoaded: gameQuestionsLoaded ?? this.gameQuestionsLoaded,
        gameLevel: gameLevel ?? this.gameLevel,
        totalNoOfQuestions: totalNoOfQuestions ?? this.totalNoOfQuestions,
        coinsGained: coinsGained ?? this.coinsGained,
        correctAnswer: correctAnswer ?? this.correctAnswer,
        isCorrectAnswer: isCorrectAnswer ?? this.isCorrectAnswer,
        isFetchingBibleVerse: isFetchingBibleVerse ?? this.isFetchingBibleVerse,
        bookId: bookId ?? this.bookId,
        bibleText: bibleText ?? this.bibleText,
        textKey: textKey ?? this.textKey,
        gameHintPurchasePrice:
        gameHintPurchasePrice ?? this.gameHintPurchasePrice,
        noOfHintsUsed: noOfHintsUsed ?? this.noOfHintsUsed);
  }

  @override
  List<Object?> get props => [
        fourScripturesOneWordQuestions,
        isLoadingGameQuestions,
        gameQuestionsLoaded,
        gameLevel,
        totalNoOfQuestions,
        coinsGained,
        correctAnswer,
        isCorrectAnswer,
        isFetchingBibleVerse,
        bookId,
        bibleText,
        textKey,
        gameHintPurchasePrice,
        noOfHintsUsed
      ];
}
