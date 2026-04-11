import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/constants/app_routes.dart';
import 'package:bible_game/shared/constants/colors.dart';
import '../../bloc/story_mode_bloc.dart';

class ChapterMapScreenTabletView extends StatelessWidget {
  const ChapterMapScreenTabletView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryModeBloc, StoryModeState>(
      builder: (context, state) {
        final arc = state.arcs.firstWhere(
          (a) => a['id'] == state.selectedArcId,
          orElse: () => {},
        );
        if (arc.isEmpty) return const SizedBox.shrink();

        final chapters = arc['chapters'] as List;

        final totalArcStars = chapters.fold<int>(0, (sum, c) {
          return sum +
              state.starsForChapter(
                  state.selectedArcId, (c as Map)['id'] as String);
        });
        final maxArcStars = chapters.length * 3;

        return Scaffold(
          backgroundColor: AppColors.primaryDarkBackground,
          appBar: AppBar(
            backgroundColor: AppColors.primaryDarkBackground,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    arc['title'] as String,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Neuland',
                      fontSize: 16.sp,
                    ),
                    maxLines: 1,
                  ),
                ),
                Text(
                  '\u2605 $totalArcStars / $maxArcStars',
                  style: TextStyle(
                    color: const Color(0xFFFFD700),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 650.w),
              child: GridView.builder(
                padding: EdgeInsets.all(16.w),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14.w,
                  mainAxisSpacing: 14.h,
                  childAspectRatio: 2.4,
                ),
                itemCount: chapters.length,
                itemBuilder: (context, index) {
                  final chapter = chapters[index] as Map<String, dynamic>;
                  final chapterId = chapter['id'] as String;
                  final starsEarned =
                      state.starsForChapter(state.selectedArcId, chapterId);
                  final isUnlocked = state.isChapterUnlocked(
                      state.selectedArcId, chapters, index);
                  final questions = chapter['questions'] as List;

                  return _ChapterTileTablet(
                    chapter: chapter,
                    index: index,
                    starsEarned: starsEarned,
                    isUnlocked: isUnlocked,
                    totalQuestions: questions.length,
                    requiredCorrect: chapter['requiredCorrect'] as int,
                    onTap: isUnlocked
                        ? () {
                            context.read<StoryModeBloc>().add(
                                SelectChapter(chapterId: chapterId));
                            Navigator.pushNamed(
                                context, AppRoutes.storyQuestionScreen);
                          }
                        : null,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ChapterTileTablet extends StatelessWidget {
  final Map<String, dynamic> chapter;
  final int index;
  final int starsEarned;
  final bool isUnlocked;
  final int totalQuestions;
  final int requiredCorrect;
  final VoidCallback? onTap;

  const _ChapterTileTablet({
    required this.chapter,
    required this.index,
    required this.starsEarned,
    required this.isUnlocked,
    required this.totalQuestions,
    required this.requiredCorrect,
    this.onTap,
  });

  bool get isCompleted => starsEarned >= 1;

  Widget _buildStars(int earned) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (i) => Icon(
          i < earned ? Icons.star_rounded : Icons.star_outline_rounded,
          color: i < earned ? const Color(0xFFFFD700) : Colors.white24,
          size: 16.sp,
        ),
      ),
    );
  }

  Widget _buildDifficultyBadge() {
    final difficulty = chapter['difficulty'] as String?;
    if (difficulty == null) return const SizedBox.shrink();
    Color badgeColor;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        badgeColor = Colors.green;
        break;
      case 'medium':
        badgeColor = Colors.orange;
        break;
      case 'hard':
        badgeColor = Colors.red;
        break;
      default:
        badgeColor = Colors.blueGrey;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.2),
        border:
            Border.all(color: badgeColor.withValues(alpha: 0.7), width: 1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          color: badgeColor,
          fontSize: 9.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color bgColor;
    Color textColor;

    if (isCompleted) {
      borderColor = AppColors.correctAnswer;
      bgColor = AppColors.correctAnswer.withValues(alpha: 0.1);
      textColor = Colors.white;
    } else if (isUnlocked) {
      borderColor = AppColors.accentColor;
      bgColor = AppColors.navyBlue;
      textColor = Colors.white;
    } else {
      borderColor = Colors.white12;
      bgColor = Colors.white.withValues(alpha: 0.03);
      textColor = Colors.white38;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? AppColors.correctAnswer
                    : isUnlocked
                        ? AppColors.accentColor
                        : Colors.white12,
              ),
              child: Center(
                child: isCompleted
                    ? Text(
                        '\u2605$starsEarned',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      )
                    : isUnlocked
                        ? Icon(Icons.play_arrow_rounded,
                            color: AppColors.darkBrownText, size: 22.sp)
                        : Icon(Icons.lock,
                            color: Colors.white38, size: 18.sp),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          chapter['title'] as String,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: textColor,
                            fontFamily: 'Neuland',
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                      if (isCompleted) ...[
                        SizedBox(width: 6.w),
                        Text(
                          '\u27F3 Replay',
                          style: TextStyle(
                            color: AppColors.accentColor,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                      SizedBox(width: 6.w),
                      _buildDifficultyBadge(),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  if (isCompleted) ...[
                    Row(
                      children: [
                        _buildStars(starsEarned),
                        SizedBox(width: 6.w),
                        Text(
                          'Best: $starsEarned/3 stars',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ] else
                    Text(
                      isUnlocked
                          ? '$totalQuestions questions \u2022 Pass $requiredCorrect/$totalQuestions'
                          : 'Complete previous chapter to unlock',
                      style: TextStyle(
                        color: isUnlocked ? Colors.white54 : Colors.white24,
                        fontSize: 11.sp,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
