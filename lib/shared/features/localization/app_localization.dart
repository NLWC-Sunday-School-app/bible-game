import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lightweight localization service that loads JSON translation files.
/// Supports English (en) and French (fr) with device auto-detection
/// and manual language switching.
class AppLocalization {
  final Locale locale;
  late Map<String, String> _localizedStrings;

  AppLocalization(this.locale);

  static AppLocalization? of(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }

  /// Convenience accessor — short name for templates.
  static AppLocalization tr(BuildContext context) {
    return Localizations.of<AppLocalization>(context, AppLocalization)!;
  }

  Future<void> load() async {
    final jsonString = await rootBundle
        .loadString('assets/translations/${locale.languageCode}.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  /// Get a translated string by key. Returns the key itself if not found.
  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  /// Get a translated string with simple placeholder replacement.
  /// Usage: `t('scores_pending_sync', {'count': '3', 'plural': 's'})`
  String t(String key, [Map<String, String>? params]) {
    var text = _localizedStrings[key] ?? key;
    if (params != null) {
      params.forEach((paramKey, paramValue) {
        text = text.replaceAll('{$paramKey}', paramValue);
      });
    }
    return text;
  }

  /// Supported locales.
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('fr'),
  ];

  /// Persistence key.
  static const String _prefKey = 'app_language';

  /// Save user's preferred language.
  static Future<void> setLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, languageCode);
  }

  /// Get the saved locale, or null if none saved (auto-detect).
  static Future<Locale?> getSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefKey);
    if (code != null && code.isNotEmpty) {
      return Locale(code);
    }
    return null;
  }

  /// Resolve the best locale: saved preference > device locale > English.
  static Future<Locale> resolveLocale(List<Locale>? deviceLocales) async {
    final saved = await getSavedLocale();
    if (saved != null) return saved;

    if (deviceLocales != null && deviceLocales.isNotEmpty) {
      for (final deviceLocale in deviceLocales) {
        if (supportedLocales
            .any((l) => l.languageCode == deviceLocale.languageCode)) {
          return Locale(deviceLocale.languageCode);
        }
      }
    }
    return const Locale('en');
  }
}

/// LocalizationsDelegate that loads our JSON translations.
class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalization.supportedLocales
        .any((l) => l.languageCode == locale.languageCode);
  }

  @override
  Future<AppLocalization> load(Locale locale) async {
    final localization = AppLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;
}
