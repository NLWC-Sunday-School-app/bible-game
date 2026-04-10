import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/data/bible_facts.dart';
import 'package:bible_game/shared/data/church_history_facts.dart';
import 'package:bible_game/shared/features/localization/app_localization.dart';

/// A locally-powered carousel that displays Bible facts, church history,
/// geography tidbits, and character spotlights — all stored on device.
class DidYouKnowCarousel extends StatelessWidget {
  const DidYouKnowCarousel({super.key});

  static final List<Map<String, String>> _allFacts = [
    ...ChurchHistoryFacts.facts.map((f) => {
          'category': 'Church History',
          'icon': '⛪',
          'fact': f,
        }),
    ...BibleFacts.facts,
  ];

  @override
  Widget build(BuildContext context) {
    final shuffled = List<Map<String, String>>.from(_allFacts)..shuffle(Random());
    final cards = shuffled.take(15).toList();

    return CarouselSlider.builder(
      itemCount: cards.length,
      itemBuilder: (context, index, _) => _FactCard(data: cards[index]),
      options: CarouselOptions(
        height: 155.h,
        viewportFraction: 0.88,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.15,
      ),
    );
  }
}

// ─── Category styles ────────────────────────────────────────────────────────

class _CategoryStyle {
  final Color bg;
  final Color accent;
  final Color shadow;
  const _CategoryStyle(this.bg, this.accent, this.shadow);
}

const _categoryStyles = <String, _CategoryStyle>{
  'Bible Numbers': _CategoryStyle(
      Color(0xFF1E2A3A), Color(0xFFFFB74D), Color(0xFF0D1B2A)),
  'Bible Geography': _CategoryStyle(
      Color(0xFF1A2E1A), Color(0xFF66BB6A), Color(0xFF0D1B0D)),
  'Fun Fact': _CategoryStyle(
      Color(0xFF251A30), Color(0xFFCE93D8), Color(0xFF1A0D25)),
  'Character Spotlight': _CategoryStyle(
      Color(0xFF2A1A15), Color(0xFFFF8A65), Color(0xFF1B0D0A)),
  'Bible & Language': _CategoryStyle(
      Color(0xFF152035), Color(0xFF64B5F6), Color(0xFF0D1525)),
  'Church History': _CategoryStyle(
      Color(0xFF152525), Color(0xFF4DB6AC), Color(0xFF0D1A1A)),
};

class _FactCard extends StatelessWidget {
  const _FactCard({required this.data});
  final Map<String, String> data;

  static const _categoryKeyMap = <String, String>{
    'Bible Numbers': 'category_bible_numbers',
    'Bible Geography': 'category_bible_geography',
    'Fun Fact': 'category_fun_fact',
    'Character Spotlight': 'category_character_spotlight',
    'Bible & Language': 'category_bible_language',
    'Church History': 'category_church_history',
  };

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalization.tr(context);
    final category = data['category'] ?? 'Fun Fact';
    final localizedCategory = tr.t(_categoryKeyMap[category] ?? category);
    final icon = data['icon'] ?? '💡';
    final fact = data['fact'] ?? '';
    final style = _categoryStyles[category] ??
        const _CategoryStyle(
            Color(0xFFF5F5F5), Color(0xFF546E7A), Color(0xFF37474F));

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: style.bg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: style.accent.withValues(alpha: 0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: style.shadow.withValues(alpha: 0.20),
            offset: const Offset(0, 4),
            blurRadius: 0,
            spreadRadius: -1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            // ── Large watermark "?" ──
            Positioned(
              right: -10.w,
              bottom: -15.h,
              child: Text(
                '?',
                style: TextStyle(
                  fontSize: 100.sp,
                  fontWeight: FontWeight.w900,
                  color: style.accent.withValues(alpha: 0.06),
                ),
              ),
            ),
            // ── Accent stripe on the left ──
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 5.w,
                color: style.accent,
              ),
            ),
            // ── Content ──
            Padding(
              padding: EdgeInsets.only(
                  left: 16.w, right: 14.w, top: 12.h, bottom: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: style.accent.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(icon, style: TextStyle(fontSize: 16.sp)),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          localizedCategory,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                            color: style.accent,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: style.accent,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          tr.t('did_you_know'),
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  // ── Fact text ──
                  Expanded(
                    child: Text(
                      fact,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withValues(alpha: 0.85),
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
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
