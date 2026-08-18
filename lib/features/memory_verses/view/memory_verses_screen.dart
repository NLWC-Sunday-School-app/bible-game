import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/features/memory_verses/bloc/memory_verses_cubit.dart';
import 'package:bible_game/features/memory_verses/model/memory_verse.dart';
import 'package:bible_game/shared/constants/app_routes.dart';
import 'package:bible_game/shared/constants/colors.dart';

/// Visual identity for each topic card.
class TopicStyle {
  final List<Color> gradient;
  final String emoji;
  const TopicStyle(this.gradient, this.emoji);

  static const Map<String, TopicStyle> styles = {
    'healing': TopicStyle([Color(0xFF2E9E6B), Color(0xFF14563A)], '🌿'),
    'faith': TopicStyle([Color(0xFF4A7BD4), Color(0xFF1F3A75)], '⛰️'),
    'peace': TopicStyle([Color(0xFF53B8C4), Color(0xFF20616B)], '🕊️'),
    'fear_anxiety': TopicStyle([Color(0xFF8A63C9), Color(0xFF44286F)], '🛡️'),
    'provision': TopicStyle([Color(0xFFD69440), Color(0xFF7A4E13)], '🍞'),
    'salvation': TopicStyle([Color(0xFFC95D63), Color(0xFF6E2226)], '✝️'),
    'strength': TopicStyle([Color(0xFF5E7A8F), Color(0xFF2B3D4A)], '💪'),
    'love': TopicStyle([Color(0xFFD4608F), Color(0xFF77264C)], '❤️'),
  };

  static TopicStyle of(String topicId) =>
      styles[topicId] ??
      const TopicStyle([Color(0xFF6B4C9A), Color(0xFF2E1A52)], '📖');
}

class MemoryVersesScreen extends StatefulWidget {
  const MemoryVersesScreen({super.key});

  @override
  State<MemoryVersesScreen> createState() => _MemoryVersesScreenState();
}

class _MemoryVersesScreenState extends State<MemoryVersesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<MemoryVersesCubit>().load();
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
          'Memory Verses',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<MemoryVersesCubit, MemoryVersesState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Pick a topic, hide the words, and hide the Word in your heart 💛',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 13.sp,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14.h,
                    crossAxisSpacing: 14.w,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: state.topics.length,
                  itemBuilder: (context, index) {
                    final topic = state.topics[index];
                    return _TopicCard(
                      topic: topic,
                      memorizedCount: state.memorizedCountFor(topic),
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

class _TopicCard extends StatelessWidget {
  final VerseTopic topic;
  final int memorizedCount;

  const _TopicCard({required this.topic, required this.memorizedCount});

  @override
  Widget build(BuildContext context) {
    final style = TopicStyle.of(topic.id);
    final progress =
        topic.verses.isEmpty ? 0.0 : memorizedCount / topic.verses.length;

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.memoryVerseTopicScreen,
        arguments: topic.id,
      ),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: style.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(style.emoji, style: TextStyle(fontSize: 28.sp)),
            const Spacer(),
            Text(
              topic.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              topic.tagline,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 11.sp,
              ),
            ),
            SizedBox(height: 10.h),
            ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5.h,
                backgroundColor: Colors.black.withOpacity(0.25),
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFFFFD97B)),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              '$memorizedCount/${topic.verses.length} memorized',
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
