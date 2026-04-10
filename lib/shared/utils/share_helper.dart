import 'dart:typed_data';
import 'package:flutter/material.dart';

// Conditional imports — dart:io for mobile, dart:js_interop for web
import 'share_helper_stub.dart'
    if (dart.library.io) 'share_helper_mobile.dart'
    if (dart.library.js_interop) 'share_helper_web.dart' as platform_share;

/// Platform-aware screenshot sharing.
/// On mobile: saves to temp file and uses Share.shareFiles.
/// On web: triggers a browser download of the image.
Future<void> shareScreenshot({
  required Uint8List imageBytes,
  required BuildContext context,
  String subject = '',
}) async {
  await platform_share.shareScreenshotImpl(
    imageBytes: imageBytes,
    context: context,
    subject: subject,
  );
}
