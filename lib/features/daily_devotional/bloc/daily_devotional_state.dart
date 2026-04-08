part of 'daily_devotional_bloc.dart';

class DailyDevotionalState extends Equatable {
  final String passage;
  final String passageText;
  final String reflection;
  final String question;
  final List<String> options;
  final String answer;
  final bool isLoaded;
  final bool hasAnswered;
  final bool? isCorrect;
  final int selectedOptionIndex;
  final bool hasCompletedToday;
  final int devotionalStreak;
  final int bestStreak;

  const DailyDevotionalState({
    this.passage = '',
    this.passageText = '',
    this.reflection = '',
    this.question = '',
    this.options = const [],
    this.answer = '',
    this.isLoaded = false,
    this.hasAnswered = false,
    this.isCorrect,
    this.selectedOptionIndex = -1,
    this.hasCompletedToday = false,
    this.devotionalStreak = 0,
    this.bestStreak = 0,
  });

  DailyDevotionalState copyWith({
    String? passage,
    String? passageText,
    String? reflection,
    String? question,
    List<String>? options,
    String? answer,
    bool? isLoaded,
    bool? hasAnswered,
    bool? isCorrect,
    int? selectedOptionIndex,
    bool? hasCompletedToday,
    int? devotionalStreak,
    int? bestStreak,
  }) {
    return DailyDevotionalState(
      passage: passage ?? this.passage,
      passageText: passageText ?? this.passageText,
      reflection: reflection ?? this.reflection,
      question: question ?? this.question,
      options: options ?? this.options,
      answer: answer ?? this.answer,
      isLoaded: isLoaded ?? this.isLoaded,
      hasAnswered: hasAnswered ?? this.hasAnswered,
      isCorrect: isCorrect ?? this.isCorrect,
      selectedOptionIndex: selectedOptionIndex ?? this.selectedOptionIndex,
      hasCompletedToday: hasCompletedToday ?? this.hasCompletedToday,
      devotionalStreak: devotionalStreak ?? this.devotionalStreak,
      bestStreak: bestStreak ?? this.bestStreak,
    );
  }

  @override
  List<Object?> get props => [
        passage,
        passageText,
        reflection,
        question,
        options,
        answer,
        isLoaded,
        hasAnswered,
        isCorrect,
        selectedOptionIndex,
        hasCompletedToday,
        devotionalStreak,
        bestStreak,
      ];
}
