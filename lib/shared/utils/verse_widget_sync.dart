import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Tells the home screen widgets how often the verse changes, so they follow
/// the same setting as the lock screen verses instead of always changing hourly.
///
/// iOS widgets cannot read the app's preferences, so the native side copies
/// the value into the shared App Group; both platforms then refresh the widget
/// straight away rather than at its next scheduled update.
class VerseWidgetSync {
  static const _channel = MethodChannel('bible_game/verse_widget');

  static Future<void> setFrequency(int hours) async {
    if (kIsWeb) return;
    try {
      await _channel.invokeMethod<void>('setFrequency', {'hours': hours});
    } on MissingPluginException {
      // Platforms without a widget.
    } catch (e) {
      debugPrint('⚠️ Could not update the verse widget: $e');
    }
  }
}
