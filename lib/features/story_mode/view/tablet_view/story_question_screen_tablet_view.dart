import 'dart:math';

import 'package:bible_game_api/model/game_question.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/constants/colors.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/widgets/blue_button.dart';
import 'package:bible_game/shared/widgets/custom_toast.dart';
import 'package:bible_game/shared/widgets/power_up_bar.dart';
import 'package:bible_game/shared/widgets/question_container.dart';
import '../../../store/bloc/power_up_bloc.dart';
import '../../../store/bloc/power_up_event.dart';
import '../../../store/model/power_up.dart';
import '../../bloc/story_mode_bloc.dart';
import '../../widget/typing_text_widget.dart';
import 'package:bible_game/features/story_mode/widget/modal/chapter_summary_modal.dart';

class StoryQuestionScreenTabletView extends StatefulWidget {
  const StoryQuestionScreenTabletView({super.key});

  @override
  State<StoryQuestionScreenTabletView> createState() =>
      _StoryQuestionScreenTabletViewState();
}

class _StoryQuestionScreenTabletViewState
    extends State<StoryQuestionScreenTabletView>
    with TickerProviderStateMixin {
  late AnimationController _timerController;
  late ConfettiController _confettiController;

  bool _typingComplete = false;

  // Power-up local state
  bool _fiftyFiftyUsed = false;
  bool _timeFreezeUsed = false;
  List<int> _eliminatedOptionIndices = [];

  @override
  void initState() {
    super.initState();

    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));

    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );

    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        if (mounted) {
          context.read<StoryModeBloc>().add(TimerExpired());
        }
      }
    });
  }

  @override
  void dispose() {
    _timerController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _startTimer(Map<String, dynamic> chapter) {
    final timerEnabled = chapter['timerEnabled'] as bool? ?? false;
    if (!timerEnabled) return;
    final duration = chapter['timerDurationSeconds'] as int? ?? 30;
    _timerController.duration = Duration(seconds: duration);
    _timerController.reverse(from: 1.0);
  }

  int _getRemainingTime(Map<String, dynamic> chapter) {
    final duration = chapter['timerDurationSeconds'] as int? ?? 30;
    return (_timerController.value * duration).round();
  }

  void _resetPowerUpsForQuestion() {
    setState(() {
      _fiftyFiftyUsed = false;
      _timeFreezeUsed = false;
      _eliminatedOptionIndices = [];
    });
  }

  void _useFiftyFifty(GameQuestion gameQuestion) {
    if (_fiftyFiftyUsed) return;
    final options = gameQuestion.options;
    final correctAnswer = gameQuestion.answer;
    final wrongIndices = <int>[];
    for (int i = 0; i < options.length; i++) {
      if (options[i] != correctAnswer) wrongIndices.add(i);
    }
    wrongIndices.shuffle(Random());
    final toEliminate = wrongIndices.take(2).toList();
    setState(() {
      _fiftyFiftyUsed = true;
      _eliminatedOptionIndices = toEliminate;
    });
    context.read<PowerUpBloc>().add(UsePowerUp(PowerUpType.fiftyFifty));
  }

  void _useTimeFreeze(int timerDuration) {
    if (_timeFreezeUsed) return;
    setState(() => _timeFreezeUsed = true);
    context.read<PowerUpBloc>().add(UsePowerUp(PowerUpType.timeFreeze));
    final freezeBonus = 30.0 / timerDuration;
    final newValue = (_timerController.value + freezeBonus).clamp(0.0, 1.0);
    _timerController.value = newValue;
    showCustomToast(context, '\u{2744} Time Freeze! +30s');
  }

  Map<String, dynamic>? _currentChapter(StoryModeState state) {
    if (state.selectedArcId.isEmpty || state.selectedChapterId.isEmpty) {
      return null;
    }
    final arc = state.arcs.firstWhere(
      (a) => a['id'] == state.selectedArcId,
      orElse: () => {},
    );
    if (arc.isEmpty) return null;
    final chapters = arc['chapters'] as List;
    try {
      return chapters.firstWhere(
        (c) => (c as Map<String, dynamic>)['id'] == state.selectedChapterId,
      ) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  GameQuestion _toGameQuestion(Map<String, dynamic> q) {
    return GameQuestion(
      instruction: q['instruction'] as String? ?? 'Story Mode',
      question: q['question'] as String,
      answer: q['answer'] as String,
      options: List<String>.from(q['options'] as List),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoryModeBloc, StoryModeState>(
      listenWhen: (prev, curr) =>
          prev.chapterCompleted != curr.chapterCompleted ||
          prev.hasAnswered != curr.hasAnswered ||
          prev.narrativeComplete != curr.narrativeComplete ||
          prev.currentQuestionIndex != curr.currentQuestionIndex,
      listener: (context, state) {
        final chapter = _currentChapter(state);

        if (state.chapterCompleted) {
          _confettiController.play();
          if (chapter != null) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => BlocProvider.value(
                value: context.read<StoryModeBloc>(),
                child: ChapterSummaryModal(
                  state: state,
                  chapter: chapter,
                ),
              ),
            );
          }
        }

        if (state.hasAnswered) {
          _timerController.stop();
        }

        if (!state.hasAnswered && !state.chapterCompleted) {
          _resetPowerUpsForQuestion();
          if (chapter != null) _startTimer(chapter);
        }
      },
      builder: (context, state) {
        final chapter = _currentChapter(state);
        if (chapter == null) return const SizedBox.shrink();

        final narratives = chapter['narratives'] as List? ?? <dynamic>[];
        final questions =
            chapter['questions'] as List<Map<String, dynamic>>;

        return Scaffold(
          backgroundColor: const Color(0xFF1A1A2E),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 0,
          ),
          body: Stack(
            children: [
              if (!state.narrativeComplete)
                _NarrativeViewTablet(
                  chapter: chapter,
                  narratives: narratives,
                  currentIndex: state.currentNarrativeIndex,
                  typingComplete: _typingComplete,
                  onTypingComplete: () {
                    setState(() => _typingComplete = true);
                  },
                  onTapCard: () {
                    if (_typingComplete) {
                      setState(() => _typingComplete = false);
                      context.read<StoryModeBloc>().add(AdvanceNarrative());
                    }
                  },
                  onBeginQuestions: () {
                    context.read<StoryModeBloc>().add(AdvanceNarrative());
                  },
                )
              else
                _QuestionPhaseTablet(
                  state: state,
                  chapter: chapter,
                  questions: questions,
                  timerController: _timerController,
                  toGameQuestion: _toGameQuestion,
                  getRemainingTime: () => _getRemainingTime(chapter),
                  fiftyFiftyUsed: _fiftyFiftyUsed,
                  timeFreezeUsed: _timeFreezeUsed,
                  eliminatedOptionIndices: _eliminatedOptionIndices,
                  onUseFiftyFifty: _useFiftyFifty,
                  onUseTimeFreeze: (duration) => _useTimeFreeze(duration),
                ),

              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  numberOfParticles: 40,
                  colors: const [
                    Colors.yellow,
                    Colors.orange,
                    Colors.green,
                    Colors.blue,
                    Colors.purple,
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =============================================================================
// Narrative Phase (Tablet)
// =============================================================================

class _NarrativeViewTablet extends StatelessWidget {
  const _NarrativeViewTablet({
    required this.chapter,
    required this.narratives,
    required this.currentIndex,
    required this.typingComplete,
    required this.onTypingComplete,
    required this.onTapCard,
    required this.onBeginQuestions,
  });

  final Map<String, dynamic> chapter;
  final List narratives;
  final int currentIndex;
  final bool typingComplete;
  final VoidCallback onTypingComplete;
  final VoidCallback onTapCard;
  final VoidCallback onBeginQuestions;

  bool get _isLastSegment =>
      narratives.isEmpty || currentIndex >= narratives.length - 1;

  String get _currentText {
    if (narratives.isEmpty) return chapter['narrativeText'] as String? ?? '';
    if (currentIndex < narratives.length) {
      final seg = narratives[currentIndex];
      if (seg is String) return seg;
      if (seg is Map) return seg['text'] as String? ?? '';
    }
    return '';
  }

  String get _segmentLabel {
    if (narratives.isEmpty) return 'Story';
    return 'Story \u2022 ${currentIndex + 1} of ${narratives.length}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 620.w),
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapter['title'] as String? ?? '',
                    style: TextStyle(
                      color: AppColors.accentColor,
                      fontFamily: 'Neuland',
                      fontSize: 18.sp,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _segmentLabel,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onTapCard,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A0A1A)
                              .withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColors.accentColor
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '\u{1F4DC}',
                                  style: TextStyle(fontSize: 20.sp),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  'The Story',
                                  style: TextStyle(
                                    color: AppColors.accentColor,
                                    fontFamily: 'Neuland',
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 18.h),
                            Expanded(
                              child: SingleChildScrollView(
                                child: TypingTextWidget(
                                  key: ValueKey(
                                      'narrative_$currentIndex'),
                                  text: _currentText,
                                  charsPerSecond: 38,
                                  onComplete: onTypingComplete,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.sp,
                                    height: 1.8,
                                  ),
                                ),
                              ),
                            ),
                            AnimatedOpacity(
                              opacity: typingComplete ? 1.0 : 0.0,
                              duration:
                                  const Duration(milliseconds: 400),
                              child: Padding(
                                padding: EdgeInsets.only(top: 14.h),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      _isLastSegment
                                          ? 'Ready to answer \u2192'
                                          : 'Tap to continue \u2192',
                                      style: TextStyle(
                                        color: AppColors.accentColor
                                            .withValues(alpha: 0.85),
                                        fontSize: 13.sp,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 18.h),

                  if (typingComplete && _isLastSegment)
                    BlueButton(
                      onTap: onBeginQuestions,
                      buttonText: 'Begin Questions',
                      buttonIsLoading: false,
                      width: double.infinity,
                    )
                  else
                    GestureDetector(
                      onTap: onBeginQuestions,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        child: Center(
                          child: Text(
                            'Skip Story  \u00BB',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: 14.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Question Phase (Tablet)
// =============================================================================

class _QuestionPhaseTablet extends StatelessWidget {
  const _QuestionPhaseTablet({
    required this.state,
    required this.chapter,
    required this.questions,
    required this.timerController,
    required this.toGameQuestion,
    required this.getRemainingTime,
    required this.fiftyFiftyUsed,
    required this.timeFreezeUsed,
    required this.eliminatedOptionIndices,
    required this.onUseFiftyFifty,
    required this.onUseTimeFreeze,
  });

  final StoryModeState state;
  final Map<String, dynamic> chapter;
  final List<Map<String, dynamic>> questions;
  final AnimationController timerController;
  final GameQuestion Function(Map<String, dynamic>) toGameQuestion;
  final int Function() getRemainingTime;
  final bool fiftyFiftyUsed;
  final bool timeFreezeUsed;
  final List<int> eliminatedOptionIndices;
  final void Function(GameQuestion) onUseFiftyFifty;
  final void Function(int timerDuration) onUseTimeFreeze;

  @override
  Widget build(BuildContext context) {
    final q = questions[state.currentQuestionIndex];
    final gameQuestion = toGameQuestion(q);
    final timerEnabled = chapter['timerEnabled'] as bool? ?? false;
    final timerDuration = chapter['timerDurationSeconds'] as int? ?? 30;

    final powerUpState = context.watch<PowerUpBloc>().state;
    final powerUpItems = <PowerUpBarItem>[
      PowerUpBarItem(
        label: '50/50',
        iconPath: IconImageRoutes.star,
        quantity: powerUpState.getQuantity(PowerUpType.fiftyFifty),
        isUsed: fiftyFiftyUsed,
        accentColor: const Color(0xFFFF6B6B),
        onTap: () {
          if (state.hasAnswered) return;
          onUseFiftyFifty(gameQuestion);
        },
      ),
      if (timerEnabled)
        PowerUpBarItem(
          label: 'Freeze',
          iconPath: IconImageRoutes.greenTimer,
          quantity: powerUpState.getQuantity(PowerUpType.timeFreeze),
          isUsed: timeFreezeUsed,
          accentColor: const Color(0xFF54D6FF),
          onTap: () {
            if (state.hasAnswered) return;
            onUseTimeFreeze(timerDuration);
          },
        ),
    ];

    return Stack(
      children: [
        QuestionContainer(
          gameQuestion: gameQuestion,
          animationController: timerController,
          currentPage: state.currentQuestionIndex + 1,
          totalQuestions: questions.length,
          hasTimer: timerEnabled,
          durationPerQuestion: timerDuration,
          optionSelectedCallback: (index) {
            context.read<StoryModeBloc>().add(
                  AnswerStoryQuestion(
                    selectedOptionIndex: index,
                    remainingTime: getRemainingTime(),
                  ),
                );
          },
          isCorrectAnswer: state.isCorrect ?? false,
          selectedOptionIndex: state.selectedOptionIndex,
          hasAnswered: state.hasAnswered,
          coinsGained: state.coinsGained,
          noOfCorrectAnswers: state.correctAnswers,
          streakCount: state.currentStreak,
          fiftyFiftyUsed: fiftyFiftyUsed,
          eliminatedOptionIndices: eliminatedOptionIndices,
          powerUpItems: powerUpItems,
          skipQuestion: () {
            if (state.hasAnswered) {
              context.read<StoryModeBloc>().add(MoveToNextStoryQuestion());
            } else {
              context.read<StoryModeBloc>().add(TimerExpired());
            }
          },
          gameMode: 'storyMode',
          isWhoIsWho: false,
        ),
      ],
    );
  }
}
