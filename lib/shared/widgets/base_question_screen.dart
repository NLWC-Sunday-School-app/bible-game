import 'package:flutter/material.dart';
import 'package:bible_game/shared/constants/colors.dart';
import 'package:bible_game/shared/widgets/quit_modal.dart';

/// Abstract base state for all question screens.
///
/// Provides shared [AnimationController] and [PageController] lifecycle
/// management, plus two page-advance strategies:
/// - [advancePageWithReset] — per-question countdown timer (QuickGame, PilgrimProgress)
/// - [advancePageByTimer]   — single per-game countdown timer (WhoIsWho, GlobalChallenge)
abstract class BaseQuestionScreenState<T extends StatefulWidget> extends State<T>
    with TickerProviderStateMixin<T> {
  late AnimationController animationController;
  late PageController pageController;
  int currentPage = 0;

  // ---------------------------------------------------------------------------
  // Controller lifecycle
  // ---------------------------------------------------------------------------

  /// Initialises both controllers. Call from [initState] or [didChangeDependencies].
  ///
  /// [onTimerComplete] fires when the animation reaches its end. Pass `null` to
  /// run the animation silently (e.g. progress display only, no auto-advance).
  void initQuestionControllers({
    required Duration duration,
    VoidCallback? onTimerComplete,
  }) {
    pageController = PageController();
    animationController = AnimationController(vsync: this, duration: duration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          onTimerComplete?.call();
        }
      });
    animationController.forward();
  }

  /// Disposes the old controller and creates a fresh one with [duration].
  /// Used when additional game time is purchased mid-game (WhoIsWho).
  void restartAnimationController({
    required Duration duration,
    VoidCallback? onTimerComplete,
  }) {
    animationController.dispose();
    animationController = AnimationController(vsync: this, duration: duration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          onTimerComplete?.call();
        }
      });
    animationController.forward();
  }

  // ---------------------------------------------------------------------------
  // Page-advance strategies
  // ---------------------------------------------------------------------------

  /// Per-question timer strategy: resets and restarts the animation on each page.
  /// Call this when each question has its own countdown.
  void advancePageWithReset({
    required int totalPages,
    required VoidCallback onGameComplete,
  }) {
    if (currentPage < totalPages - 1) {
      currentPage++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      animationController.reset();
      animationController.forward();
    } else {
      animationController.stop();
      onGameComplete();
    }
  }

  /// Per-game timer strategy: advances the page while the timer is still running;
  /// triggers [onGameComplete] once the timer has expired.
  /// Call this when a single timer spans the whole game.
  void advancePageByTimer({required VoidCallback onGameComplete}) {
    if (animationController.isAnimating) {
      currentPage++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      animationController.stop();
      onGameComplete();
    }
  }

  // ---------------------------------------------------------------------------
  // Back-press protection
  // ---------------------------------------------------------------------------

  /// Wraps [child] in a [PopScope] that shows [QuitModal] before allowing a pop.
  Widget withQuitProtection(Widget child) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await showDialog<bool>(
          barrierDismissible: true,
          barrierColor: AppColors.modalBarrierLight,
          context: context,
          builder: (_) => const QuitModal(),
        );
        if ((shouldPop ?? false) && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: child,
    );
  }

  // ---------------------------------------------------------------------------
  // Disposal
  // ---------------------------------------------------------------------------

  @override
  void dispose() {
    animationController.dispose();
    pageController.dispose();
    super.dispose();
  }
}
