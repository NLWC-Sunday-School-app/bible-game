import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'bloc/settings_bloc.dart';


class SoundManager {
  final AudioPlayer clickPlayer = AudioPlayer();
  final AudioPlayer gameMusicPlayer = AudioPlayer();
  final AudioPlayer tabClickPlayer = AudioPlayer();
  final AudioPlayer achievementPlayer = AudioPlayer();
  final AudioPlayer correctAnswerPlayer = AudioPlayer();
  final AudioPlayer wrongAnswerPlayer = AudioPlayer();

  bool isSoundOn = true;
  bool isMusicOn = true;

  /// Tracks which players have had their asset loaded.
  final Set<AudioPlayer> _loaded = {};

  /// Loads the asset for [player] if it hasn't been loaded yet.
  Future<void> _ensureLoaded(AudioPlayer player, String asset) async {
    if (_loaded.contains(player)) return;
    try {
      await player.setAsset(asset);
      _loaded.add(player);
    } catch (e) {
      debugPrint('SoundManager: could not load $asset: $e');
    }
  }

  void updateSettings(SettingsState state) {
    isSoundOn = state.isSoundOn;
    isMusicOn = state.isMusicOn;

    if (!isMusicOn) {
      gameMusicPlayer.stop();
    } else {
      playGameMusic();
    }
  }

  Future<void> _safePlay(AudioPlayer player, String asset, {double volume = 0.5}) async {
    if (!isSoundOn) return;
    try {
      await _ensureLoaded(player, asset);
      await player.seek(Duration.zero);
      await player.setVolume(volume);
      await player.play();
    } catch (e) {
      debugPrint('SoundManager: playback error: $e');
    }
  }

  void playClickSound() => _safePlay(clickPlayer, 'assets/sounds/click.mp3');

  void playGameMusic() async {
    if (!isMusicOn) return;
    await _ensureLoaded(gameMusicPlayer, 'assets/sounds/game_music.mp3');
    gameMusicPlayer.setLoopMode(LoopMode.one);
    gameMusicPlayer.setVolume(0.1);
    gameMusicPlayer.play();
  }

  void pauseGameMusic(){
    gameMusicPlayer.pause();
  }

  void stopGameMusic() {
    gameMusicPlayer.stop();
  }

  void playTabClickSound() => _safePlay(tabClickPlayer, 'assets/sounds/tab_click.mp3');

  void playAchievementSound() => _safePlay(achievementPlayer, 'assets/sounds/achievement.mp3', volume: 1.0);

  void playCorrectAnswerSound() => _safePlay(correctAnswerPlayer, 'assets/sounds/correct_answer.mp3', volume: 1.0);

  void playWrongAnswerSound() => _safePlay(wrongAnswerPlayer, 'assets/sounds/wrong_answer.m4a', volume: 1.0);

  void dispose() {
    clickPlayer.dispose();
    gameMusicPlayer.dispose();
    tabClickPlayer.dispose();
    achievementPlayer.dispose();
    correctAnswerPlayer.dispose();
    wrongAnswerPlayer.dispose();
  }
}
