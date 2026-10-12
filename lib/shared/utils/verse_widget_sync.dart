import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Tells the home screen widgets how often the verse changes and which topics
/// it comes from, so they follow the same settings as the lock screen verses.
///
/// Neither widget can read what the app stores, so the native side keeps its
/// own copy -- iOS in the shared App Group -- and both platforms refresh the
/// widget straight away rather than at its next scheduled update.
class VerseWidgetSync {
  static const _channel = MethodChannel('bible_game/verse_widget');

  static Future<void> update({
    required int hours,
    required List<String> topics,
  }) async {
    if (kIsWeb) return;
    try {
      await _channel.invokeMethod<void>(
          'update', {'hours': hours, 'topics': topics});
    } on MissingPluginException {
      // Platforms without a widget.
    } catch (e) {
      debugPrint('⚠️ Could not update the verse widget: $e');
    }
  }
}
