import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/constants/colors.dart';
import 'package:bible_game/shared/widgets/custom_toast.dart';
import '../bloc/daily_devotional_bloc.dart';

class DailyDevotionalScreen extends StatefulWidget {
  const DailyDevotionalScreen({super.key});

  @override
  State<DailyDevotionalScreen> createState() => _DailyDevotionalScreenState();
}

class _DailyDevotionalScreenState extends State<DailyDevotionalScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    context.read<DailyDevotionalBloc>().add(LoadDailyDevotional());
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DailyDevotionalBloc, DailyDevotionalState>(
      listenWhen: (prev, curr) => prev.hasAnswered != curr.hasAnswered,
      listener: (context, state) {
        if (state.hasAnswered) {
          if (state.isCorrect == true) {
            _confettiController.play();
            showCustomToast(context, '✅ Correct! Great job!');
          } else {
            showCustomToast(context, '📖 Keep studying the Word!');
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.primaryDarkBackground,
          appBar: AppBar(
            backgroundColor: AppColors.primaryDarkBackground,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Daily Devotional',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Neuland',
                fontSize: 18.sp,
              ),
            ),
            actions: [
              if (state.devotionalStreak > 0)
                Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: Row(
                    children: [
                      Text('🔥', style: TextStyle(fontSize: 16.sp)),
                      SizedBox(width: 4.w),
                      Text(
                        '${state.devotionalStreak}',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          body: Stack(
            children: [
              if (!state.isLoaded)
                const Center(
                    child: CircularProgressIndicator(color: Colors.white))
              else
                _buildContent(context, state),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  numberOfParticles: 25,
                  colors: const [
                    Colors.yellow,
                    Colors.orange,
                    Colors.green,
                    Colors.blue,
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, DailyDevotionalState state) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Completed today banner
          if (state.hasCompletedToday && !state.hasAnswered)
            _CompletedBanner(streak: state.devotionalStreak)
                .animate()
                .fadeIn(duration: 400.ms),

          // Passage card
          _PassageCard(
            passage: state.passage,
            passageText: state.passageText,
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),

          SizedBox(height: 16.h),

          // Reflection card
          _ReflectionCard(reflection: state.reflection)
              .animate()
              .fadeIn(duration: 500.ms, delay: 100.ms)
              .slideY(begin: 0.2, end: 0),

          SizedBox(height: 20.h),

          // Question section
          if (!state.hasCompletedToday || state.hasAnswered)
            _QuestionSection(state: state).animate().fadeIn(
                  duration: 500.ms,
                  delay: 200.ms,
                ),
        ],
      ),
    );
  }
}

class _CompletedBanner extends StatelessWidget {
  final int streak;
  const _CompletedBanner({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.correctAnswer.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.correctAnswer, width: 1.5),
      ),
      child: Row(
        children: [
          Text('✅', style: TextStyle(fontSize: 20.sp)),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Completed today!',
                  style: TextStyle(
                    color: AppColors.correctAnswer,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                Text(
                  'Come back tomorrow for a new devotional.',
                  style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                ),
              ],
            ),
          ),
          if (streak > 0) ...[
            Text('🔥', style: TextStyle(fontSize: 16.sp)),
            Text(
              ' $streak day streak',
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ],
      ),
    );
  }
}

class _PassageCard extends StatelessWidget {
  final String passage;
  final String passageText;
  const _PassageCard({required this.passage, required this.passageText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.navyBlue,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.accentColor, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('📖', style: TextStyle(fontSize: 18.sp)),
              SizedBox(width: 8.w),
              Text(
                passage,
                style: TextStyle(
                  color: AppColors.accentColor,
                  fontFamily: 'Neuland',
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            passageText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              height: 1.6,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReflectionCard extends StatelessWidget {
  final String reflection;
  const _ReflectionCard({required this.reflection});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.slateBlue,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '💡 Reflection',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Neuland',
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            reflection,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13.sp,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionSection extends StatelessWidget {
  final DailyDevotionalState state;
  const _QuestionSection({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '❓ Quick Question',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Neuland',
            fontSize: 15.sp,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppColors.navyBlue,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            state.question,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              height: 1.5,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        ...List.generate(state.options.length, (index) {
          return _OptionTile(
            text: state.options[index],
            index: index,
            state: state,
          );
        }),
        if (state.hasAnswered) ...[
          SizedBox(height: 8.h),
          _PostAnswerMessage(isCorrect: state.isCorrect == true),
        ],
        SizedBox(height: 20.h),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String text;
  final int index;
  final DailyDevotionalState state;

  const _OptionTile(
      {required this.text, required this.index, required this.state});

  @override
  Widget build(BuildContext context) {
    final labels = ['A', 'B', 'C', 'D'];
    Color bgColor = AppColors.slateBlue;
    Color borderColor = Colors.transparent;
    Color textColor = Colors.white;
    Color labelColor = Colors.white;
    double tileOpacity = 1.0;

    if (state.hasAnswered) {
      if (text == state.answer) {
        // Correct answer: green highlight
        bgColor = AppColors.correctAnswer.withValues(alpha: 0.2);
        borderColor = AppColors.correctAnswer;
      } else if (index == state.selectedOptionIndex) {
        // User's wrong pick: red highlight
        bgColor = AppColors.wrongAnswer.withValues(alpha: 0.2);
        borderColor = AppColors.wrongAnswer;
        textColor = Colors.white70;
      } else {
        // Unselected wrong options: dimmed
        tileOpacity = 0.4;
        textColor = Colors.white54;
        labelColor = Colors.white54;
      }
    }

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 400),
      opacity: tileOpacity,
      child: GestureDetector(
        onTap: state.hasAnswered
            ? null
            : () => context
                .read<DailyDevotionalBloc>()
                .add(AnswerDevotional(selectedOptionIndex: index)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    labels[index],
                    style: TextStyle(
                      color: labelColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              if (state.hasAnswered && text == state.answer)
                Text('✅', style: TextStyle(fontSize: 14.sp)),
              if (state.hasAnswered &&
                  index == state.selectedOptionIndex &&
                  text != state.answer)
                Text('❌', style: TextStyle(fontSize: 14.sp)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostAnswerMessage extends StatelessWidget {
  final bool isCorrect;
  const _PostAnswerMessage({required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppColors.correctAnswer.withValues(alpha: 0.12)
            : AppColors.wrongAnswer.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isCorrect
              ? AppColors.correctAnswer.withValues(alpha: 0.4)
              : AppColors.wrongAnswer.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            isCorrect ? '🎉 Well done!' : '📖 The correct answer is highlighted above',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Come back tomorrow for a new devotional!',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.3, end: 0);
  }
}
