import 'package:bible_game/shared/utils/registration_push_token.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/localization/app_localization.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:bible_game/shared/utils/device_info.dart';
import 'package:bible_game/shared/utils/google_auth_service.dart';
import 'package:bible_game/shared/utils/token_notifier.dart';
import 'package:bible_game/shared/widgets/blue_button.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../global_challenge/bloc/global_challenge_bloc.dart';
import 'successful_login_modal.dart';
import '../../../../shared/utils/custom_toast.dart';

/// "Continue with Google" — signs the user in with Google purely for
/// identity (name + email), then reuses the existing register/login
/// endpoints under the hood. See AuthenticationBloc._onGoogleSignInRequested
/// and GoogleAuthService for why no new backend endpoint was needed.
class GoogleSignInButton extends StatefulWidget {
  /// Whether this button lives inside a Dialog that should be popped on a
  /// successful sign-in (the login/create-profile/auth modals) as opposed
  /// to being embedded directly in a screen (e.g. LoginGateWidget), where
  /// popping would navigate away from the screen instead of just dismissing
  /// a dialog — those screens already rebuild themselves once the
  /// AuthenticationBloc reports the user as logged in.
  final bool isInsideDialog;

  const GoogleSignInButton({super.key, this.isInsideDialog = true});

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  final DeviceInfoService _deviceInfoService = DeviceInfoService();

  // Tracks the native Google popup + the initial dispatch, before the bloc's
  // own isLoadingGoogleSignIn flag takes over.
  bool _isBusy = false;

  Future<void> _handleTap(BuildContext context, dynamic soundManager) async {
    soundManager.playClickSound();
    setState(() => _isBusy = true);

    try {
      final idToken = await GoogleAuthService.signIn();
      if (idToken == null) {
        // User cancelled the Google account picker.
        if (mounted) setState(() => _isBusy = false);
        return;
      }

      final fcmToken = await registrationPushToken();
      final deviceInfo = await _deviceInfoService.getDeviceInfo();

      if (!mounted) return;
      context.read<AuthenticationBloc>().add(
            AuthenticationGoogleSignInRequested(
              idToken,
              _detectCountryName(),
              fcmToken,
              deviceInfo['deviceName'] ?? 'Unknown',
              deviceInfo['osVersion'] ?? 'Unknown',
            ),
          );
    } catch (e, stack) {
      // Logged, not swallowed. Every failure used to become the same "sign-in
      // failed" toast, so an unregistered signing certificate (ApiException
      // 10), a network error and a missing ID token all looked identical --
      // which is how Android sign-in could stay broken without anyone seeing
      // why.
      debugPrint('⚠️ Google sign-in failed: $e');
      debugPrint('$stack');
      if (mounted) {
        setState(() => _isBusy = false);
        _showError(context);
      }
    }
  }

  /// The backend's register endpoint requires a country and Google doesn't
  /// hand us one, so infer it from the device locale instead of prompting.
  String _detectCountryName() {
    try {
      final code = View.of(context).platformDispatcher.locale.countryCode;
      return CountryService().findByCode(code)?.name ?? 'Unknown';
    } catch (_) {
      return 'Unknown';
    }
  }

  void _showError(BuildContext context) {
    final tr = AppLocalization.tr(context);
    CustomToast.showBanner(context, tr.t('auth_google_signin_failed'), isError: true);
  }

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    final tr = AppLocalization.tr(context);

    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listenWhen: (prev, curr) =>
          prev.failedGoogleSignIn != curr.failedGoogleSignIn ||
          prev.token != curr.token,
      listener: (context, state) {
        if (state.failedGoogleSignIn) {
          setState(() => _isBusy = false);
          _showError(context);
        }
        if (state.token != null) {
          setState(() => _isBusy = false);
          BlocProvider.of<GlobalChallengeBloc>(context)
              .add(FetchGlobalChallengeGames());
          final tokenNotifier =
              Provider.of<TokenNotifier>(context, listen: false);
          tokenNotifier.setToken(state.token);
          GetStorage().write('user_token', state.token!);
          GetStorage().write('refresh_token', state.refreshToken!);
          if (widget.isInsideDialog) Navigator.pop(context);
          showSuccessfulLoginModal(context);
        }
      },
      builder: (context, state) {
        final isLoading = _isBusy || state.isLoadingGoogleSignIn;
        return BlueButton(
          width: double.infinity,
          buttonText: '',
          buttonIsLoading: false,
          hasCustomWidget: true,
          isActive: false,
          onTap: isLoading ? null : () => _handleTap(context, soundManager),
          customWidget: Center(
            child: isLoading
                ? SizedBox(
                    height: 20.w,
                    width: 20.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF4A9EFF),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.string(
                        _googleGLogoSvg,
                        width: 20.w,
                        height: 20.w,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        tr.t('auth_continue_with_google'),
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

const _googleGLogoSvg = '''
<svg width="18" height="18" viewBox="0 0 18 18" xmlns="http://www.w3.org/2000/svg">
  <path fill="#4285F4" d="M17.64 9.2045c0-.6381-.0573-1.2518-.1636-1.8409H9v3.4814h4.8436c-.2086 1.125-.8427 2.0782-1.7959 2.7164v2.2582h2.9087c1.7018-1.5668 2.6836-3.8741 2.6836-6.6151z"/>
  <path fill="#34A853" d="M9 18c2.43 0 4.4673-.806 5.9564-2.1805l-2.9087-2.2582c-.8059.54-1.8368.8591-3.0477.8591-2.344 0-4.3282-1.5831-5.036-3.7104H.9573v2.3318C2.4382 15.9832 5.4818 18 9 18z"/>
  <path fill="#FBBC05" d="M3.964 10.71c-.18-.54-.2822-1.1168-.2822-1.71s.1023-1.17.2823-1.71V4.9582H.9573A8.9965 8.9965 0 000 9c0 1.4523.3477 2.8268.9573 4.0418L3.964 10.71z"/>
  <path fill="#EA4335" d="M9 3.5795c1.3214 0 2.5077.4541 3.4405 1.346l2.5813-2.5814C13.4632.8918 11.4259 0 9 0 5.4818 0 2.4382 2.0168.9573 4.9582L3.964 7.29C4.6718 5.1627 6.656 3.5795 9 3.5795z"/>
</svg>
''';
