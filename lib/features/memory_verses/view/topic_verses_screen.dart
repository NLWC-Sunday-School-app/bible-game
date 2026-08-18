import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:bible_game/features/memory_verses/bloc/memory_verses_cubit.dart';
import 'package:bible_game/features/memory_verses/model/memory_verse.dart';
import 'package:bible_game/features/memory_verses/view/memory_verses_screen.dart';
import 'package:bible_game/features/memory_verses/widget/practice_text.dart';
import 'package:bible_game/shared/constants/colors.dart';
import 'package:bible_game/shared/widgets/custom_toast.dart';

class TopicVersesScreen extends StatefulWidget {
  const TopicVersesScreen({super.key});

  @override
  State<TopicVersesScreen> createState() => _TopicVersesScreenState();
}

class _TopicVersesScreenState extends State<TopicVersesScreen> {
  final PageController _pageController = PageController();
  PracticeLevel _level = PracticeLevel.read;
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topicId = ModalRoute.of(context)!.settings.arguments as String;

    return BlocBuilder<MemoryVersesCubit, MemoryVersesState>(
      builder: (context, state) {
        final topic = state.topics.firstWhere(
          (t) => t.id == topicId,
          orElse: () => const VerseTopic(
              id: '', name: '', tagline: '', verses: []),
        );
        final style = TopicStyle.of(topic.id);

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
              '${style.emoji} ${topic.name}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 19.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            centerTitle: true,
          ),
          body: topic.verses.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white))
              : Column(
                  children: [
                    _LevelSelector(
                      level: _level,
                      onChanged: (l) => setState(() => _level = l),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: topic.verses.length,
                        onPageChanged: (i) =>
                            setState(() => _currentPage = i),
                        itemBuilder: (context, index) {
                          final verse = topic.verses[index];
                          return _VerseCard(
                            verse: verse,
                            style: style,
                            level: _level,
                            isMemorized:
                                state.memorizedRefs.contains(verse.reference),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 24.h, top: 8.h),
                      child: Text(
                        '${_currentPage + 1} / ${topic.verses.length}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _LevelSelector extends StatelessWidget {
  final PracticeLevel level;
  final ValueChanged<PracticeLevel> onChanged;

  const _LevelSelector({required this.level, required this.onChanged});

  static const _labels = {
    PracticeLevel.read: '📖 Read',
    PracticeLevel.fillBlanks: '✏️ Fill blanks',
    PracticeLevel.firstLetters: '🧠 First letters',
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      child: Row(
        children: [
          for (final l in PracticeLevel.values)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(l),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  padding: EdgeInsets.symmetric(vertical: 9.h),
                  decoration: BoxDecoration(
                    color: level == l
                        ? const Color(0xFFFFD97B)
                        : Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    _labels[l]!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: level == l
                          ? const Color(0xFF3D2E00)
                          : Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _VerseCard extends StatelessWidget {
  final MemoryVerse verse;
  final TopicStyle style;
  final PracticeLevel level;
  final bool isMemorized;

  const _VerseCard({
    required this.verse,
    required this.style,
    required this.level,
    required this.isMemorized,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: style.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.25),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Text(
                '${verse.reference} · KJV',
                style: TextStyle(
                  color: const Color(0xFFFFD97B),
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Expanded(
              child: SingleChildScrollView(
                child: PracticeText(text: verse.text, level: level),
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ActionButton(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  onTap: () => Share.share(
                      '"${verse.text}" — ${verse.reference} (KJV)'),
                ),
                _ActionButton(
                  icon: isMemorized
                      ? Icons.check_circle
                      : Icons.check_circle_outline,
                  label: isMemorized ? 'Memorized!' : 'I know it',
                  highlighted: isMemorized,
                  onTap: () {
                    context
                        .read<MemoryVersesCubit>()
                        .toggleMemorized(verse.reference);
                    if (!isMemorized) {
                      showCustomToast(
                          context, '🎉 ${verse.reference} memorized!');
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool highlighted;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: highlighted
              ? const Color(0xFFFFD97B)
              : Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 18.sp,
                color: highlighted ? const Color(0xFF3D2E00) : Colors.white),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: highlighted ? const Color(0xFF3D2E00) : Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
