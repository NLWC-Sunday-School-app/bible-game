import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/constants/app_routes.dart';
import 'package:bible_game/shared/constants/colors.dart';
import '../bloc/story_mode_bloc.dart';

class StorySelectionScreen extends StatefulWidget {
  const StorySelectionScreen({super.key});

  @override
  State<StorySelectionScreen> createState() => _StorySelectionScreenState();
}

class _StorySelectionScreenState extends State<StorySelectionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<StoryModeBloc>().add(LoadStoryArcs());
  }

  @override
  Widget build(BuildContext context) {
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
          'Story Mode',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Neuland',
            fontSize: 20.sp,
          ),
        ),
      ),
      body: BlocBuilder<StoryModeBloc, StoryModeState>(
        builder: (context, state) {
          if (!state.isLoaded) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Text(
                  'Choose a story to explore',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: state.arcs.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final arc = state.arcs[index];
                    final arcId = arc['id'] as String;
                    final chapters = arc['chapters'] as List;
                    final completedCount = chapters.where((c) {
                      return state.isChapterCompleted(
                          arcId, (c as Map)['id'] as String);
                    }).length;
                    final totalStars = chapters.fold<int>(0, (sum, c) {
                      return sum + state.starsForChapter(
                          arcId, (c as Map)['id'] as String);
                    });
                    final maxStars = chapters.length * 3;

                    return _StoryArcCard(
                      arc: arc,
                      completedChapters: completedCount,
                      totalChapters: chapters.length,
                      totalStars: totalStars,
                      maxStars: maxStars,
                      onTap: () {
                        context
                            .read<StoryModeBloc>()
                            .add(SelectStory(arcId: arcId));
                        Navigator.pushNamed(
                            context, AppRoutes.chapterMapScreen);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StoryArcCard extends StatelessWidget {
  final Map<String, dynamic> arc;
  final int completedChapters;
  final int totalChapters;
  final int totalStars;
  final int maxStars;
  final VoidCallback onTap;

  const _StoryArcCard({
    required this.arc,
    required this.completedChapters,
    required this.totalChapters,
    required this.totalStars,
    required this.maxStars,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isComplete = maxStars > 0 && totalStars == maxStars;
    final progress = maxStars > 0 ? totalStars / maxStars : 0.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.navyBlue,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isComplete
                ? AppColors.correctAnswer
                : AppColors.accentColor.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    arc['title'] as String,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Neuland',
                      fontSize: 16.sp,
                    ),
                  ),
                ),
                // Stars badge
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isComplete
                        ? AppColors.correctAnswer.withValues(alpha: 0.2)
                        : AppColors.accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '★ $totalStars / $maxStars',
                    style: TextStyle(
                      color: isComplete
                          ? AppColors.correctAnswer
                          : const Color(0xFFFFD700),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              arc['description'] as String,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white60,
                fontSize: 12.sp,
                height: 1.4,
              ),
            ),
            SizedBox(height: 12.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white12,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isComplete ? AppColors.correctAnswer : AppColors.accentColor,
                ),
                minHeight: 6.h,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              '$completedChapters/$totalChapters chapters completed',
              style: TextStyle(color: Colors.white38, fontSize: 11.sp),
            ),
          ],
        ),
      ),
    );
  }
}
