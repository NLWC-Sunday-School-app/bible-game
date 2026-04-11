import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:bible_game/shared/widgets/quit_modal.dart';
import '../../bloc/true_or_false_bloc.dart';

class TrueOrFalseQuestionScreenTabletView extends StatefulWidget {
  const TrueOrFalseQuestionScreenTabletView({super.key});

  @override
  State<TrueOrFalseQuestionScreenTabletView> createState() =>
      _TrueOrFalseQuestionScreenTabletViewState();
}

class _TrueOrFalseQuestionScreenTabletViewState
    extends State<TrueOrFalseQuestionScreenTabletView>
    with TickerProviderStateMixin {
  static const int _secondsPerQuestion = 15;

  late AnimationController _timerController;

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: _secondsPerQuestion),
    );

    _timerController.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        if (mounted) {
          context.read<TrueOrFalseBloc>().add(TrueOrFalseTimerExpired());
        }
      }
    });

    _startTimer();
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timerController.duration = const Duration(seconds: _secondsPerQuestion);
    _timerController.reverse(from: 1.0);
  }

  int _getRemainingTime() {
    return (_timerController.value * _secondsPerQuestion).round();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TrueOrFalseBloc, TrueOrFalseState>(
      listenWhen: (prev, curr) =>
          prev.hasAnswered != curr.hasAnswered ||
          prev.gameCompleted != curr.gameCompleted ||
          prev.currentQuestionIndex != curr.currentQuestionIndex,
      listener: (context, state) {
        if (state.hasAnswered) {
          _timerController.stop();
        }

        if (state.gameCompleted) {
          _timerController.stop();
          _showGameSummary(context, state);
          return;
        }

        if (!state.hasAnswered && !state.gameCompleted) {
          _startTimer();
        }
      },
      builder: (context, state) {
        if (state.currentSessionIndices.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final questionIdx =
            state.currentSessionIndices[state.currentQuestionIndex];
        final question = state.allQuestions[questionIdx];
        final statement = question['statement'] as String? ?? '';
        final explanation = question['explanation'] as String? ?? '';
        final reference = question['bibleReference'] as String? ?? '';
        final category = question['category'] as String? ?? '';
        final correctAnswer = question['isTrue'] as bool;
        final totalQuestions = state.currentSessionIndices.length;

        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0F2027),
                  Color(0xFF203A43),
                  Color(0xFF2C5364)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 600.w),
                  child: Column(
                    children: [
                      SizedBox(height: 10.h),

                      // Top bar
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => showQuitModal(context,
                                  gameMode: 'trueOrFalse'),
                              child: Container(
                                padding: EdgeInsets.all(8.w),
                                decoration: BoxDecoration(
                                  color:
                                      Colors.white.withValues(alpha: 0.1),
                                  borderRadius:
                                      BorderRadius.circular(10.r),
                                ),
                                child: Icon(Icons.close_rounded,
                                    color: Colors.white70, size: 20.sp),
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Text(
                              '${state.currentQuestionIndex + 1} / $totalQuestions',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15.sp,
                              ),
                            ),
                            const Spacer(),
                            if (state.currentStreak > 0)
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: state.currentStreak >= 3
                                      ? const Color(0xFF4A9FFF)
                                          .withOpacity(0.2)
                                      : Colors.white.withOpacity(0.1),
                                  borderRadius:
                                      BorderRadius.circular(20.r),
                                  border: Border.all(
                                      color: state.currentStreak >= 3
                                          ? const Color(0xFF4A9FFF)
                                              .withOpacity(0.5)
                                          : Colors.white
                                              .withOpacity(0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('\u26A1',
                                        style:
                                            TextStyle(fontSize: 12.sp)),
                                    SizedBox(width: 4.w),
                                    Text(
                                      '${state.currentStreak}x',
                                      style: TextStyle(
                                        color: state.currentStreak >= 3
                                            ? const Color(0xFF5BB5FF)
                                            : Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color:
                                    Colors.amber.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                    color: Colors.amber
                                        .withValues(alpha: 0.4)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(IconImageRoutes.coinIcon,
                                      width: 16.w),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '${state.coinsGained}',
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 12.h),

                      // Timer bar
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: AnimatedBuilder(
                          animation: _timerController,
                          builder: (context, _) {
                            final value = _timerController.value;
                            final Color barColor = value > 0.3
                                ? const Color(0xFF4CAF50)
                                : value > 0.15
                                    ? Colors.orange
                                    : Colors.red;
                            return Container(
                              height: 7.h,
                              decoration: BoxDecoration(
                                color: Colors.white
                                    .withValues(alpha: 0.1),
                                borderRadius:
                                    BorderRadius.circular(3.r),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: value.clamp(0.0, 1.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: barColor,
                                    borderRadius:
                                        BorderRadius.circular(3.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: barColor
                                            .withValues(alpha: 0.6),
                                        blurRadius: 6,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 28.h),

                      // Category badge
                      if (category.isNotEmpty)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color:
                                Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                                color: Colors.white
                                    .withValues(alpha: 0.15)),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),

                      SizedBox(height: 20.h),

                      // Statement card
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Container(
                          width: double.infinity,
                          constraints:
                              BoxConstraints(minHeight: 130.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.r),
                                  topRight: Radius.circular(20.r),
                                ),
                                child: SvgPicture.asset(
                                  ProductImageRoutes
                                      .trueOrFalseCardHeader,
                                  width: double.infinity,
                                  height: 56.h,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 28.w,
                                    vertical: 24.h),
                                child: Text(
                                  statement,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18.sp,
                                    color: const Color(0xFF1A1A2E),
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Explanation
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: state.hasAnswered
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 28.w),
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 18.w,
                                      vertical: 14.h),
                                  decoration: BoxDecoration(
                                    color: (state.isCorrect ?? false)
                                        ? const Color(0xFF1B5E20)
                                            .withValues(alpha: 0.3)
                                        : const Color(0xFFB71C1C)
                                            .withValues(alpha: 0.3),
                                    borderRadius:
                                        BorderRadius.circular(14.r),
                                    border: Border.all(
                                      color: (state.isCorrect ?? false)
                                          ? const Color(0xFF4CAF50)
                                              .withValues(alpha: 0.5)
                                          : const Color(0xFFE53935)
                                              .withValues(alpha: 0.5),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            (state.isCorrect ?? false)
                                                ? Icons
                                                    .check_circle_rounded
                                                : Icons
                                                    .cancel_rounded,
                                            color: (state.isCorrect ??
                                                    false)
                                                ? const Color(
                                                    0xFF4CAF50)
                                                : const Color(
                                                    0xFFE53935),
                                            size: 22.sp,
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            (state.isCorrect ?? false)
                                                ? 'Correct!'
                                                : 'The answer is ${correctAnswer ? "TRUE" : "FALSE"}',
                                            style: TextStyle(
                                              fontWeight:
                                                  FontWeight.w800,
                                              fontSize: 14.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (explanation
                                          .isNotEmpty) ...[
                                        SizedBox(height: 10.h),
                                        Text(
                                          explanation,
                                          textAlign:
                                              TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.white70,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                      if (reference
                                          .isNotEmpty) ...[
                                        SizedBox(height: 6.h),
                                        Text(
                                          '\u2014 $reference',
                                          style: TextStyle(
                                            fontStyle:
                                                FontStyle.italic,
                                            fontSize: 11.sp,
                                            color: Colors
                                                .amber.shade300,
                                            fontWeight:
                                                FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),

                      const Spacer(),

                      // TRUE / FALSE buttons
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: _AnswerButtonTablet(
                                label: 'TRUE',
                                color: const Color(0xFF2E7D32),
                                shadowColor: const Color(0xFF1B5E20),
                                icon: Icons.check_rounded,
                                isSelected:
                                    state.selectedAnswer == true,
                                isCorrectAnswer:
                                    correctAnswer == true,
                                hasAnswered: state.hasAnswered,
                                onTap: state.hasAnswered
                                    ? null
                                    : () {
                                        context
                                            .read<TrueOrFalseBloc>()
                                            .add(AnswerTrueOrFalse(
                                              selectedAnswer: true,
                                              remainingTime:
                                                  _getRemainingTime(),
                                            ));
                                      },
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: _AnswerButtonTablet(
                                label: 'FALSE',
                                color: const Color(0xFFC62828),
                                shadowColor: const Color(0xFF8E0000),
                                icon: Icons.close_rounded,
                                isSelected:
                                    state.selectedAnswer == false,
                                isCorrectAnswer:
                                    correctAnswer == false,
                                hasAnswered: state.hasAnswered,
                                onTap: state.hasAnswered
                                    ? null
                                    : () {
                                        context
                                            .read<TrueOrFalseBloc>()
                                            .add(AnswerTrueOrFalse(
                                              selectedAnswer: false,
                                              remainingTime:
                                                  _getRemainingTime(),
                                            ));
                                      },
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 34.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Game summary dialog
  void _showGameSummary(BuildContext context, TrueOrFalseState state) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    final isNewHighScore =
        state.coinsGained >= state.highScore && state.coinsGained > 0;
    final totalQuestions = state.currentSessionIndices.length;
    final percentage =
        ((state.correctAnswers / totalQuestions) * 100).round();

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 60.w),
          child: Container(
            constraints: BoxConstraints(maxWidth: 450.w),
            padding:
                EdgeInsets.symmetric(horizontal: 28.w, vertical: 30.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F2027), Color(0xFF203A43)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('\u{1F3C6}', style: TextStyle(fontSize: 44.sp)),
                SizedBox(height: 10.h),
                Text(
                  'Game Complete!',
                  style: TextStyle(
                    fontFamily: 'Mikado',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),

                if (isNewHighScore) ...[
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 18.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '\u2B50 New High Score!',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],

                SizedBox(height: 22.h),

                // Score circle
                Container(
                  width: 90.w,
                  height: 90.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: percentage >= 80
                          ? [
                              const Color(0xFF4CAF50),
                              const Color(0xFF2E7D32)
                            ]
                          : percentage >= 50
                              ? [Colors.orange, Colors.deepOrange]
                              : [
                                  const Color(0xFFE53935),
                                  const Color(0xFFC62828)
                                ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (percentage >= 80
                                ? const Color(0xFF4CAF50)
                                : percentage >= 50
                                    ? Colors.orange
                                    : const Color(0xFFE53935))
                            .withValues(alpha: 0.4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${state.correctAnswers}/$totalQuestions',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 20.sp,
                        ),
                      ),
                      Text(
                        '$percentage%',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 22.h),

                // Stats row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatBadgeTablet(
                      icon: '\u{1F4B0}',
                      label: 'Coins',
                      value: '${state.coinsGained}',
                    ),
                    _StatBadgeTablet(
                      icon: '\u{1F525}',
                      label: 'Streak',
                      value: '${state.highestStreakThisGame}',
                    ),
                  ],
                ),

                SizedBox(height: 22.h),

                // Review Answers button
                GestureDetector(
                  onTap: () {
                    soundManager.playClickSound();
                    Navigator.pop(context);
                    _showAnswerReview(context, state);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                          color:
                              Colors.amber.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.fact_check_rounded,
                            color: Colors.amber, size: 18.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'Review Answers',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.amber,
                            fontSize: 15.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16.h),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          soundManager.playClickSound();
                          context
                              .read<TrueOrFalseBloc>()
                              .add(ResetTrueOrFalseGame());
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            color:
                                Colors.white.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(12.r),
                            border: Border.all(
                                color: Colors.white
                                    .withValues(alpha: 0.2)),
                          ),
                          child: Center(
                            child: Text(
                              'Home',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white70,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          soundManager.playClickSound();
                          context
                              .read<TrueOrFalseBloc>()
                              .add(StartTrueOrFalseGame());
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF4CAF50),
                                Color(0xFF2E7D32)
                              ],
                            ),
                            borderRadius:
                                BorderRadius.circular(12.r),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xFF1B5E20),
                                offset: Offset(0, 4),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              'Play Again',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Answer review modal
  void _showAnswerReview(
      BuildContext context, TrueOrFalseState state) {
    final soundManager = context.read<SettingsBloc>().soundManager;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F2027), Color(0xFF203A43)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                children: [
                  Container(
                    margin:
                        EdgeInsets.only(top: 12.h, bottom: 8.h),
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 24.w, vertical: 10.h),
                    child: Row(
                      children: [
                        Text(
                          'Answer Review',
                          style: TextStyle(
                            fontFamily: 'Mikado',
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            soundManager.playClickSound();
                            Navigator.pop(context);
                            _showGameSummary(context, state);
                          },
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white
                                  .withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(10.r),
                            ),
                            child: Icon(Icons.close_rounded,
                                color: Colors.white70,
                                size: 20.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(maxWidth: 580.w),
                        child: ListView.builder(
                          controller: scrollController,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 8.h),
                          itemCount: state.answerHistory.length,
                          itemBuilder: (_, index) {
                            final entry =
                                state.answerHistory[index];
                            final qIdx =
                                entry['questionIndex'] as int;
                            final userAnswer =
                                entry['userAnswer'] as bool?;
                            final isCorrect =
                                entry['isCorrect'] as bool;
                            final question =
                                state.allQuestions[qIdx];
                            final statement = question[
                                    'statement'] as String? ??
                                '';
                            final explanation = question[
                                    'explanation'] as String? ??
                                '';
                            final reference = question[
                                    'bibleReference'] as String? ??
                                '';
                            final correctAnswer =
                                question['isTrue'] as bool;

                            return Container(
                              margin:
                                  EdgeInsets.only(bottom: 14.h),
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: Colors.white
                                    .withValues(alpha: 0.06),
                                borderRadius:
                                    BorderRadius.circular(14.r),
                                border: Border.all(
                                  color: isCorrect
                                      ? const Color(0xFF4CAF50)
                                          .withValues(
                                              alpha: 0.3)
                                      : const Color(0xFFE53935)
                                          .withValues(
                                              alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Q${index + 1}',
                                        style: TextStyle(
                                          color: Colors.white54,
                                          fontWeight:
                                              FontWeight.w700,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding:
                                            EdgeInsets.symmetric(
                                                horizontal:
                                                    10.w,
                                                vertical: 3.h),
                                        decoration:
                                            BoxDecoration(
                                          color: isCorrect
                                              ? const Color(
                                                      0xFF4CAF50)
                                                  .withValues(
                                                      alpha:
                                                          0.2)
                                              : const Color(
                                                      0xFFE53935)
                                                  .withValues(
                                                      alpha:
                                                          0.2),
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                                      20.r),
                                        ),
                                        child: Row(
                                          mainAxisSize:
                                              MainAxisSize.min,
                                          children: [
                                            Icon(
                                              isCorrect
                                                  ? Icons
                                                      .check_circle_rounded
                                                  : Icons
                                                      .cancel_rounded,
                                              color: isCorrect
                                                  ? const Color(
                                                      0xFF4CAF50)
                                                  : const Color(
                                                      0xFFE53935),
                                              size: 14.sp,
                                            ),
                                            SizedBox(
                                                width: 4.w),
                                            Text(
                                              isCorrect
                                                  ? 'Correct'
                                                  : 'Wrong',
                                              style: TextStyle(
                                                color: isCorrect
                                                    ? const Color(
                                                        0xFF4CAF50)
                                                    : const Color(
                                                        0xFFE53935),
                                                fontSize:
                                                    11.sp,
                                                fontWeight:
                                                    FontWeight
                                                        .w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    statement,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight:
                                          FontWeight.w600,
                                      height: 1.4,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Row(
                                    children: [
                                      _AnswerTagTablet(
                                        label:
                                            'Answer: ${correctAnswer ? "TRUE" : "FALSE"}',
                                        color: const Color(
                                            0xFF4CAF50),
                                      ),
                                      SizedBox(width: 8.w),
                                      if (userAnswer != null)
                                        _AnswerTagTablet(
                                          label:
                                              'You: ${userAnswer ? "TRUE" : "FALSE"}',
                                          color: isCorrect
                                              ? const Color(
                                                  0xFF4CAF50)
                                              : const Color(
                                                  0xFFE53935),
                                        )
                                      else
                                        _AnswerTagTablet(
                                          label: 'Timed out',
                                          color: Colors.orange,
                                        ),
                                    ],
                                  ),
                                  if (explanation
                                      .isNotEmpty) ...[
                                    SizedBox(height: 10.h),
                                    Text(
                                      explanation,
                                      style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12.sp,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                  if (reference
                                      .isNotEmpty) ...[
                                    SizedBox(height: 4.h),
                                    Text(
                                      '\u2014 $reference',
                                      style: TextStyle(
                                        color: Colors
                                            .amber.shade300,
                                        fontSize: 11.sp,
                                        fontStyle:
                                            FontStyle.italic,
                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _AnswerTagTablet extends StatelessWidget {
  const _AnswerTagTablet({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _AnswerButtonTablet extends StatelessWidget {
  const _AnswerButtonTablet({
    required this.label,
    required this.color,
    required this.shadowColor,
    required this.icon,
    required this.isSelected,
    required this.isCorrectAnswer,
    required this.hasAnswered,
    required this.onTap,
  });

  final String label;
  final Color color;
  final Color shadowColor;
  final IconData icon;
  final bool isSelected;
  final bool isCorrectAnswer;
  final bool hasAnswered;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    Color btnColor = color;
    Color btnShadow = shadowColor;
    double opacity = 1.0;

    if (hasAnswered) {
      if (isCorrectAnswer) {
        btnColor = const Color(0xFF2E7D32);
        btnShadow = const Color(0xFF1B5E20);
      } else if (isSelected) {
        btnColor = const Color(0xFF7F0000);
        btnShadow = const Color(0xFF4A0000);
        opacity = 0.8;
      } else {
        opacity = 0.3;
      }
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: opacity,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 90.h,
          decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: btnShadow,
                offset: const Offset(0, 6),
                blurRadius: 0,
              ),
              if (hasAnswered && isCorrectAnswer)
                BoxShadow(
                  color:
                      const Color(0xFF4CAF50).withValues(alpha: 0.5),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 34.sp),
              SizedBox(height: 6.h),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Mikado',
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontSize: 20.sp,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatBadgeTablet extends StatelessWidget {
  const _StatBadgeTablet({
    required this.icon,
    required this.label,
    required this.value,
  });
  final String icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: TextStyle(fontSize: 24.sp)),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            fontSize: 22.sp,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white54,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
