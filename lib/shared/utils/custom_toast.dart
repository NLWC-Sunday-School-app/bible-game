import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomToast {
  static OverlayEntry? overlayEntry;

  static void removeOverlay() {
    try {
      if (overlayEntry?.mounted ?? false) {
        overlayEntry?.remove();
      }
      overlayEntry = null;
    } catch (e) {
      debugPrint("Overlay removal failed: $e");
    }
  }

  static void show(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 2), bool? isTriggerFromWaitingRoom}) {
    // Remove any existing overlay first
    removeOverlay();

    final overlay = Overlay.of(context);
    final animationDuration = const Duration(milliseconds: 300);

    overlayEntry = OverlayEntry(
      builder: (context) {
        return _ToastWidget(
          message: message,
          duration: duration,
          animationDuration: animationDuration,
          onDismissed: () => removeOverlay(), // ✅ Use removeOverlay instead
          isTriggerFromWaitingRoom: isTriggerFromWaitingRoom,
        );
      },
    );

    overlay.insert(overlayEntry!);
  }

  /// Neutral status toast -- no success tick, no coin, no ribbon art.
  /// For messages that are neither a win nor a reward (connection state, etc).
  /// The green ribbon asset is 570x105 with 59% of its width taken up by
  /// decorative end caps, leaving only a narrow middle band for content, so
  /// anything longer than a few words landed on top of the caps.
  static void showStatus(BuildContext context, String message,
      {Duration duration = const Duration(seconds: 3)}) {
    removeOverlay();
    final overlay = Overlay.of(context);
    const animationDuration = Duration(milliseconds: 300);

    overlayEntry = OverlayEntry(
      builder: (context) {
        return _ToastWidget(
          message: message,
          duration: duration,
          animationDuration: animationDuration,
          onDismissed: () => removeOverlay(),
          isStatus: true,
        );
      },
    );

    overlay.insert(overlayEntry!);
  }

  /// The app's general-purpose message banner: "Copied", "Not enough gems",
  /// "Invalid invite code".
  ///
  /// These were Flushbars -- a full-bleed Material bar in flat green or red,
  /// the one piece of stock Android styling in a game built out of cream
  /// cards, hard shadows and ribbon art. Same idiom as the cards now: inset
  /// from the edges, cream ground, coloured border and an offset shadow with
  /// no blur.
  static void showBanner(BuildContext context, String message,
      {bool isError = false,
      Duration duration = const Duration(seconds: 3)}) {
    removeOverlay();

    final overlay = Overlay.of(context);
    const animationDuration = Duration(milliseconds: 260);

    overlayEntry = OverlayEntry(
      builder: (context) {
        return _BannerToastWidget(
          message: message,
          isError: isError,
          duration: duration,
          animationDuration: animationDuration,
          onDismissed: () => removeOverlay(),
        );
      },
    );

    overlay.insert(overlayEntry!);
  }

  static void showInviteToast(BuildContext context,
      {Duration duration = const Duration(seconds: 2), required bool isInviteSuccessful, String? message}) {
    // Remove any existing overlay first
    removeOverlay();

    final overlay = Overlay.of(context);
    final animationDuration = const Duration(milliseconds: 300);

    overlayEntry = OverlayEntry(
      builder: (context) {
        return _InviteToastWidget(
          duration: duration,
          animationDuration: animationDuration,
          onDismissed: () => removeOverlay(), // ✅ Use removeOverlay instead
          isInviteSuccessful: isInviteSuccessful,
          message: message,
        );
      },
    );

    overlay.insert(overlayEntry!);
  }
}



class _ToastWidget extends StatefulWidget {
  final String message;
  final Duration duration;
  final Duration animationDuration;
  final VoidCallback onDismissed;
  final bool? isTriggerFromWaitingRoom;
  final bool isStatus;

  const _ToastWidget({
    Key? key,
    required this.message,
    required this.duration,
    required this.animationDuration,
    required this.onDismissed,
    this.isTriggerFromWaitingRoom,
    this.isStatus = false,
  }) : super(key: key);

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget> {
  double _opacity = 0.0;
  bool _isDismissed = false; // ✅ Track if already dismissed

  @override
  void initState() {
    super.initState();

    // Fade in
    Future.delayed(Duration.zero, () {
      if (mounted) {
        setState(() => _opacity = 1.0);
      }
    });

    // Wait -> Fade out -> Remove
    Future.delayed(widget.duration, () {
      if (mounted) {
        setState(() => _opacity = 0.0);
      }
      Future.delayed(widget.animationDuration, () {
        // ✅ Only dismiss once
        if (!_isDismissed && mounted) {
          _isDismissed = true;
          widget.onDismissed();
        }
      });
    });
  }

  @override
  void dispose() {
    _isDismissed = true; // ✅ Mark as dismissed on dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 50.h,
      left: MediaQuery.of(context).size.width * 0.1,
      right: MediaQuery.of(context).size.width * 0.1,
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: widget.animationDuration,
        child: Material(
          color: Colors.transparent,
          child: widget.isStatus
              ? Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F2957),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFF047AEE), width: 1.5),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x55000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    widget.message,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.toastSuccess)
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: widget.isTriggerFromWaitingRoom != null?
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    widget.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                    TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            )
                :
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  IconImageRoutes.greenSuccessIcon,
                  height: 24,
                  width: 24,
                ),
                SizedBox(width: 5.w,),
                Flexible(
                  child: Text(
                    widget.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                    TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                SizedBox(width: 5.w,),
                Image.asset(
                  IconImageRoutes.coinIcon,
                  height: 20,
                  width: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InviteToastWidget extends StatefulWidget {
  final Duration duration;
  final Duration animationDuration;
  final VoidCallback onDismissed;
  final bool isInviteSuccessful;
  final String? message;

  const _InviteToastWidget({
    Key? key,
    required this.duration,
    required this.animationDuration,
    required this.onDismissed,
    required this.isInviteSuccessful,
    this.message,
  }) : super(key: key);

  @override
  State<_InviteToastWidget> createState() => _InviteToastWidgetState();
}

class _InviteToastWidgetState extends State<_InviteToastWidget> {
  double _opacity = 0.0;
  bool _isDismissed = false; // ✅ Track if already dismissed

  @override
  void initState() {
    super.initState();

    // Fade in
    Future.delayed(Duration.zero, () {
      if (mounted) {
        setState(() => _opacity = 1.0);
      }
    });

    // Wait -> Fade out -> Remove
    Future.delayed(widget.duration, () {
      if (mounted) {
        setState(() => _opacity = 0.0);
      }
      Future.delayed(widget.animationDuration, () {
        // ✅ Only dismiss once
        if (!_isDismissed && mounted) {
          _isDismissed = true;
          widget.onDismissed();
        }
      });
    });
  }

  @override
  void dispose() {
    _isDismissed = true; // ✅ Mark as dismissed on dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 50.h,
      left: MediaQuery.of(context).size.width * 0.1,
      right: MediaQuery.of(context).size.width * 0.1,
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: widget.animationDuration,
        child: Material(
          color: Colors.transparent,
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: widget.isInviteSuccessful?AssetImage(ProductImageRoutes.inviteSuccessfulBg):AssetImage(ProductImageRoutes.inviteErrorBg),
                    fit: BoxFit.fill
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: widget.isInviteSuccessful?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 5,),
                  Flexible(
                    child: widget.message == null?
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Invite Sent Successfully!",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                          TextStyle(
                              color: Color(0xFF014CA3),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w900
                          ),
                        ),
                        Text(
                          "Your Friend has been sent a Game Invite",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                          TextStyle(
                              color: Colors.black,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ],
                    )
                        :
                    Text(
                      widget.message!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                      TextStyle(
                          color: Color(0xFF014CA3),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900
                      ),
                    ),
                  ),

                  SizedBox(width: 12.w,),
                  Image.asset(
                    IconImageRoutes.greenSuccessIcon,
                    height: 24,
                    width: 24,
                  ),
                ],
              )
                  :
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 5.w,),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          // "ERROR!" shouted at the player without saying what
                          // went wrong. When the API gives a reason -- already
                          // written for players -- the heading just frames it.
                          widget.message == null ? "ERROR!" : "Invite not sent",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                          TextStyle(
                              color: Color(0xFFB71111),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w900
                          ),
                        ),
                        Text(
                          // The failure branch accepted a message and then
                          // ignored it; only the success branch ever used it.
                          widget.message ?? "No invite was sent",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                          TextStyle(
                              color: Colors.black,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w,),
                  Image.asset(
                    ProductImageRoutes.inviteErrorIcon,
                    height: 24,
                    width: 24,
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }
}
/// The banner behind [CustomToast.showBanner].
///
/// Slides down from behind the status bar and fades as it goes, rather than
/// appearing fully formed the way the opacity-only toasts above do -- a bar
/// that drops in reads as part of the game instead of a system notice.
class _BannerToastWidget extends StatefulWidget {
  final String message;
  final bool isError;
  final Duration duration;
  final Duration animationDuration;
  final VoidCallback onDismissed;

  const _BannerToastWidget({
    Key? key,
    required this.message,
    required this.isError,
    required this.duration,
    required this.animationDuration,
    required this.onDismissed,
  }) : super(key: key);

  @override
  State<_BannerToastWidget> createState() => _BannerToastWidgetState();
}

class _BannerToastWidgetState extends State<_BannerToastWidget> {
  bool _shown = false;
  bool _isDismissed = false;

  /// Cream ground, so it reads as one of the game's cards rather than a system
  /// bar. The tone only ever colours the border, the shadow and the badge.
  static const _cream = Color(0xFFFFEED6);
  static const _ink = Color(0xFF122F52);

  static const _successBorder = Color(0xFF1F8A4C);
  static const _successShadow = Color(0xFF125C32);
  static const _errorBorder = Color(0xFFDB0C34);
  static const _errorShadow = Color(0xFF94142E);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _shown = true);
    });

    Future.delayed(widget.duration, () {
      if (!mounted || _isDismissed) return;
      setState(() => _shown = false);
      Future.delayed(widget.animationDuration, _dismiss);
    });
  }

  @override
  void dispose() {
    // A pending dismissal outlives this widget by one animation: without this
    // flag, a banner replaced mid-fade would call removeOverlay() afterwards
    // and take the *replacing* banner off screen with it.
    _isDismissed = true;
    super.dispose();
  }

  void _dismiss() {
    if (_isDismissed || !mounted) return;
    _isDismissed = true;
    widget.onDismissed();
  }

  @override
  Widget build(BuildContext context) {
    final border = widget.isError ? _errorBorder : _successBorder;
    final shadow = widget.isError ? _errorShadow : _successShadow;

    return Positioned(
      // Clear of the status bar and the notch, and inset from the edges: the
      // Flushbar ran the full width and butted against the top of the screen.
      top: MediaQuery.of(context).padding.top + 12.h,
      left: 16.w,
      right: 16.w,
      child: Material(
        color: Colors.transparent,
        child: AnimatedSlide(
          duration: widget.animationDuration,
          curve: Curves.easeOutBack,
          offset: _shown ? Offset.zero : const Offset(0, -1.4),
          child: AnimatedOpacity(
            duration: widget.animationDuration,
            opacity: _shown ? 1 : 0,
            child: GestureDetector(
              // Tapping it takes it away, rather than waiting out the three
              // seconds with it sitting over the screen.
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() => _shown = false);
                Future.delayed(widget.animationDuration, _dismiss);
              },
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 11.h),
                decoration: BoxDecoration(
                  color: _cream,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: border, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: shadow,
                      offset: const Offset(2, 4),
                      blurRadius: 0,
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 26.w,
                      height: 26.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: border,
                      ),
                      child: Icon(
                        widget.isError
                            ? Icons.priority_high_rounded
                            : Icons.check_rounded,
                        size: 17.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        widget.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: _ink,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
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
