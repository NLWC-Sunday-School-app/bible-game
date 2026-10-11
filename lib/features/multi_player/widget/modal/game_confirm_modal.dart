import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../../shared/features/settings/bloc/settings_bloc.dart';
import '../multiplayer_button.dart';

enum GameConfirmChoice { primary, secondary }

/// A two-way question in the waiting room's own look -- cream panel, red rim,
/// hard drop shadow, outlined title, the green Start Game button -- rather
/// than a system alert dropped over a game.
///
/// The primary choice is the safe one and sits on the big green button; the
/// secondary is the destructive one and is deliberately smaller. Resolves to
/// null when dismissed, which callers treat as "do nothing".
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

  static const _cream = Color(0xFFFFEED6);
  static const _rim = Color(0xFFDB0C34);
  static const _rimShadow = Color(0xFF94142E);
  static const _blue = Color(0xFF014CA3);
  static const _ink = Color(0xFF122F52);

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
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                margin: EdgeInsets.only(top: badgeSize / 2),
                padding: EdgeInsets.fromLTRB(
                    20.w, badgeSize / 2 + 12.h, 20.w, 20.h),
                decoration: BoxDecoration(
                  color: _cream,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: _rim, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: _rimShadow,
                      offset: Offset(2, 6),
                      blurRadius: 0,
                      spreadRadius: -1,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StrokeText(
                      text: title,
                      textAlign: TextAlign.center,
                      textStyle: TextStyle(
                        color: _blue,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w900,
                      ),
                      strokeColor: Colors.white,
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
                        color: _ink.withValues(alpha: 0.75),
                      ),
                    ),
                    if (code != null && code!.isNotEmpty) ...[
                      SizedBox(height: 14.h),
                      _CodeChip(code: code!),
                    ],
                    SizedBox(height: 22.h),
                    MultiplayerButton(
                      buttonText: primaryLabel,
                      buttonIsLoading: false,
                      width: 260.w,
                      onTap: () => _choose(context, GameConfirmChoice.primary),
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
              // The badge sits across the panel's top edge.
              Container(
                height: badgeSize,
                width: badgeSize,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: _rim, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: _rimShadow,
                      offset: Offset(0, 4),
                      blurRadius: 0,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(10.r),
                child: Image.asset(badgeAsset, fit: BoxFit.contain),
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.6),
        border: Border.all(color: const Color(0xFFD8B98C)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        code,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
          color: GameConfirmModal._blue,
        ),
      ),
    );
  }
}

/// Red and chunky like the game's close buttons, but smaller than the green
/// one above it: the choice you can't take back should not be the easy target.
class _SecondaryButton extends StatefulWidget {
  const _SecondaryButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<_SecondaryButton> {
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 90),
        margin: EdgeInsets.only(top: _pressed ? 3 : 0),
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: GameConfirmModal._rim,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: GameConfirmModal._rimShadow,
              offset: Offset(0, _pressed ? 0 : 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
