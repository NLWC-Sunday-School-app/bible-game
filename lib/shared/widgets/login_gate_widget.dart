import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/features/home/widget/modals/login_modal.dart';
import 'package:bible_game/features/home/widget/modals/create_profile_modal.dart';
import 'package:bible_game/features/home/widget/modals/google_sign_in_button.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:bible_game/shared/widgets/green_button.dart';
import 'package:bible_game/shared/constants/image_routes.dart';

/// A game-themed "please log in" screen shown when the user
/// tries to access a feature that requires authentication.
class LoginGateWidget extends StatefulWidget {
  final String featureTitle;
  final String? subtitle;
  final IconData? icon;

  const LoginGateWidget({
    super.key,
    required this.featureTitle,
    this.subtitle,
    this.icon,
  });

  @override
  State<LoginGateWidget> createState() => _LoginGateWidgetState();
}

class _LoginGateWidgetState extends State<LoginGateWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    final sub = widget.subtitle ??
        'Log in or create a profile\nto unlock ${widget.featureTitle}!';

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 20.h),

            // ── Floating emblem ──
            AnimatedBuilder(
              animation: _floatAnim,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _floatAnim.value),
                  child: child,
                );
              },
              child: CustomPaint(
                painter: _SparkleRingPainter(),
                child: Container(
                  width: 110.w,
                  height: 110.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.25),
                        Colors.white.withOpacity(0.10),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.35),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 24,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.icon ?? Icons.lock_rounded,
                    color: Colors.white.withOpacity(0.85),
                    size: 48.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 28.h),

            // ── Title ──
            StrokeText(
              text: widget.featureTitle,
              textStyle: TextStyle(
                color: Colors.white,
                fontFamily: 'Mikado',
                fontSize: 30.sp,
                fontWeight: FontWeight.w900,
              ),
              strokeColor: const Color(0xFF042A6B),
              strokeWidth: 6,
            ),
            SizedBox(height: 12.h),

            // ── Subtitle ──
            Text(
              sub,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 15.sp,
                fontFamily: 'Mikado',
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
            SizedBox(height: 10.h),

            // ── Decorative divider ──
            SizedBox(
              width: 160.w,
              height: 20.h,
              child: CustomPaint(painter: _DividerPainter()),
            ),
            SizedBox(height: 10.h),

            // ── Log In button ──
            GreenButton(
              onTap: () {
                soundManager.playClickSound();
                showLoginModal(context);
              },
              buttonIsLoading: false,
              width: 280.w,
              customWidget: Center(
                child: StrokeText(
                  text: 'Log In',
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  strokeColor: const Color(0xFF272D39),
                  strokeWidth: 3,
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // ── Create Profile button ──
            GestureDetector(
              onTap: () {
                soundManager.playClickSound();
                showCreateProfileModal(context);
              },
              child: Container(
                width: 280.w,
                padding: EdgeInsets.symmetric(vertical: 15.h),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ProductImageRoutes.newBlueBtnBg),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Center(
                  child: StrokeText(
                    text: 'Create Profile',
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    strokeColor: const Color(0xFF272D39),
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // ── "or" divider ──
            SizedBox(
              width: 280.w,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.white.withOpacity(0.15),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.4),
                        fontFamily: 'Mikado',
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 1,
                      color: Colors.white.withOpacity(0.15),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // ── Continue with Google ──
            SizedBox(
              width: 280.w,
              child: const GoogleSignInButton(isInsideDialog: false),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}

/// Paints subtle sparkle dots in a ring around the emblem
class _SparkleRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rng = Random(21);
    final paint = Paint();
    for (int i = 0; i < 12; i++) {
      final angle = (i / 12) * 2 * pi;
      final dist = size.width * 0.58 + rng.nextDouble() * 10;
      final x = center.dx + cos(angle) * dist;
      final y = center.dy + sin(angle) * dist;
      final r = rng.nextDouble() * 2.0 + 1.0;
      paint.color =
          Colors.white.withOpacity(rng.nextDouble() * 0.3 + 0.1);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Paints a decorative ornamental divider
class _DividerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cy = size.height / 2;
    final cx = size.width / 2;

    // Center diamond
    final diamondPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    final diamondPath = Path()
      ..moveTo(cx, cy - 4)
      ..lineTo(cx + 5, cy)
      ..lineTo(cx, cy + 4)
      ..lineTo(cx - 5, cy)
      ..close();
    canvas.drawPath(diamondPath, diamondPaint);

    final linePaint = Paint()
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 3; i++) {
      final opacity = 0.35 - (i * 0.1);
      linePaint.color = Colors.white.withOpacity(opacity);
      final startX = cx - 10 - (i * 20.0);
      final endX = cx - 30 - (i * 20.0);
      canvas.drawLine(Offset(startX, cy), Offset(endX, cy), linePaint);
    }

    for (int i = 0; i < 3; i++) {
      final opacity = 0.35 - (i * 0.1);
      linePaint.color = Colors.white.withOpacity(opacity);
      final startX = cx + 10 + (i * 20.0);
      final endX = cx + 30 + (i * 20.0);
      canvas.drawLine(Offset(startX, cy), Offset(endX, cy), linePaint);
    }

    final dotPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx - 70, cy), 2, dotPaint);
    canvas.drawCircle(Offset(cx + 70, cy), 2, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
