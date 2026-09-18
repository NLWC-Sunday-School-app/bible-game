import 'dart:async';

import 'package:bible_game/shared/features/multiplayer/cubit/websocket_cubit.dart';
import 'package:bible_game/shared/utils/custom_toast.dart';
import 'package:bible_game/shared/widgets/multiplayer_widget/multiply_question_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shows the room's messages during a multiplayer round, one after another.
///
/// The screens used to show each message the moment it arrived, and every
/// toast starts by removing the one before -- so your "You got 10pts!" was
/// wiped by the next frame a few milliseconds later, and never seen. Messages
/// now wait their turn, long enough to be read.
///
/// A busy room sends more than can be read at that pace (every answer from
/// every player), so the queue is kept short: your own points go to the
/// front, a newer position update replaces an older waiting one, and past
/// [_maxPending] the oldest message about someone else is dropped.
class GameFeedToaster {
  GameFeedToaster(this._context, {this.anchorKey, int seenUpTo = 0})
      : _lastSeenId = seenUpTo;

  final BuildContext _context;

  /// The question card's rank-flag row (MultiplayerQuestionContainer's
  /// feedAnchorKey). Toasts sit in the space beside the flag; without it they
  /// fall back to the top of the screen, over the score.
  final GlobalKey? anchorKey;

  static const _showFor = Duration(milliseconds: 1800);
  static const _victoryShowFor = Duration(seconds: 3);
  // CustomToast fades out over 300ms after its duration; the rest is a
  // breath between one message and the next.
  static const _fadeAndGap = Duration(milliseconds: 450);
  static const _maxPending = 3;

  final List<GameFeedMessage> _pending = [];
  int _lastSeenId;
  Timer? _timer;
  bool _showing = false;
  bool _disposed = false;
  bool _finished = false;

  /// Queues [message] unless it has been seen already. The listener runs on
  /// every state change, and the latest message stays in state throughout.
  void add(GameFeedMessage? message) {
    if (_disposed || message == null || message.id <= _lastSeenId) return;
    _lastSeenId = message.id;
    // Once the round is over the leaderboard is on top, and late answers or
    // "{username} left the game" would land beside a flag nobody can see --
    // right over the leaderboard's close button.
    if (_finished && message.kind != GameFeedKind.victory) return;

    switch (message.kind) {
      case GameFeedKind.victory:
        // The round is over; nothing still waiting matters more.
        _finished = true;
        _pending.clear();
        _timer?.cancel();
        _showing = false;
        _pending.add(message);
      case GameFeedKind.myAnswer:
        _pending.insert(0, message);
      case GameFeedKind.position:
        _pending.removeWhere((m) => m.kind == GameFeedKind.position);
        _pending.add(message);
      case GameFeedKind.playerAnswer:
      case GameFeedKind.presence:
        _pending.add(message);
    }

    while (_pending.length > _maxPending) {
      final oldest = _pending.indexWhere((m) =>
          m.kind != GameFeedKind.myAnswer && m.kind != GameFeedKind.victory);
      if (oldest == -1) break;
      _pending.removeAt(oldest);
    }

    if (!_showing) _showNext();
  }

  void _showNext() {
    if (_disposed || !_context.mounted || _pending.isEmpty) {
      _showing = false;
      return;
    }
    _showing = true;
    final message = _pending.removeAt(0);
    final duration = message.kind == GameFeedKind.victory
        ? _victoryShowFor
        : _showFor;

    // One look for every message -- the game's cream banner -- with the
    // border saying what kind of news it is: green for points, red for a
    // miss, blue for everything else. The green ribbon used to mark your own
    // answers, but its tick and coin read as a win on "You answered too
    // late. 0pts." too.
    final tone = switch (message.positive) {
      true => BannerTone.success,
      false => BannerTone.error,
      null => BannerTone.neutral,
    };
    final icon = switch (message.kind) {
      GameFeedKind.presence => Icons.group_rounded,
      GameFeedKind.position => Icons.leaderboard_rounded,
      GameFeedKind.victory => Icons.emoji_events_rounded,
      GameFeedKind.myAnswer || GameFeedKind.playerAnswer => null,
    };
    if (message.kind == GameFeedKind.victory) {
      // The winner's goes up over the leaderboard. At the top it sat on the
      // header's close button and swallowed the first tap on it, so it goes
      // above "Play another round" instead, and lets taps through.
      CustomToast.showBanner(
        _context,
        message.text,
        tone: tone,
        icon: icon,
        bottom: MediaQuery.of(_context).padding.bottom + 90.h,
        passThrough: true,
        duration: duration,
      );
    } else {
      final area = _besideFlag();
      CustomToast.showBanner(
        _context,
        message.text,
        tone: tone,
        icon: icon,
        top: area?.top,
        left: area?.left,
        right: area?.right,
        // A toast is never worth a lost tap: taps go through to the game.
        passThrough: true,
        duration: duration,
      );
    }
    _timer = Timer(duration + _fadeAndGap, _showNext);
  }

  /// Where the rank-flag row leaves room, in screen coordinates: from just
  /// past the flag to the row's right edge. Measured each time rather than
  /// once, so a tablet's centred card and a rotated screen still line up.
  ({double top, double left, double right})? _besideFlag() {
    final box = anchorKey?.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.hasSize || !box.attached) return null;
    final origin = box.localToGlobal(Offset.zero);
    final screenWidth = MediaQuery.of(_context).size.width;
    return (
      top: origin.dy + 8.h,
      left: origin.dx + MultiplayerQuestionContainer.rankFlagWidth + 6.w,
      right: screenWidth - (origin.dx + box.size.width),
    );
  }

  /// The round is over and the leaderboard is going up: drop what is still
  /// waiting, and show nothing more but the winner.
  void finish() {
    _finished = true;
    _pending.clear();
  }

  void dispose() {
    _disposed = true;
    _timer?.cancel();
    _pending.clear();
  }
}
