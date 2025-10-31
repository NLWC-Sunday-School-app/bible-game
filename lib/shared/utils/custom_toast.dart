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

  const _ToastWidget({
    Key? key,
    required this.message,
    required this.duration,
    required this.animationDuration,
    required this.onDismissed,
    this.isTriggerFromWaitingRoom,
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
          child: Container(
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
                Text(
                  widget.message,
                  style:
                  TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold
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
                Text(
                  widget.message,
                  style:
                  TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold
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
                  widget.message == null?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Invite Sent Successfully!",
                        style:
                        TextStyle(
                            color: Color(0xFF014CA3),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900
                        ),
                      ),
                      Text(
                        "Your Friend has been sent a Game Invite",
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
                    style:
                    TextStyle(
                        color: Color(0xFF014CA3),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w900
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "ERROR!",
                        style:
                        TextStyle(
                            color: Color(0xFFB71111),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900
                        ),
                      ),
                      Text(
                        "No invite was sent",
                        style:
                        TextStyle(
                            color: Colors.black,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                    ],
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