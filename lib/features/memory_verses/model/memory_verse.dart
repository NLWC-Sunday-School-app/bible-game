import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class MemoryVerse {
  final String reference;
  final String text;

  const MemoryVerse({required this.reference, required this.text});

  factory MemoryVerse.fromJson(Map<String, dynamic> json) => MemoryVerse(
        reference: json['reference'] as String,
        text: json['text'] as String,
      );
}

class VerseTopic {
  final String id;
  final String name;
  final String tagline;
  final List<MemoryVerse> verses;

  const VerseTopic({
    required this.id,
    required this.name,
    required this.tagline,
    required this.verses,
  });

  factory VerseTopic.fromJson(Map<String, dynamic> json) => VerseTopic(
        id: json['id'] as String,
        name: json['name'] as String,
        tagline: json['tagline'] as String? ?? '',
        verses: (json['verses'] as List)
            .map((v) => MemoryVerse.fromJson(v as Map<String, dynamic>))
            .toList(),
      );
}

/// Loads the bundled memory verses asset shared by the app, the Android
/// home screen widget and the iOS WidgetKit extension.
class MemoryVerseData {
  static const String assetPath = 'assets/data/memory_verses.json';

  static List<VerseTopic>? _cache;

  static Future<List<VerseTopic>> loadTopics() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString(assetPath);
    final decoded = json.decode(raw) as Map<String, dynamic>;
    _cache = (decoded['topics'] as List)
        .map((t) => VerseTopic.fromJson(t as Map<String, dynamic>))
        .toList();
    return _cache!;
  }

  /// All verses across every topic, in a stable order — used to pick the
  /// verse of the hour for notifications.
  static Future<List<MemoryVerse>> loadAllVerses() async {
    final topics = await loadTopics();
    return [for (final t in topics) ...t.verses];
  }
}
