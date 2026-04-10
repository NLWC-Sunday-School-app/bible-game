import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/features/home/widget/modals/reset_password_modal.dart';
import 'package:bible_game/features/home/widget/modals/successful_login_modal.dart';
import 'package:bible_game/features/pilgrim_progress/bloc/pilgrim_progress_bloc.dart';
import 'package:bible_game/shared/constants/app_routes.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import '../../../../app.dart';
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
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
          backgroundColor: Colors.transparent,
          insetAnimationCurve: Curves.easeIn,
          insetAnimationDuration: const Duration(milliseconds: 500),
          child: LoginModal(),
        );
      });
}

class LoginModal extends StatefulWidget {
  const LoginModal({super.key});


  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _hasToggledPasswordVisibility = true;
  final DeviceInfoService _deviceInfoService = DeviceInfoService();
  Map<String, String> _deviceInfo = {};
  bool _deviceInfoLoaded = false;

  void togglePasswordVisibility() {
    setState(() {
      _hasToggledPasswordVisibility = !_hasToggledPasswordVisibility;
    });
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
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SizedBox(
        height: 550.h,
        width: 500.w,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ProductImageRoutes.modalBg),
              fit: BoxFit.fill,
            ),
          ),
          child: Form(
            key: _loginFormKey,
            child: Column(
              children: [
                SizedBox(
                  height: 50.h,
                ),
                GestureDetector(
                  onTap: () {
                    soundManager.playClickSound();
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          IconImageRoutes.closeModal,
                          width: 35.w,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                StrokeText(
                  text: 'Log in to play',
                  textStyle: TextStyle(
                    color: const Color(0xFF1768B9),
                    fontFamily: 'Mikado',
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  strokeColor: Colors.white,
                  strokeWidth: 5,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  'Pick up from where you stopped!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 45.0.w),
                  child: SizedBox(
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      textInputAction: TextInputAction.next,
                      style: TextStyle(
                        height: 1.5.h,
                        color: const Color(0xFF104387),
                        fontSize: 14.sp,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFD4DDDF),
                        focusColor: Colors.red,
                        errorStyle: TextStyle(fontSize: 12.sp),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: 'Input your email',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              color: Color(0xFFD4DDDF),
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                                color: Color(0xFFD4DDDF), width: 1.5)),
                      ),
                      validator: (text) {
                        return Validator.validateEmail(text!);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 45.0.w),
                  child: SizedBox(
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      controller: passwordController,
                      obscureText: _hasToggledPasswordVisibility,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submitLogin(soundManager),
                      style: TextStyle(
                        height: 1.h,
                        color: const Color(0xFF104387),
                      ),
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () => togglePasswordVisibility(),
                          child: Image.asset(
                            _hasToggledPasswordVisibility
                                ? IconImageRoutes.eyeClose
                                : IconImageRoutes.eyeOpen,
                            scale: 1.5,
                          ),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFD4DDDF),
                        errorStyle: TextStyle(fontSize: 12.sp),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        hintText: 'Password',
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: const BorderSide(
                              color: Color(0xFFD4DDDF),
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                            borderSide: BorderSide(
                              color: Color(0xFFD4DDDF),
                              width: 1.5.w,
                            )),
                      ),
                      validator: (text) {
                        return Validator.validatePassword(text!);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                BlocConsumer<AuthenticationBloc, AuthenticationState>(
                  listenWhen: (prev, curr) =>
                      prev.failedToLogin != curr.failedToLogin ||
                      prev.token != curr.token,
                  listener: (context, state) {
                    if (state.failedToLogin) {
                      // Show specific error from API if available, otherwise generic message
                      final errorMsg = ApiException.errorMessage;
                      if (errorMsg.isNotEmpty) {
                        ApiException.showSnackBar(context);
                      } else {
                        Flushbar(
                          message: 'Invalid email or password. Please try again.',
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
                          Provider.of<TokenNotifier>(context, listen: false);
                      tokenNotifier.setToken(state.token);
                      GetStorage().write('user_token', state.token!);
                      GetStorage().write('refresh_token', state.refreshToken!);
                      Navigator.pop(context);
                      showSuccessfulLoginModal(context);
                    }
                  },
                  builder: (context, state) {
                    return BlueButton(
                      width: 250.w,
                      buttonText: 'Login',
                      buttonIsLoading: state.isLoadingLogin,
                      onTap: () => _submitLogin(soundManager),
                    );
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    showResetPasswordModal(context);
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: const Color(0xFF4075BB),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Mikado',
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
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
