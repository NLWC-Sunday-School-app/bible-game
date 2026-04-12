import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/constants/colors.dart';
import 'package:bible_game/shared/widgets/custom_toast.dart';
import '../../bloc/daily_devotional_bloc.dart';

class DailyDevotionalScreenTabletView extends StatefulWidget {
  const DailyDevotionalScreenTabletView({super.key});

  @override
  State<DailyDevotionalScreenTabletView> createState() =>
      _DailyDevotionalScreenTabletViewState();
}

class _DailyDevotionalScreenTabletViewState
    extends State<DailyDevotionalScreenTabletView> {
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
            showCustomToast(context, 'Correct! Great job!');
          } else {
            showCustomToast(context, 'Keep studying the Word!');
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
              'Daily Reading',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Neuland',
                fontSize: 18.sp,
              ),
            ),
            actions: const [],
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
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600.w),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Completed today banner
              if (state.hasCompletedToday && !state.hasAnswered)
                const _CompletedBannerTablet()
                    .animate()
                    .fadeIn(duration: 400.ms),

              // Passage card
              _PassageCardTablet(
                passage: state.passage,
                passageText: state.passageText,
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),

              SizedBox(height: 20.h),

              // Reflection card
              _ReflectionCardTablet(reflection: state.reflection)
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 100.ms)
                  .slideY(begin: 0.2, end: 0),

              SizedBox(height: 24.h),

              // Question section
              if (!state.hasCompletedToday || state.hasAnswered)
                _QuestionSectionTablet(state: state).animate().fadeIn(
                      duration: 500.ms,
                      delay: 200.ms,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompletedBannerTablet extends StatelessWidget {
  const _CompletedBannerTablet();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.correctAnswer.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.correctAnswer, width: 1.5),
      ),
      child: Row(
        children: [
          Text('✅', style: TextStyle(fontSize: 22.sp)),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Completed today!',
                  style: TextStyle(
                    color: AppColors.correctAnswer,
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                ),
                Text(
                  'Come back tomorrow for a new devotional.',
                  style: TextStyle(color: Colors.white70, fontSize: 13.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PassageCardTablet extends StatelessWidget {
  final String passage;
  final String passageText;
  const _PassageCardTablet(
      {required this.passage, required this.passageText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
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
              Text('📖', style: TextStyle(fontSize: 20.sp)),
              SizedBox(width: 10.w),
              Text(
                passage,
                style: TextStyle(
                  color: AppColors.accentColor,
                  fontFamily: 'Neuland',
                  fontSize: 17.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Text(
            passageText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              height: 1.7,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReflectionCardTablet extends StatelessWidget {
  final String reflection;
  const _ReflectionCardTablet({required this.reflection});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.slateBlue,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reflection',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Neuland',
              fontSize: 15.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            reflection,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14.sp,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionSectionTablet extends StatelessWidget {
  final DailyDevotionalState state;
  const _QuestionSectionTablet({required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Question',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Neuland',
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.navyBlue,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            state.question,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
              height: 1.5,
            ),
          ),
        ),
        SizedBox(height: 14.h),
        ...List.generate(state.options.length, (index) {
          return _OptionTileTablet(
            text: state.options[index],
            index: index,
            state: state,
          );
        }),
        if (state.hasAnswered) ...[
          SizedBox(height: 10.h),
          _PostAnswerMessageTablet(isCorrect: state.isCorrect == true),
        ],
        SizedBox(height: 24.h),
      ],
    );
  }
}

class _OptionTileTablet extends StatelessWidget {
  final String text;
  final int index;
  final DailyDevotionalState state;

  const _OptionTileTablet(
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
        bgColor = AppColors.correctAnswer.withValues(alpha: 0.2);
        borderColor = AppColors.correctAnswer;
      } else if (index == state.selectedOptionIndex) {
        bgColor = AppColors.wrongAnswer.withValues(alpha: 0.2);
        borderColor = AppColors.wrongAnswer;
        textColor = Colors.white70;
      } else {
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
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 30.w,
                height: 30.w,
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
                      fontSize: 13.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              if (state.hasAnswered && text == state.answer)
                Text('✅', style: TextStyle(fontSize: 16.sp)),
              if (state.hasAnswered &&
                  index == state.selectedOptionIndex &&
                  text != state.answer)
                Text('❌', style: TextStyle(fontSize: 16.sp)),
            ],
          ),
        ),
      ),
    );
  }
}

class _PostAnswerMessageTablet extends StatelessWidget {
  final bool isCorrect;
  const _PostAnswerMessageTablet({required this.isCorrect});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
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
            isCorrect
                ? 'Well done!'
                : 'The correct answer is highlighted above',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Come back tomorrow for a new devotional!',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.3, end: 0);
  }
}
