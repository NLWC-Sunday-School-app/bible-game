import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_game/shared/constants/colors.dart';
import 'package:bible_game/shared/widgets/blue_button.dart';
import '../../bloc/story_mode_bloc.dart';

class ChapterSummaryModal extends StatefulWidget {
  const ChapterSummaryModal({
    super.key,
    required this.state,
    required this.chapter,
  });

  final StoryModeState state;
  final Map<String, dynamic> chapter;

  @override
  State<ChapterSummaryModal> createState() => _ChapterSummaryModalState();
}

class _ChapterSummaryModalState extends State<ChapterSummaryModal>
    with TickerProviderStateMixin {
  late final AnimationController _star1Controller;
  late final AnimationController _star2Controller;
  late final AnimationController _star3Controller;

  late final Animation<double> _star1Scale;
  late final Animation<double> _star2Scale;
  late final Animation<double> _star3Scale;

  @override
  void initState() {
    super.initState();

    _star1Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _star2Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _star3Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _star1Scale = CurvedAnimation(
      parent: _star1Controller,
      curve: Curves.elasticOut,
    );
    _star2Scale = CurvedAnimation(
      parent: _star2Controller,
      curve: Curves.elasticOut,
    );
    _star3Scale = CurvedAnimation(
      parent: _star3Controller,
      curve: Curves.elasticOut,
    );

    // Staggered star animations
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _star1Controller.forward();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _star2Controller.forward();
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) _star3Controller.forward();
    });
  }

  @override
  void dispose() {
    _star1Controller.dispose();
    _star2Controller.dispose();
    _star3Controller.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  String get _titleText {
    switch (widget.state.starsEarned) {
      case 3:
        return 'Well Done!';
      case 2:
        return 'Good Job!';
      case 1:
        return 'Keep Going!';
      default:
        return 'Try Again!';
    }
  }

  Color get _titleColor {
    switch (widget.state.starsEarned) {
      case 3:
        return AppColors.correctAnswer;
      case 2:
        return AppColors.accentColor;
      case 1:
        return Colors.orange;
      default:
        return Colors.redAccent;
    }
  }

  int get _totalQuestions {
    final questions = widget.chapter['questions'] as List? ?? [];
    return questions.length;
  }

  Widget _buildStar({
    required Animation<double> scaleAnimation,
    required bool earned,
    required double size,
  }) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: Icon(
        earned ? Icons.star_rounded : Icons.star_outline_rounded,
        size: size,
        color: earned ? const Color(0xFFFFD700) : Colors.white24,
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final stars = widget.state.starsEarned;
    final correct = widget.state.correctAnswers;
    final total = _totalQuestions;
    final coins = widget.state.coinsGained;
    final highestStreak = widget.state.highestStreak;
    final chapterId = widget.state.selectedChapterId;

    final questions =
        widget.chapter['questions'] as List<Map<String, dynamic>>? ?? [];
    final answerResults = widget.state.answerResults;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.accentColor.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- Stars Row ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStar(
                  scaleAnimation: _star1Scale,
                  earned: stars >= 1,
                  size: stars >= 1 ? 52.sp : 42.sp,
                ),
                SizedBox(width: 4.w),
                _buildStar(
                  scaleAnimation: _star2Scale,
                  earned: stars >= 2,
                  size: stars >= 2 ? 58.sp : 46.sp,
                ),
                SizedBox(width: 4.w),
                _buildStar(
                  scaleAnimation: _star3Scale,
                  earned: stars >= 3,
                  size: stars >= 3 ? 52.sp : 42.sp,
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // --- Title ---
            Text(
              _titleText,
              style: TextStyle(
                color: _titleColor,
                fontFamily: 'Neuland',
                fontSize: 26.sp,
                letterSpacing: 0.5,
              ),
            ),

            SizedBox(height: 8.h),

            // --- Score line ---
            Text(
              '$correct / $total correct',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16.sp,
              ),
            ),

            SizedBox(height: 20.h),

            // --- Stats row ---
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Coins
                  _StatItem(
                    emoji: '\u{1FA99}',
                    label: 'Coins',
                    value: '+$coins',
                    valueColor: AppColors.accentColor,
                  ),
                  Container(
                    width: 1,
                    height: 36.h,
                    color: Colors.white12,
                  ),
                  // Highest streak
                  _StatItem(
                    emoji: '\u{1F525}',
                    label: 'Best Streak',
                    value: '$highestStreak',
                    valueColor: Colors.orangeAccent,
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // --- Review Answers Button ---
            if (questions.isNotEmpty)
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierColor: const Color.fromRGBO(0, 0, 0, 0.6),
                    builder: (_) => _ReviewAnswersModal(
                      questions: questions,
                      answerResults: answerResults,
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '📖',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Review Answers',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white38,
                        size: 14.sp,
                      ),
                    ],
                  ),
                ),
              ),

            SizedBox(height: 16.h),

            // --- Buttons ---

            // "Try Again" — shown when no stars or user wants to improve
            if (stars == 0 || stars < 3)
              BlueButton(
                onTap: () {
                  Navigator.of(context).pop();
                  context.read<StoryModeBloc>().add(
                        SelectChapter(chapterId: chapterId),
                      );
                },
                buttonText: 'Try Again',
                buttonIsLoading: false,
                width: double.infinity,
                height: 50,
              ),

            SizedBox(height: 10.h),

            // "Back to Chapters" — always shown
            GestureDetector(
              onTap: () {
                context.read<StoryModeBloc>().add(ResetStoryGame());
                Navigator.of(context).pop(); // close dialog
                Navigator.of(context).pop(); // pop question screen
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: AppColors.accentColor.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    'Back to Chapters',
                    style: TextStyle(
                      color: AppColors.accentColor,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Review Answers Modal
// =============================================================================

class _ReviewAnswersModal extends StatelessWidget {
  const _ReviewAnswersModal({
    required this.questions,
    required this.answerResults,
  });

  final List<Map<String, dynamic>> questions;
  final List<bool> answerResults;

  @override
  Widget build(BuildContext context) {
    final correctCount = answerResults.where((r) => r).length;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 32.h),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.accentColor.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 12.w, 0),
              child: Row(
                children: [
                  Text(
                    '📖',
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Review Answers',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Neuland',
                            fontSize: 18.sp,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '$correctCount of ${questions.length} correct',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.white38,
                      size: 22.sp,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),

            // Divider
            Container(
              height: 1,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              color: Colors.white.withValues(alpha: 0.08),
            ),

            SizedBox(height: 12.h),

            // Scrollable answer list
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: 8.h),
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final q = questions[index];
                    final wasCorrect = index < answerResults.length
                        ? answerResults[index]
                        : false;

                    return _AnswerReviewTile(
                      index: index,
                      question: q['question'] as String? ?? '',
                      answer: q['answer'] as String? ?? '',
                      bibleReference: q['bibleReference'] as String? ?? '',
                      explanation: q['explanation'] as String? ?? '',
                      wasCorrect: wasCorrect,
                    );
                  },
                ),
              ),
            ),

            // Back button
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: AppColors.accentColor.withValues(alpha: 0.6),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Back to Summary',
                      style: TextStyle(
                        color: AppColors.accentColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Small helper widget for a stat cell
// =============================================================================

class _AnswerReviewTile extends StatelessWidget {
  const _AnswerReviewTile({
    required this.index,
    required this.question,
    required this.answer,
    required this.bibleReference,
    required this.explanation,
    required this.wasCorrect,
  });

  final int index;
  final String question;
  final String answer;
  final String bibleReference;
  final String explanation;
  final bool wasCorrect;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10.r),
        border: Border(
          left: BorderSide(
            color: wasCorrect
                ? const Color(0xFF4CAF50)
                : const Color(0xFFF44336),
            width: 3.w,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question + status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                wasCorrect ? '✅' : '❌',
                style: TextStyle(fontSize: 12.sp),
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  question,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          // Answer
          Text(
            'Answer: $answer',
            style: TextStyle(
              color: const Color(0xFF4CAF50),
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          // Bible reference + explanation
          if (bibleReference.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              '📖  $bibleReference',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          if (explanation.isNotEmpty) ...[
            SizedBox(height: 3.h),
            Text(
              explanation,
              style: TextStyle(
                color: Colors.white38,
                fontSize: 10.sp,
                height: 1.3,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.emoji,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String emoji;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: TextStyle(fontSize: 18.sp)),
            SizedBox(width: 6.w),
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            color: Colors.white38,
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }
}
