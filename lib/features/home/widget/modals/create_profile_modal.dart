import 'package:another_flushbar/flushbar.dart';
import 'package:bible_game/shared/features/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/features/home/widget/modals/successful_registration_modal.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../../shared/constants/image_routes.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../../shared/utils/device_info.dart';
import '../../../../shared/utils/token_notifier.dart';
import '../../../../shared/utils/validation.dart';
import '../../../../shared/widgets/blue_button.dart';
import 'package:provider/provider.dart';
import 'package:bible_game_api/utils/api_exception.dart';

import '../../../global_challenge/bloc/global_challenge_bloc.dart';

void showCreateProfileModal(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.75),
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        backgroundColor: Colors.transparent,
        child: const CreateProfileModal(),
      );
    },
  );
}

class CreateProfileModal extends StatefulWidget {
  const CreateProfileModal({super.key});

  @override
  State<CreateProfileModal> createState() => _CreateProfileModalState();
}

class _CreateProfileModalState extends State<CreateProfileModal>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  final DeviceInfoService _deviceInfoService = DeviceInfoService();
  Map<String, String> _deviceInfo = {};
  bool _deviceInfoLoaded = false;

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  String countryName = '';
  bool _obscurePassword = true;
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
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    countryController.dispose();
    _usernameFocus.dispose();
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
                  // ── Header with three stars & rocket ──
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
                          top: 14.h,
                          left: 24.w,
                          child: Image.asset(
                            IconImageRoutes.star,
                            width: 16.w,
                            opacity: const AlwaysStoppedAnimation(0.35),
                          ),
                        ),
                        Positioned(
                          top: 40.h,
                          right: 26.w,
                          child: Image.asset(
                            IconImageRoutes.star,
                            width: 14.w,
                            opacity: const AlwaysStoppedAnimation(0.3),
                          ),
                        ),
                        Positioned(
                          bottom: 22.h,
                          left: 40.w,
                          child: Image.asset(
                            IconImageRoutes.star,
                            width: 10.w,
                            opacity: const AlwaysStoppedAnimation(0.2),
                          ),
                        ),
                        Positioned(
                          bottom: 35.h,
                          right: 50.w,
                          child: Image.asset(
                            IconImageRoutes.star,
                            width: 8.w,
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
                          padding: EdgeInsets.only(top: 24.h, bottom: 36.h),
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
                                  ProductImageRoutes.rocket,
                                  width: 50.w,
                                  height: 50.w,
                                ),
                              ),
                              SizedBox(height: 14.h),
                              // Three stars decoration
                              Image.asset(
                                ProductImageRoutes.threeStars,
                                width: 80.w,
                                opacity: const AlwaysStoppedAnimation(0.7),
                              ),
                              SizedBox(height: 8.h),
                              StrokeText(
                                text: tr.t('auth_create_profile'),
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Mikado',
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                                strokeColor: const Color(0xFF0A3060),
                                strokeWidth: 5,
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                tr.t('auth_create_profile_subtitle'),
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

                  // ── Gold divider ──
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
                    padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
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
                      key: _registerFormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Username
                          TextFormField(
                            keyboardType: TextInputType.text,
                            controller: userNameController,
                            focusNode: _usernameFocus,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) => FocusScope.of(context)
                                .requestFocus(_emailFocus),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp("[A-Za-z0-9#-]*"),
                              ),
                            ],
                            decoration: _inputDecoration(
                              hint: tr.t('auth_nickname_hint'),
                              prefixIcon: Icons.person_outline_rounded,
                            ),
                            validator: (text) =>
                                Validator.validateName(text!),
                          ),
                          SizedBox(height: 14.h),

                          // Email
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            focusNode: _emailFocus,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (_) =>
                                FocusScope.of(context)
                                    .requestFocus(_passwordFocus),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                            decoration: _inputDecoration(
                              hint: tr.t('auth_email_hint'),
                              prefixIcon: Icons.mail_outline_rounded,
                            ),
                            validator: (text) =>
                                Validator.validateEmail(text!),
                          ),
                          SizedBox(height: 14.h),

                          // Country
                          TextFormField(
                            controller: countryController,
                            readOnly: true,
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              showCountryPicker(
                                context: context,
                                showPhoneCode: false,
                                onSelect: (Country country) {
                                  setState(() => countryController.text =
                                      '${country.flagEmoji} ${country.name}');
                                  countryName = country.name;
                                },
                              );
                            },
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                            decoration: _inputDecoration(
                              hint: tr.t('auth_country_hint'),
                              prefixIcon: Icons.public_rounded,
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: const Color(0xFF4A6A8A),
                                  size: 28.sp,
                                ),
                              ),
                            ),
                            validator: (text) =>
                                Validator.validateCountry(text!),
                          ),
                          SizedBox(height: 14.h),

                          // Password
                          TextFormField(
                            obscureText: _obscurePassword,
                            controller: passwordController,
                            focusNode: _passwordFocus,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) =>
                                _submitRegistration(soundManager),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                            keyboardType: TextInputType.visiblePassword,
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
                          SizedBox(height: 24.h),

                          // Register button
                          BlocConsumer<AuthenticationBloc,
                              AuthenticationState>(
                            listenWhen: (prev, curr) =>
                                prev.failedToRegister !=
                                    curr.failedToRegister ||
                                prev.token != curr.token,
                            listener: (context, state) {
                              if (state.failedToRegister) {
                                final errorMsg = ApiException.errorMessage;
                                if (errorMsg.isNotEmpty) {
                                  ApiException.showSnackBar(context);
                                } else {
                                  Flushbar(
                                    message:
                                        tr.t('auth_registration_failed'),
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
                                showSuccessfulRegistrationModal(context);
                              }
                            },
                            builder: (context, state) {
                              return BlueButton(
                                width: double.infinity,
                                buttonText: tr.t('auth_create_profile'),
                                buttonIsLoading: state.isLoadingLogin,
                                onTap: () =>
                                    _submitRegistration(soundManager),
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

  void _submitRegistration(dynamic soundManager) async {
    soundManager.playClickSound();
    FocusScope.of(context).unfocus();
    if (_registerFormKey.currentState!.validate()) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final fcmToken = prefs.getString('fcmToken') ?? '';
      final deviceName = _deviceInfoLoaded
          ? (_deviceInfo['deviceName'] ?? 'Unknown')
          : 'Unknown';
      final deviceOs = _deviceInfoLoaded
          ? (_deviceInfo['osVersion'] ?? 'Unknown')
          : 'Unknown';
      BlocProvider.of<AuthenticationBloc>(context)
          .add(AuthenticationRegisterRequested(
        userNameController.text,
        emailController.text,
        passwordController.text,
        fcmToken,
        countryName,
        deviceName,
        deviceOs,
      ));
    }
  }
}
