import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/data/bible_facts.dart';
import 'package:bible_game/shared/data/church_history_facts.dart';

/// A locally-powered carousel that displays Bible facts, church history,
/// geography tidbits, and character spotlights — all stored on device.
class DidYouKnowCarousel extends StatelessWidget {
  const DidYouKnowCarousel({super.key});

  static final List<Map<String, String>> _allFacts = [
    // Church history facts (wrap them in the same map shape)
    ...ChurchHistoryFacts.facts.map((f) => {
          'category': 'Church History',
          'icon': '⛪',
          'fact': f,
        }),
    // Bible facts (already the right shape)
    ...BibleFacts.facts,
  ];

  @override
  Widget build(BuildContext context) {
    // Shuffle once per build so the order feels fresh each visit
    final shuffled = List<Map<String, String>>.from(_allFacts)..shuffle(Random());
    // Show a random subset of 15 cards so it doesn't feel endless
    final cards = shuffled.take(15).toList();

    return CarouselSlider.builder(
      itemCount: cards.length,
      itemBuilder: (context, index, _) => _FactCard(data: cards[index]),
      options: CarouselOptions(
        height: 200.h,
        viewportFraction: 0.85,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.2,
      ),
    );
  }
}

// ─── Individual fact card ────────────────────────────────────────────────────

const _categoryGradients = <String, List<Color>>{
  'Bible Numbers': [Color(0xFF1A237E), Color(0xFF283593)],
  'Bible Geography': [Color(0xFF004D40), Color(0xFF00695C)],
  'Fun Fact': [Color(0xFF4A148C), Color(0xFF6A1B9A)],
  'Character Spotlight': [Color(0xFFBF360C), Color(0xFFD84315)],
  'Bible & Language': [Color(0xFF01579B), Color(0xFF0277BD)],
  'Church History': [Color(0xFF33691E), Color(0xFF558B2F)],
};

class _FactCard extends StatelessWidget {
  const _FactCard({required this.data});
  final Map<String, String> data;

  @override
  Widget build(BuildContext context) {
    final category = data['category'] ?? 'Fun Fact';
    final icon = data['icon'] ?? '💡';
    final fact = data['fact'] ?? '';
    final colors = _categoryGradients[category] ??
        const [Color(0xFF37474F), Color(0xFF455A64)];

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: colors[0].withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row: icon + category + "Did you know?" ──
            Row(
              children: [
                Text(icon, style: TextStyle(fontSize: 20.sp)),
                SizedBox(width: 8.w),
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white70,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Did you know?',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.white60,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            // ── Fact text ──
            Expanded(
              child: Text(
                fact,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.white,
                  height: 1.45,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
