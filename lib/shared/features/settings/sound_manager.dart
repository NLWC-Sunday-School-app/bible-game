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
  bool _assetsLoaded = false;


  SoundManager() {
    _loadAssets();
  }

  Future<void> _loadAssets() async {
    try {
      await clickPlayer.setAsset('assets/sounds/click.mp3');
      await gameMusicPlayer.setAsset('assets/sounds/game_music.mp3');
      await tabClickPlayer.setAsset('assets/sounds/tab_click.mp3');
      await achievementPlayer.setAsset('assets/sounds/achievement.mp3');
      await correctAnswerPlayer.setAsset('assets/sounds/correct_answer.mp3');
      await wrongAnswerPlayer.setAsset('assets/sounds/wrong_answer.m4a');
      _assetsLoaded = true;
    } catch (e) {
      debugPrint('SoundManager: could not load audio assets: $e');
    }
  }

  void updateSettings(SettingsState state) {
    isSoundOn = state.isSoundOn;
    isMusicOn = state.isMusicOn;

    if (!isMusicOn) {
      gameMusicPlayer.stop();
    } else {
      gameMusicPlayer.setLoopMode(LoopMode.one);
      gameMusicPlayer.play();
    }
  }

  Future<void> _safePlay(AudioPlayer player, {double volume = 0.5}) async {
    if (!isSoundOn) return;
    try {
      if (!_assetsLoaded) await _loadAssets();
      await player.seek(Duration.zero);
      await player.setVolume(volume);
      await player.play();
    } catch (e) {
      debugPrint('SoundManager: playback error: $e');
    }
  }

  void playClickSound() => _safePlay(clickPlayer);

  void playGameMusic() {
    if (isMusicOn) {
      gameMusicPlayer.setLoopMode(LoopMode.one);
      gameMusicPlayer.setVolume(0.1);
      gameMusicPlayer.play();
    }
  }

  void pauseGameMusic(){
    gameMusicPlayer.pause();
  }

  void stopGameMusic() {
    gameMusicPlayer.stop();
  }

  void playTabClickSound() => _safePlay(tabClickPlayer);

  void playAchievementSound() => _safePlay(achievementPlayer, volume: 1.0);

  void playCorrectAnswerSound() => _safePlay(correctAnswerPlayer, volume: 1.0);

  void playWrongAnswerSound() => _safePlay(wrongAnswerPlayer, volume: 1.0);

  void dispose() {
    clickPlayer.dispose();
    gameMusicPlayer.dispose();
    tabClickPlayer.dispose();
    achievementPlayer.dispose();
    correctAnswerPlayer.dispose();
    wrongAnswerPlayer.dispose();
  }
}
