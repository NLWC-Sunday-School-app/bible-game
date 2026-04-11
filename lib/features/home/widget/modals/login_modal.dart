import 'dart:math';
import 'package:another_flushbar/flushbar.dart';
import 'package:bible_game/shared/features/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/features/home/widget/modals/reset_password_modal.dart';
import 'package:bible_game/features/home/widget/modals/successful_login_modal.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../../shared/utils/device_info.dart';
import '../../../../shared/utils/token_notifier.dart';
import '../../../../shared/utils/validation.dart';
import '../../../../shared/widgets/blue_button.dart';
import 'package:bible_game_api/utils/api_exception.dart';

import '../../../global_challenge/bloc/global_challenge_bloc.dart';

void showLoginModal(BuildContext context) {
  showDialog(
    context: context,
    useRootNavigator: false,
    barrierColor: Colors.black.withOpacity(0.75),
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        backgroundColor: Colors.transparent,
        child: const LoginModal(),
      );
    },
  );
}

class LoginModal extends StatefulWidget {
  const LoginModal({super.key});

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  bool _obscurePassword = true;
  final DeviceInfoService _deviceInfoService = DeviceInfoService();
  Map<String, String> _deviceInfo = {};
  bool _deviceInfoLoaded = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    _animController.forward();
  }

  Future<void> _loadDeviceInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final info = await _deviceInfoService.getDeviceInfo();
    if (!mounted) return;
    setState(() {
      _deviceInfo = info;
      _deviceInfoLoaded = true;
    });
    prefs.setString('deviceName', _deviceInfo['deviceName'] ?? 'Unknown');
    prefs.setString('deviceOs', _deviceInfo['osVersion'] ?? 'Unknown');
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    final tr = AppLocalization.tr(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: const Color(0xFF5AA0F0).withOpacity(0.6),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4A9EFF).withOpacity(0.35),
                  blurRadius: 28,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 4,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22.r),
              child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Header ──
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 20.h, bottom: 32.h),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF2E7FE8),
                        Color(0xFF1565C0),
                        Color(0xFF0D50A0),
                      ],
                    ),
                  ),
                  child: CustomPaint(
                    painter: _SparklesPainter(),
                    child: Column(
                      children: [
                        // Close
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 16.w),
                            child: GestureDetector(
                              onTap: () {
                                soundManager.playClickSound();
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 32.w,
                                height: 32.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.15),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: Icon(
                                  Icons.close_rounded,
                                  color: Colors.white.withOpacity(0.8),
                                  size: 18.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),

                        // Emblem
                        Container(
                          width: 72.w,
                          height: 72.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFFFE066),
                                Color(0xFFFFAA00),
                                Color(0xFFFF8800),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFAA00).withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 4,
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 3,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.person_rounded,
                                color: const Color(0xFF7A3800),
                                size: 36.sp,
                              ),
                              // Small crown on top
                              Positioned(
                                top: 6.h,
                                child: Icon(
                                  Icons.auto_awesome,
                                  color: Colors.white.withOpacity(0.9),
                                  size: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        StrokeText(
                          text: tr.t('auth_login_title'),
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Mikado',
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w900,
                          ),
                          strokeColor: const Color(0xFF042A6B),
                          strokeWidth: 5,
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          tr.t('auth_login_subtitle'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white.withOpacity(0.65),
                            fontFamily: 'Mikado',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Decorative divider ──
                Container(
                  height: 4,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFFAA00),
                        Color(0xFFFFD700),
                        Color(0xFFFFE066),
                        Color(0xFFFFD700),
                        Color(0xFFFFAA00),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x55FFD700),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),

                // ── Form ──
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 24.h),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF0C2244),
                        Color(0xFF071832),
                      ],
                    ),
                  ),
                  child: Form(
                    key: _loginFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildField(
                          controller: emailController,
                          focusNode: _emailFocus,
                          hint: tr.t('auth_login_email_hint'),
                          icon: Icons.mail_outline_rounded,
                          keyboardType: TextInputType.emailAddress,
                          action: TextInputAction.next,
                          onSubmit: (_) => FocusScope.of(context)
                              .requestFocus(_passwordFocus),
                          validator: (t) => Validator.validateEmail(t!),
                        ),
                        SizedBox(height: 16.h),
                        _buildField(
                          controller: passwordController,
                          focusNode: _passwordFocus,
                          hint: tr.t('auth_login_password_hint'),
                          icon: Icons.lock_outline_rounded,
                          obscure: _obscurePassword,
                          keyboardType: TextInputType.visiblePassword,
                          action: TextInputAction.done,
                          onSubmit: (_) => _submitLogin(soundManager),
                          validator: (t) => Validator.validatePassword(t!),
                          suffix: GestureDetector(
                            onTap: () => setState(
                                () => _obscurePassword = !_obscurePassword),
                            child: Padding(
                              padding: EdgeInsets.only(right: 14.w),
                              child: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFF5A7A9A),
                                size: 20.sp,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10.h),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                showResetPasswordModal(context);
                              },
                              child: Text(
                                tr.t('auth_forgot_password'),
                                style: TextStyle(
                                  color: const Color(0xFF5EB0FF),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Mikado',
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 28.h),
                        BlocConsumer<AuthenticationBloc, AuthenticationState>(
                          listenWhen: (prev, curr) =>
                              prev.failedToLogin != curr.failedToLogin ||
                              prev.token != curr.token,
                          listener: (context, state) {
                            if (state.failedToLogin) {
                              final errorMsg = ApiException.errorMessage;
                              if (errorMsg.isNotEmpty) {
                                ApiException.showSnackBar(context);
                              } else {
                                Flushbar(
                                  message: tr.t('auth_login_failed'),
                                  flushbarPosition: FlushbarPosition.TOP,
                                  flushbarStyle: FlushbarStyle.GROUNDED,
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 3),
                                ).show(context);
                              }
                            }
                            if (state.token != null) {
                              BlocProvider.of<GlobalChallengeBloc>(context)
                                  .add(FetchGlobalChallengeGames());
                              final tokenNotifier = Provider.of<TokenNotifier>(
                                  context,
                                  listen: false);
                              tokenNotifier.setToken(state.token);
                              GetStorage().write('user_token', state.token!);
                              GetStorage()
                                  .write('refresh_token', state.refreshToken!);
                              Navigator.pop(context);
                              showSuccessfulLoginModal(context);
                            }
                          },
                          builder: (context, state) {
                            return BlueButton(
                              width: double.infinity,
                              buttonText: tr.t('auth_login'),
                              buttonIsLoading: state.isLoadingLogin,
                              onTap: () => _submitLogin(soundManager),
                            );
                          },
                        ),
                        SizedBox(height: 12.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    TextInputAction? action,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
    void Function(String)? onSubmit,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: action,
      obscureText: obscure,
      onFieldSubmitted: onSubmit,
      style: TextStyle(color: Colors.white, fontSize: 14.sp),
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF0F2A4A),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 14.w, right: 10.w),
          child: Icon(icon, color: const Color(0xFFFFBB33), size: 20.sp),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 44.w),
        suffixIcon: suffix,
        suffixIconConstraints: BoxConstraints(minWidth: 40.w),
        hintText: hint,
        hintStyle: TextStyle(
          color: const Color(0xFF456080),
          fontSize: 14.sp,
        ),
        errorStyle: TextStyle(
          fontSize: 11.sp,
          color: const Color(0xFFFF6B6B),
          fontWeight: FontWeight.w500,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Color(0xFF1A3A5E), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Color(0xFFFFBB33), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 2),
        ),
      ),
    );
  }

  void _submitLogin(dynamic soundManager) {
    soundManager.playClickSound();
    FocusScope.of(context).unfocus();
    if (_loginFormKey.currentState!.validate()) {
      final deviceName = _deviceInfoLoaded
          ? (_deviceInfo['deviceName'] ?? 'Unknown')
          : 'Unknown';
      final deviceOs = _deviceInfoLoaded
          ? (_deviceInfo['osVersion'] ?? 'Unknown')
          : 'Unknown';
      BlocProvider.of<AuthenticationBloc>(context).add(
        AuthenticationLoginRequested(
          emailController.text,
          passwordController.text,
          deviceName,
          deviceOs,
        ),
      );
    }
  }
}

/// Paints subtle sparkle dots in the header
class _SparklesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(42);
    final paint = Paint()..color = Colors.white;
    for (int i = 0; i < 18; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final r = rng.nextDouble() * 1.8 + 0.5;
      paint.color = Colors.white.withOpacity(rng.nextDouble() * 0.25 + 0.05);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
