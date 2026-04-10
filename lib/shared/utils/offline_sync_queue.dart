import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// A SharedPreferences-backed FIFO queue that stores pending play logs
/// for offline game completions. Each entry mirrors the `/playlog` POST body.
class OfflineSyncQueue {
  static const _key = 'offline_sync_queue';

  /// Add a play log entry to the end of the queue.
  Future<void> enqueue(Map<String, dynamic> playLog) async {
    final prefs = await SharedPreferences.getInstance();
    final list = _readQueue(prefs);
    list.add(playLog);
    await prefs.setString(_key, jsonEncode(list));
  }

  /// Return all queued entries without removing them.
  Future<List<Map<String, dynamic>>> peekAll() async {
    final prefs = await SharedPreferences.getInstance();
    return _readQueue(prefs);
  }

  /// Remove the first (oldest) item from the queue.
  Future<void> dequeue() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _readQueue(prefs);
    if (list.isNotEmpty) {
      list.removeAt(0);
      await prefs.setString(_key, jsonEncode(list));
    }
  }

  /// Clear all pending entries.
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  /// Number of entries waiting to be synced.
  Future<int> get pendingCount async {
    final prefs = await SharedPreferences.getInstance();
    return _readQueue(prefs).length;
  }

  /// Sum of `total_score` across all queued entries.
  Future<int> get pendingCoins async {
    final prefs = await SharedPreferences.getInstance();
    final list = _readQueue(prefs);
    int total = 0;
    for (final entry in list) {
      total += (entry['total_score'] as num?)?.toInt() ?? 0;
    }
    return total;
  }

  List<Map<String, dynamic>> _readQueue(SharedPreferences prefs) {
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw) as List;
      return decoded
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
