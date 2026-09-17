import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/constants/app_routes.dart';
import '../../../../shared/features/multiplayer/cubit/websocket_cubit.dart';
import '../multiplayer_quick_tips.dart';

/// The Quick Tips, shown for the whole gap between GAME_STARTED and the first
/// question, then routing into the game.
///
/// It used to open three seconds into a six second gap and hold for the other
/// three, which is not long enough to read three tips -- the complaint was
/// that it flashed. It now takes the whole gap, so there is time to read
/// without anyone waiting longer than they already did.
///
/// The duration is fixed and there is no skip. That is deliberate: the
/// per-question clock starts when each player's question screen mounts, so a
/// button would let whoever tapped fastest start answering while others were
/// still reading -- in a mode whose own advice is that speed wins. Fixed means
/// everyone starts together, which is what happens today.
void showMultiplayerTipsModal(
  BuildContext context, {
  required String gameMode,
  required int secondsPerQuestion,
  Duration duration = const Duration(seconds: 8),
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (BuildContext context) => _MultiplayerTips(
      gameMode: gameMode,
      secondsPerQuestion: secondsPerQuestion,
      duration: duration,
    ),
  );
}

class _MultiplayerTips extends StatefulWidget {
  const _MultiplayerTips({
    required this.gameMode,
    required this.secondsPerQuestion,
    required this.duration,
  });

  final String gameMode;
  final int secondsPerQuestion;
  final Duration duration;

  @override
  State<_MultiplayerTips> createState() => _MultiplayerTipsState();
}

class _MultiplayerTipsState extends State<_MultiplayerTips> {
  Timer? _ticker;
  late int _remaining = widget.duration.inSeconds;
  bool _routed = false;

  @override
  void initState() {
    super.initState();
    // One timer drives both the countdown and the start, so the number on
    // screen cannot disagree with when the game actually begins.
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_remaining > 0) _remaining--;
      });
      _maybeStart();
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  bool get _questionsReady =>
      context.read<WebsocketCubit>().state.questionData.isNotEmpty;

  /// Two conditions, not one: the tips have had their time *and* there are
  /// questions to show. They usually arrive with the GAME_STARTED frame that
  /// routed us here, so this is normally already true -- but on a slow frame
  /// the countdown would otherwise hand the player an empty game.
  void _maybeStart() {
    if (_routed || !mounted) return;
    if (_remaining > 0 || !_questionsReady) return;
    _routed = true;
    _ticker?.cancel();
    Navigator.pushNamed(
      context,
      widget.gameMode == "First to X"
          ? AppRoutes.firstToXQuestionScreen
          : AppRoutes.lightningModeQuestionScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF2EB),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFD8B98C)),
              ),
              child: Column(
                children: [
                  MultiplayerQuickTips(
                      secondsPerQuestion: widget.secondsPerQuestion),
                  SizedBox(height: 10.h),
                  // Says what the wait is for. Without it the gap reads as the
                  // app having stalled rather than as the round about to open.
                  Text(
                    _remaining > 0
                        ? 'Starting in $_remaining...'
                        : (_questionsReady
                            ? 'Get ready!'
                            : 'Loading questions...'),
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF014CA3),
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
