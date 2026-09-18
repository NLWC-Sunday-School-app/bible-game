import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/constants/image_routes.dart';

class MultiplayerButton extends StatefulWidget {
  const MultiplayerButton({
    super.key,
    required this.buttonText,
    this.onTap,
    required this.buttonIsLoading,
    required this.width,
    this.customText,
    this.customWidget,
    this.hasCustomWidget = false,
    this.height = 55,
    this.isActive = true
  });

  final String buttonText;
  final customText;
  final VoidCallback? onTap;
  final bool buttonIsLoading;
  final double width;
  final double? height;
  final Widget? customWidget;
  final bool? hasCustomWidget;
  final bool? isActive;

  @override
  State<MultiplayerButton> createState() => _MultiplayerButtonState();
}

class _MultiplayerButtonState extends State<MultiplayerButton> {
  bool _isPressed = false;

  void _setPressed(bool pressed) {
    if (_isPressed != pressed) setState(() => _isPressed = pressed);
  }

  @override
  Widget build(BuildContext context) {
    final pressable = widget.onTap != null && widget.isActive == true;
    // Was an InkWell, whose ripple is painted on the Material *behind* this
    // image background -- so a tap showed nothing at all, and Start Game felt
    // dead. Now it sinks under the finger, the way the answer buttons do, and
    // gives a light haptic tick.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap == null
          ? null
          : () {
              if (pressable) HapticFeedback.lightImpact();
              widget.onTap!();
            },
      onTapDown: pressable ? (_) => _setPressed(true) : null,
      onTapUp: pressable ? (_) => _setPressed(false) : null,
      onTapCancel: pressable ? () => _setPressed(false) : null,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
        width: widget.width,
        height:  widget.height,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        decoration: BoxDecoration(
          // border: Border.all(color: widget.isActive! ? const Color(0xFF1E62D4) : const Color(0xFF8E8E8E) , width: 3.w),
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          image: DecorationImage(
            image: AssetImage(
              widget.isActive! ? ProductImageRoutes.multiplayerActiveButton : ProductImageRoutes.multiplayerInactiveButton,
            ),
            // fit: BoxFit.fill,
            // colorFilter: ColorFilter.mode(Color(0xFFffffff).withOpacity(0.5), BlendMode.colorDodge)
          ),
        ),
        child: !widget.hasCustomWidget!
            ? widget.buttonIsLoading
                ? Center(
                    child: SizedBox(
                        height: 20.w,
                        width: 20.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        )),
                  )
                : widget.customText != null
                    ? widget.customText
                    : Center(
                      child: Text(
                          widget.buttonText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                    )
            : widget.customWidget,
        ),
      ),
    );
  }
}
