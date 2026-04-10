import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bible_game/shared/utils/offline_sync_queue.dart';

void main() {
  late OfflineSyncQueue queue;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    queue = OfflineSyncQueue();
  });

  Map<String, dynamic> _makePlayLog({
    String gameMode = 'TRUE_OR_FALSE',
    int totalScore = 1000,
  }) {
    return {
      'game_mode': gameMode,
      'total_score': totalScore,
      'base_score': totalScore,
      'bonus_score': 0,
      'average_time_spent': 0,
      'player_rank': 'babe',
      'number_of_correct_answers': 10,
      'player_id': 1,
      'user_progress': null,
      'number_of_rounds': 20,
      'deviceName': 'TestDevice',
      'deviceOs': 'TestOS',
    };
  }

  group('OfflineSyncQueue', () {
    test('starts empty', () async {
      expect(await queue.pendingCount, 0);
      expect(await queue.pendingCoins, 0);
      expect(await queue.peekAll(), isEmpty);
    });

    test('enqueue adds an entry', () async {
      await queue.enqueue(_makePlayLog());

      expect(await queue.pendingCount, 1);
      expect(await queue.pendingCoins, 1000);
    });

    test('enqueue multiple entries', () async {
      await queue.enqueue(_makePlayLog(totalScore: 500));
      await queue.enqueue(_makePlayLog(totalScore: 750));
      await queue.enqueue(_makePlayLog(totalScore: 1250));

      expect(await queue.pendingCount, 3);
      expect(await queue.pendingCoins, 2500);
    });

    test('peekAll returns all entries without removing them', () async {
      await queue.enqueue(_makePlayLog(gameMode: 'QUICK_GAME'));
      await queue.enqueue(_makePlayLog(gameMode: 'TRUE_OR_FALSE'));

      final entries = await queue.peekAll();
      expect(entries.length, 2);
      expect(entries[0]['game_mode'], 'QUICK_GAME');
      expect(entries[1]['game_mode'], 'TRUE_OR_FALSE');

      // Still there after peeking
      expect(await queue.pendingCount, 2);
    });

    test('dequeue removes the first (oldest) entry', () async {
      await queue.enqueue(_makePlayLog(gameMode: 'FIRST'));
      await queue.enqueue(_makePlayLog(gameMode: 'SECOND'));
      await queue.enqueue(_makePlayLog(gameMode: 'THIRD'));

      await queue.dequeue();

      final entries = await queue.peekAll();
      expect(entries.length, 2);
      expect(entries[0]['game_mode'], 'SECOND');
      expect(entries[1]['game_mode'], 'THIRD');
    });

    test('dequeue on empty queue does nothing', () async {
      await queue.dequeue(); // should not throw
      expect(await queue.pendingCount, 0);
    });

    test('clear removes all entries', () async {
      await queue.enqueue(_makePlayLog());
      await queue.enqueue(_makePlayLog());
      await queue.enqueue(_makePlayLog());

      await queue.clear();

      expect(await queue.pendingCount, 0);
      expect(await queue.pendingCoins, 0);
      expect(await queue.peekAll(), isEmpty);
    });

    test('pendingCoins sums total_score across entries', () async {
      await queue.enqueue(_makePlayLog(totalScore: 100));
      await queue.enqueue(_makePlayLog(totalScore: 0)); // devotional
      await queue.enqueue(_makePlayLog(totalScore: 2500));

      expect(await queue.pendingCoins, 2600);
    });

    test('handles entries with null total_score gracefully', () async {
      await queue.enqueue({
        'game_mode': 'DAILY_DEVOTIONAL',
        'total_score': null,
        'base_score': 0,
      });

      expect(await queue.pendingCoins, 0);
      expect(await queue.pendingCount, 1);
    });

    test('persists across queue instances', () async {
      await queue.enqueue(_makePlayLog(totalScore: 999));

      // Create a new instance — should read from same SharedPreferences
      final queue2 = OfflineSyncQueue();
      expect(await queue2.pendingCount, 1);
      expect(await queue2.pendingCoins, 999);
    });

    test('FIFO order preserved through multiple enqueue/dequeue cycles',
        () async {
      await queue.enqueue(_makePlayLog(gameMode: 'A'));
      await queue.enqueue(_makePlayLog(gameMode: 'B'));
      await queue.dequeue(); // removes A
      await queue.enqueue(_makePlayLog(gameMode: 'C'));
      await queue.dequeue(); // removes B

      final entries = await queue.peekAll();
      expect(entries.length, 1);
      expect(entries[0]['game_mode'], 'C');
    });
  });
}
