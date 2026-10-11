import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../../shared/features/settings/bloc/settings_bloc.dart';

enum GameConfirmChoice { primary, secondary }

/// A two-way question in the app's own dialog style -- the deep-blue panel of
/// the log-out and quit dialogs -- rather than a system alert dropped over a
/// game.
///
/// The primary choice is the safe one and gets the only filled button; the
/// secondary is the destructive one and stays quiet, as Quit does in the quit
/// dialog. One colour family throughout: a second accent on the buttons is
/// what made the earlier cream, red and green version clash. Resolves to null
/// when dismissed, which callers treat as "do nothing".
Future<GameConfirmChoice?> showGameConfirmModal(
  BuildContext context, {
  required String badgeAsset,
  required String title,
  required String message,
  String? code,
  required String primaryLabel,
  required String secondaryLabel,
}) {
  return showGeneralDialog<GameConfirmChoice>(
    context: context,
    barrierDismissible: true,
    barrierLabel: title,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    transitionDuration: const Duration(milliseconds: 380),
    pageBuilder: (_, __, ___) => GameConfirmModal(
      badgeAsset: badgeAsset,
      title: title,
      message: message,
      code: code,
      primaryLabel: primaryLabel,
      secondaryLabel: secondaryLabel,
    ),
    // Pops in with a little overshoot, the way the game's own cards land.
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

class GameConfirmModal extends StatelessWidget {
  const GameConfirmModal({
    super.key,
    required this.badgeAsset,
    required this.title,
    required this.message,
    this.code,
    required this.primaryLabel,
    required this.secondaryLabel,
  });

  /// Art for the badge across the top edge -- the game mode's own icon.
  final String badgeAsset;
  final String title;
  final String message;

  /// Shown as its own chip, so the one thing worth remembering stands out
  /// from the sentence around it.
  final String? code;
  final String primaryLabel;
  final String secondaryLabel;

  // The log-out dialog's panel, rim and glow.
  static const _panelTop = Color(0xFF1565C0);
  static const _panelMid = Color(0xFF0C2244);
  static const _panelBottom = Color(0xFF071832);
  static const _rim = Color(0xFF5AA0F0);
  static const _glow = Color(0xFF4A9EFF);
  static const _titleStroke = Color(0xFF042A6B);

  void _choose(BuildContext context, GameConfirmChoice choice) {
    context.read<SettingsBloc>().soundManager.playClickSound();
    Navigator.of(context).pop(choice);
  }

  @override
  Widget build(BuildContext context) {
    final badgeSize = 64.r;

    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: EdgeInsets.only(top: badgeSize / 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                      color: _rim.withValues(alpha: 0.6), width: 2),
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
                    padding: EdgeInsets.fromLTRB(
                        22.w, badgeSize / 2 + 14.h, 22.w, 18.h),
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
                          text: title,
                          textAlign: TextAlign.center,
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w900,
                          ),
                          strokeColor: _titleStroke,
                          strokeWidth: 4,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        if (code != null && code!.isNotEmpty) ...[
                          SizedBox(height: 16.h),
                          _CodeChip(code: code!),
                        ],
                        SizedBox(height: 24.h),
                        _PrimaryButton(
                          label: primaryLabel,
                          onTap: () =>
                              _choose(context, GameConfirmChoice.primary),
                        ),
                        SizedBox(height: 10.h),
                        _SecondaryButton(
                          label: secondaryLabel,
                          onTap: () =>
                              _choose(context, GameConfirmChoice.secondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // The badge sits across the panel's top edge.
              Container(
                height: badgeSize,
                width: badgeSize,
                padding: EdgeInsets.all(3.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _panelTop,
                  border: Border.all(color: _rim, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: _glow.withValues(alpha: 0.45),
                      blurRadius: 14,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: _panelMid,
                  ),
                  child: Image.asset(badgeAsset, fit: BoxFit.contain),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CodeChip extends StatelessWidget {
  const _CodeChip({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        code,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Sinks under the finger, like the game's other buttons.
class _Pressable extends StatefulWidget {
  const _Pressable({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  State<_Pressable> createState() => _PressableState();
}

class _PressableState extends State<_Pressable> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 90),
        child: widget.child,
      ),
    );
  }
}

/// The quit dialog's Keep Playing button: the one filled, bright choice.
class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Pressable(
      onTap: onTap,
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

/// The quit dialog's Quit button: outlined and muted, so the choice that
/// can't be undone is never the one that catches the eye.
class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _Pressable(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 13.h),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }
}
