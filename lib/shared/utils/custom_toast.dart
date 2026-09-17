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