part of 'story_mode_bloc.dart';

class StoryModeState extends Equatable {
  final List<Map<String, dynamic>> arcs;
  final bool isLoaded;
  final String selectedArcId;
  final String selectedChapterId;
  final int currentQuestionIndex;
  final int correctAnswers;
  final bool hasAnswered;
  final bool? isCorrect;
  final int selectedOptionIndex;
  final bool chapterCompleted;
  final bool showingNarrative;
  // Map of arcId -> Map of chapterId -> stars earned (0–3)
  final Map<String, Map<String, int>> chapterProgress;

  // Gameplay enhancements
  final int coinsGained;
  final int currentStreak;
  final int highestStreak;
  final bool fiftyFiftyUsed;
  final List<int> eliminatedOptions;
  final int starsEarned;
  final int currentNarrativeIndex;
  final bool narrativeComplete;
  final int totalTimeSpent;
  // Per-question answer tracking: true = correct, false = wrong/skipped
  final List<bool> answerResults;

  const StoryModeState({
    this.arcs = const [],
    this.isLoaded = false,
    this.selectedArcId = '',
    this.selectedChapterId = '',
    this.currentQuestionIndex = 0,
    this.correctAnswers = 0,
    this.hasAnswered = false,
    this.isCorrect,
    this.selectedOptionIndex = -1,
    this.chapterCompleted = false,
    this.showingNarrative = false,
    this.chapterProgress = const {},
    this.coinsGained = 0,
    this.currentStreak = 0,
    this.highestStreak = 0,
    this.fiftyFiftyUsed = false,
    this.eliminatedOptions = const [],
    this.starsEarned = 0,
    this.currentNarrativeIndex = 0,
    this.narrativeComplete = false,
    this.totalTimeSpent = 0,
    this.answerResults = const [],
  });

  /// Returns the stars earned for a chapter (0 = not completed).
  int starsForChapter(String arcId, String chapterId) {
    return chapterProgress[arcId]?[chapterId] ?? 0;
  }

  bool isChapterCompleted(String arcId, String chapterId) {
    return starsForChapter(arcId, chapterId) >= 1;
  }

  bool isChapterUnlocked(String arcId, List chapters, int chapterIndex) {
    if (chapterIndex == 0) return true;
    final prevChapterId = (chapters[chapterIndex - 1] as Map)['id'] as String;
    return isChapterCompleted(arcId, prevChapterId);
  }

  StoryModeState copyWith({
    List<Map<String, dynamic>>? arcs,
    bool? isLoaded,
    String? selectedArcId,
    String? selectedChapterId,
    int? currentQuestionIndex,
    int? correctAnswers,
    bool? hasAnswered,
    bool? isCorrect,
    int? selectedOptionIndex,
    bool? chapterCompleted,
    bool? showingNarrative,
    Map<String, Map<String, int>>? chapterProgress,
    int? coinsGained,
    int? currentStreak,
    int? highestStreak,
    bool? fiftyFiftyUsed,
    List<int>? eliminatedOptions,
    int? starsEarned,
    int? currentNarrativeIndex,
    bool? narrativeComplete,
    int? totalTimeSpent,
    List<bool>? answerResults,
  }) {
    return StoryModeState(
      arcs: arcs ?? this.arcs,
      isLoaded: isLoaded ?? this.isLoaded,
      selectedArcId: selectedArcId ?? this.selectedArcId,
      selectedChapterId: selectedChapterId ?? this.selectedChapterId,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      hasAnswered: hasAnswered ?? this.hasAnswered,
      isCorrect: isCorrect ?? this.isCorrect,
      selectedOptionIndex: selectedOptionIndex ?? this.selectedOptionIndex,
      chapterCompleted: chapterCompleted ?? this.chapterCompleted,
      showingNarrative: showingNarrative ?? this.showingNarrative,
      chapterProgress: chapterProgress ?? this.chapterProgress,
      coinsGained: coinsGained ?? this.coinsGained,
      currentStreak: currentStreak ?? this.currentStreak,
      highestStreak: highestStreak ?? this.highestStreak,
      fiftyFiftyUsed: fiftyFiftyUsed ?? this.fiftyFiftyUsed,
      eliminatedOptions: eliminatedOptions ?? this.eliminatedOptions,
      starsEarned: starsEarned ?? this.starsEarned,
      currentNarrativeIndex:
          currentNarrativeIndex ?? this.currentNarrativeIndex,
      narrativeComplete: narrativeComplete ?? this.narrativeComplete,
      totalTimeSpent: totalTimeSpent ?? this.totalTimeSpent,
      answerResults: answerResults ?? this.answerResults,
    );
  }

  @override
  List<Object?> get props => [
        arcs,
        isLoaded,
        selectedArcId,
        selectedChapterId,
        currentQuestionIndex,
        correctAnswers,
        hasAnswered,
        isCorrect,
        selectedOptionIndex,
        chapterCompleted,
        showingNarrative,
        chapterProgress,
        coinsGained,
        currentStreak,
        highestStreak,
        fiftyFiftyUsed,
        eliminatedOptions,
        starsEarned,
        currentNarrativeIndex,
        narrativeComplete,
        totalTimeSpent,
        answerResults,
      ];
}
