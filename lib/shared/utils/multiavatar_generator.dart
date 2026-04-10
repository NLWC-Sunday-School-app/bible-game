import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Multiavatar SVG generator.
///
/// Note: flutter_js was removed for web compatibility (it uses dart:ffi).
/// Avatar generation now returns empty string, and the AvatarWidget
/// falls back to the default avatar image. To restore dynamic avatars,
/// re-add flutter_js to pubspec.yaml (mobile-only builds) or use a
/// pure Dart SVG avatar library.
class MultiavatarGenerator {
  MultiavatarGenerator();

  Future<void> loadJs() async {
    // No-op — flutter_js removed for web compatibility
  }

  Future<String> generateAvatar(String seed) async {
    // Returns empty so AvatarWidget shows the default avatar image
    return '';
  }
}
