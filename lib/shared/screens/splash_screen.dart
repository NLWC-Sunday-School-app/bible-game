import 'dart:math' as math;

import 'package:bible_game/features/global_challenge/bloc/global_challenge_bloc.dart';
import 'package:bible_game/features/pilgrim_progress/bloc/pilgrim_progress_bloc.dart';
import 'package:bible_game/shared/constants/app_routes.dart';
import 'package:bible_game/shared/constants/colors.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:bible_game/shared/utils/network_connection.dart';
import 'package:bible_game/shared/utils/token_notifier.dart';
import 'package:bible_game/shared/widgets/modal/network_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..addListener(() {
        if (mounted) setState(() => _progress = _progressController.value);
      });

    _progressController.forward().whenComplete(() {
      if (mounted) _checkInternetConnection();
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        final route = ModalRoute.of(context);
        if ((route?.isCurrent ?? false) && state.user.id != 0) {
          BlocProvider.of<PilgrimProgressBloc>(context)
              .add(FetchPilgrimProgressLevelData());
          BlocProvider.of<UserBloc>(context).add(FetchUserStreakDetails());
          BlocProvider.of<UserBloc>(context).add(FetchUserYearlyRecap());
        }
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF071428),
                Color(0xFF0D1E3E),
                AppColors.primaryDarkBackground,
                Color(0xFF0D2050),
              ],
              stops: [0.0, 0.3, 0.65, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Star field background
              const Positioned.fill(child: _StarField()),

              // Radial glow behind cross
              Center(
                child: Container(
                  width: 280.w,
                  height: 280.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFFFFD700).withValues(alpha: 0.18),
                        const Color(0xFFFFD700).withValues(alpha: 0.07),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 1200.ms, curve: Curves.easeOut)
                  .scaleXY(begin: 0.6, end: 1.0, duration: 1200.ms),

              // Main content column
              Column(
                children: [
                  const Spacer(flex: 3),

                  // Cross
                  SizedBox(
                    width: 110.w,
                    height: 130.w,
                    child: CustomPaint(painter: _CrossPainter()),
                  )
                      .animate()
                      .fadeIn(duration: 900.ms, delay: 200.ms)
                      .scaleXY(
                          begin: 0.5,
                          end: 1.0,
                          duration: 900.ms,
                          delay: 200.ms,
                          curve: Curves.elasticOut),

                  SizedBox(height: 24.h),

                  // App title
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [
                        Color(0xFFFFE57A),
                        Color(0xFFFFD700),
                        Color(0xFFFFA500),
                        Color(0xFFFFD700),
                      ],
                      stops: [0.0, 0.35, 0.65, 1.0],
                    ).createShader(bounds),
                    child: Text(
                      'THE BIBLE\nGAME',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Neuland',
                        fontSize: 38.sp,
                        color: Colors.white,
                        height: 1.1,
                        letterSpacing: 3,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 500.ms)
                      .slideY(begin: 0.3, end: 0, duration: 800.ms, delay: 500.ms, curve: Curves.easeOut),

                  SizedBox(height: 10.h),

                  // Divider line
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _GoldDivider(width: 40.w),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Icon(Icons.auto_stories_rounded,
                            color: const Color(0xFFFFD700), size: 16.sp),
                      ),
                      _GoldDivider(width: 40.w),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 800.ms)
                      .scaleX(begin: 0, end: 1, duration: 600.ms, delay: 800.ms),

                  SizedBox(height: 10.h),

                  // Tagline
                  Text(
                    'Test Your Knowledge of God\'s Word',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 13.sp,
                      color: Colors.white.withValues(alpha: 0.7),
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, delay: 900.ms),

                  const Spacer(flex: 4),

                  // Progress bar section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50.w),
                    child: Column(
                      children: [
                        // Track
                        Container(
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: _progress,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFFFE57A),
                                        Color(0xFFFFD700),
                                        Color(0xFFFFA500),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(10.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFFD700)
                                            .withValues(alpha: 0.6),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 14.h),

                        Text(
                          'v2.2.12',
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 11.sp,
                            color: Colors.white.withValues(alpha: 0.35),
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms, delay: 600.ms),

                  SizedBox(height: 40.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkInternetConnection() async {
    if (!mounted) return;
    final String? userToken = GetStorage().read('user_token');
    final String? refreshToken = GetStorage().read('refresh_token');
    final networkConnection = NetworkConnection();

    if (await networkConnection.hasInternetConnection()) {
      if (!mounted) return;
      BlocProvider.of<SettingsBloc>(context).add(FetchGamePlaySettings());
      BlocProvider.of<SettingsBloc>(context).add(FetchAds());

      if (userToken != null) {
        final tokenHasExpired = JwtDecoder.isExpired(userToken);
        if (tokenHasExpired && refreshToken != null) {
          BlocProvider.of<AuthenticationBloc>(context)
              .add(AuthenticationRefreshTokenRequested(refreshToken));
          Future.delayed(const Duration(seconds: 1), () {
            if (!mounted) return;
            final token = GetStorage().read('user_token');
            Provider.of<TokenNotifier>(context, listen: false).setToken(token);
            BlocProvider.of<AuthenticationBloc>(context)
                .add(FetchUserDataRequested());
            BlocProvider.of<GlobalChallengeBloc>(context)
                .add(FetchGlobalChallengeGames());
            BlocProvider.of<PilgrimProgressBloc>(context)
                .add(FetchPilgrimProgressLevelData());
            BlocProvider.of<UserBloc>(context).add(FetchUserYearlyRecap());
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.home, (route) => false);
          });
        } else {
          BlocProvider.of<AuthenticationBloc>(context)
              .add(FetchUserDataRequested());
          BlocProvider.of<GlobalChallengeBloc>(context)
              .add(FetchGlobalChallengeGames());
          Future.delayed(const Duration(seconds: 1), () {
            if (!mounted) return;
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.home, (route) => false);
          });
        }
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.home, (route) => false);
      }
    } else {
      if (mounted) showNetworkModal(context);
    }
  }
}

// ---------------------------------------------------------------------------
// Gold divider line
// ---------------------------------------------------------------------------
class _GoldDivider extends StatelessWidget {
  const _GoldDivider({required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 1.5,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.transparent, Color(0xFFFFD700), Colors.transparent],
        ),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Cross painter with golden glow
// ---------------------------------------------------------------------------
class _CrossPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const Color gold = Color(0xFFFFD700);
    const Color goldLight = Color(0xFFFFE57A);
    const Color goldDark = Color(0xFFB8860B);

    final double cx = size.width / 2;
    final double vw = size.width * 0.20; // vertical bar width
    final double hw = size.height * 0.20; // horizontal bar width
    final double vTop = size.height * 0.04;
    final double vBot = size.height * 0.96;
    final double hLeft = size.width * 0.04;
    final double hRight = size.width * 0.96;
    final double hMid = size.height * 0.34; // crossbar vertical position

    // Glow shadow
    final glowPaint = Paint()
      ..color = gold.withValues(alpha: 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);

    final crossPath = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTRB(cx - vw / 2, vTop, cx + vw / 2, vBot),
          const Radius.circular(4)))
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTRB(hLeft, hMid - hw / 2, hRight, hMid + hw / 2),
          const Radius.circular(4)));

    canvas.drawPath(crossPath, glowPaint);

    // Cross fill with gradient
    final gradPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [goldLight, gold, goldDark, gold],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(crossPath, gradPaint);

    // Highlight edge (top-left bevel)
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(crossPath, highlightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ---------------------------------------------------------------------------
// Star field background
// ---------------------------------------------------------------------------
class _StarField extends StatelessWidget {
  const _StarField();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _StarPainter(),
      size: Size.infinite,
    );
  }
}

class _StarPainter extends CustomPainter {
  static final List<_Star> _stars = _generateStars();

  static List<_Star> _generateStars() {
    final rng = math.Random(42); // fixed seed = same stars every paint
    return List.generate(70, (_) {
      return _Star(
        x: rng.nextDouble(),
        y: rng.nextDouble(),
        radius: rng.nextDouble() * 1.4 + 0.3,
        opacity: rng.nextDouble() * 0.6 + 0.2,
      );
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in _stars) {
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: star.opacity)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
          Offset(star.x * size.width, star.y * size.height * 0.75),
          star.radius,
          paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Star {
  const _Star(
      {required this.x,
      required this.y,
      required this.radius,
      required this.opacity});
  final double x, y, radius, opacity;
}
