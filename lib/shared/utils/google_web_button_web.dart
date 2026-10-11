import 'package:flutter/widgets.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

/// Google's rendered "Continue with Google" button. On web this is the only
/// way to get an ID token: the custom button's signIn() uses the OAuth token
/// client, which returns an access token and nothing the backend can verify.
/// The signed-in account arrives on GoogleSignIn.onCurrentUserChanged.
Widget googleWebSignInButton({required double width}) => web.renderButton(
      configuration: web.GSIButtonConfiguration(
        type: web.GSIButtonType.standard,
        theme: web.GSIButtonTheme.filledBlue,
        size: web.GSIButtonSize.large,
        text: web.GSIButtonText.continueWith,
        shape: web.GSIButtonShape.pill,
        // Google draws the button between 200 and 400 pixels wide.
        minimumWidth: width.clamp(200, 400).toDouble(),
      ),
    );
