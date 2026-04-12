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

  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF0A1A3A),
      prefixIcon: Container(
        margin: EdgeInsets.only(left: 12.w, right: 8.w),
        child: Icon(prefixIcon, color: const Color(0xFF4A9EFF), size: 22.sp),
      ),
      prefixIconConstraints: BoxConstraints(minWidth: 44.w),
      suffixIcon: suffixIcon,
      hintText: hint,
      hintStyle: TextStyle(
        color: const Color(0xFF4A6A8A),
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
        borderSide: const BorderSide(
          color: Color(0xFF1E3A5F),
          width: 2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(
          color: Color(0xFF4A9EFF),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(
          color: Color(0xFFFF6B6B),
          width: 2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14.r),
        borderSide: const BorderSide(
          color: Color(0xFFFF6B6B),
          width: 2,
        ),
      ),
    );
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
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                width: 3,
                color: const Color(0xFF2A5A9A),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1565C0).withOpacity(0.3),
                  blurRadius: 24,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Header with treasure box & stars ──
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF1565C0),
                          Color(0xFF0D47A1),
                        ],
                      ),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        // Scattered stars
                        Positioned(
                          top: 12.h,
                          left: 20.w,
                          child: Image.asset(
                            IconImageRoutes.star,
                            width: 18.w,
                            opacity: const AlwaysStoppedAnimation(0.4),
                          ),
                        ),
                        Positioned(
                          top: 30.h,
                          right: 30.w,
                          child: Image.asset(
                            IconImageRoutes.star,
                            width: 12.w,
                            opacity: const AlwaysStoppedAnimation(0.3),
                          ),
                        ),
                        Positioned(
                          bottom: 20.h,
                          left: 45.w,
                          child: Image.asset(
                            IconImageRoutes.star,
                            width: 10.w,
                            opacity: const AlwaysStoppedAnimation(0.25),
                          ),
                        ),
                        // Close button
                        Positioned(
                          top: 12.h,
                          right: 12.w,
                          child: GestureDetector(
                            onTap: () {
                              soundManager.playClickSound();
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              IconImageRoutes.closeModal,
                              width: 32.w,
                            ),
                          ),
                        ),
                        // Header content
                        Padding(
                          padding: EdgeInsets.only(top: 28.h, bottom: 40.h),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(14.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 2,
                                  ),
                                ),
                                child: Image.asset(
                                  ProductImageRoutes.treasureBox,
                                  width: 50.w,
                                  height: 50.w,
                                ),
                              ),
                              SizedBox(height: 14.h),
                              StrokeText(
                                text: tr.t('auth_login_title'),
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Mikado',
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                                strokeColor: const Color(0xFF0A3060),
                                strokeWidth: 5,
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                tr.t('auth_login_subtitle'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withOpacity(0.7),
                                  fontFamily: 'Mikado',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Divider line ──
                  Container(
                    height: 3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFFD700).withOpacity(0.0),
                          const Color(0xFFFFD700).withOpacity(0.6),
                          const Color(0xFFFFD700).withOpacity(0.0),
                        ],
                      ),
                    ),
                  ),

                  // ── Form section ──
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 24.h),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF0D2B52),
                          Color(0xFF091E3A),
                        ],
                      ),
                    ),
                    child: Form(
                      key: _loginFormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            focusNode: _emailFocus,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) => FocusScope.of(context)
                                .requestFocus(_passwordFocus),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                            decoration: _inputDecoration(
                              hint: tr.t('auth_login_email_hint'),
                              prefixIcon: Icons.mail_outline_rounded,
                            ),
                            validator: (text) =>
                                Validator.validateEmail(text!),
                          ),
                          SizedBox(height: 16.h),
                          TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: passwordController,
                            focusNode: _passwordFocus,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) =>
                                _submitLogin(soundManager),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                            decoration: _inputDecoration(
                              hint: tr.t('auth_login_password_hint'),
                              prefixIcon: Icons.lock_outline_rounded,
                              suffixIcon: GestureDetector(
                                onTap: () => setState(() =>
                                    _obscurePassword = !_obscurePassword),
                                child: Padding(
                                  padding: EdgeInsets.only(right: 12.w),
                                  child: Image.asset(
                                    _obscurePassword
                                        ? IconImageRoutes.eyeClose
                                        : IconImageRoutes.eyeOpen,
                                    width: 24.w,
                                    color: const Color(0xFF4A6A8A),
                                  ),
                                ),
                              ),
                            ),
                            validator: (text) =>
                                Validator.validatePassword(text!),
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
                                    color: const Color(0xFF4A9EFF),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Mikado',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24.h),
                          BlocConsumer<AuthenticationBloc,
                              AuthenticationState>(
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
                                final tokenNotifier =
                                    Provider.of<TokenNotifier>(context,
                                        listen: false);
                                tokenNotifier.setToken(state.token);
                                GetStorage()
                                    .write('user_token', state.token!);
                                GetStorage().write(
                                    'refresh_token', state.refreshToken!);
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
