import 'package:bible_game/features/memory_verses/model/memory_verse.dart';
import 'package:bible_game/shared/features/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../../shared/features/settings/bloc/settings_bloc.dart';

/// Lets the user tick the topics their verses come from. Resolves to the
/// chosen topic ids in file order, or null when dismissed or cancelled.
Future<List<String>?> showVerseTopicsModal(
  BuildContext context, {
  required List<VerseTopic> topics,
  required List<String> selected,
}) {
  return showGeneralDialog<List<String>>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Verse topics',
    barrierColor: Colors.black.withValues(alpha: 0.7),
    transitionDuration: const Duration(milliseconds: 380),
    pageBuilder: (_, __, ___) =>
        VerseTopicsModal(topics: topics, selected: selected),
    transitionBuilder: (_, animation, __, child) {
      final scale = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeIn);
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
            scale: Tween(begin: 0.85, end: 1.0).animate(scale), child: child),
      );
    },
  );
}

class VerseTopicsModal extends StatefulWidget {
  const VerseTopicsModal(
      {super.key, required this.topics, required this.selected});

  final List<VerseTopic> topics;
  final List<String> selected;

  @override
  State<VerseTopicsModal> createState() => _VerseTopicsModalState();
}

class _VerseTopicsModalState extends State<VerseTopicsModal> {
  // The blue panel of the log-out and quit dialogs.
  static const _panelTop = Color(0xFF1565C0);
  static const _panelMid = Color(0xFF0C2244);
  static const _panelBottom = Color(0xFF071832);
  static const _rim = Color(0xFF5AA0F0);
  static const _glow = Color(0xFF4A9EFF);
  static const _titleStroke = Color(0xFF042A6B);

  late final Set<String> _chosen = {
    for (final t in widget.topics)
      if (widget.selected.isEmpty || widget.selected.contains(t.id)) t.id,
  };

  bool get _allChosen => _chosen.length == widget.topics.length;

  void _toggle(String id) {
    // At least one topic stays ticked: no topics would mean no verses.
    if (_chosen.contains(id) && _chosen.length == 1) {
      HapticFeedback.heavyImpact();
      return;
    }
    HapticFeedback.selectionClick();
    setState(() => _chosen.contains(id) ? _chosen.remove(id) : _chosen.add(id));
  }

  void _selectAll() {
    HapticFeedback.selectionClick();
    setState(() => _chosen.addAll(widget.topics.map((t) => t.id)));
  }

  void _close(List<String>? result) {
    context.read<SettingsBloc>().soundManager.playClickSound();
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalization.tr(context);

    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: _rim.withValues(alpha: 0.6), width: 2),
              boxShadow: [
                BoxShadow(
                  color: _glow.withValues(alpha: 0.35),
                  blurRadius: 28,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 4,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22.r),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 16.h),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [_panelTop, _panelMid, _panelBottom],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StrokeText(
                      text: tr.t('profile_verse_topics'),
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                      ),
                      strokeColor: _titleStroke,
                      strokeWidth: 4,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      tr.t('verse_topics_message'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                    SizedBox(height: 18.h),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        for (final topic in widget.topics)
                          _TopicChip(
                            label: topic.name,
                            selected: _chosen.contains(topic.id),
                            onTap: () => _toggle(topic.id),
                          ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    // Kept in the layout when hidden so the panel doesn't
                    // jump as the last topic is ticked.
                    Visibility(
                      visible: !_allChosen,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: TextButton(
                        onPressed: _allChosen ? null : _selectAll,
                        child: Text(
                          tr.t('verse_topics_select_all'),
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF9CC8FF),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    _SaveButton(
                      label: tr.t('verse_topics_save'),
                      onTap: () => _close([
                        for (final t in widget.topics)
                          if (_chosen.contains(t.id)) t.id,
                      ]),
                    ),
                    SizedBox(height: 4.h),
                    TextButton(
                      onPressed: () => _close(null),
                      child: Text(
                        tr.t('verse_topics_cancel'),
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip(
      {required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF366ABC)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: selected
                ? const Color(0xFF9CC8FF)
                : Colors.white.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              size: 16.sp,
              color: selected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.45),
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: selected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF4A90D9), Color(0xFF366ABC)],
          ),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF366ABC).withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
