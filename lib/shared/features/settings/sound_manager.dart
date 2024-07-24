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


  SoundManager() {
    // Load audio files
    clickPlayer.setAsset('assets/sounds/click.mp3');
    gameMusicPlayer.setAsset('assets/sounds/game_music.mp3');
    tabClickPlayer.setAsset('assets/sounds/tab_click.mp3');
    achievementPlayer.setAsset('assets/sounds/achievement.mp3');
    correctAnswerPlayer.setAsset('assets/sounds/correct_answer.mp3');
    wrongAnswerPlayer.setAsset('assets/sounds/wrong_answer.wav');
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

  void playClickSound() {
    if (isSoundOn) {
      clickPlayer.seek(Duration.zero);
      clickPlayer.setVolume(0.5);
      clickPlayer.play();
    }
  }

  void playGameMusic() {
    if (isMusicOn) {
      gameMusicPlayer.setLoopMode(LoopMode.one);
      gameMusicPlayer.setVolume(0.2);
      gameMusicPlayer.play();
    }
  }

  void stopGameMusic() {
    gameMusicPlayer.stop();
  }

  void playTabClickSound() {
    if (isSoundOn) {
      tabClickPlayer.seek(Duration.zero);
      tabClickPlayer.setVolume(0.5);
      tabClickPlayer.play();
    }
  }

  void playAchievementSound() {
    if (isSoundOn) {
      achievementPlayer.seek(Duration.zero);
      achievementPlayer.play();
    }
  }

  void playCorrectAnswerSound() {
    if (isSoundOn) {
      correctAnswerPlayer.seek(Duration.zero);
      correctAnswerPlayer.play();
    }
  }

  void playWrongAnswerSound() {
    if (isSoundOn) {
      wrongAnswerPlayer.seek(Duration.zero);
      wrongAnswerPlayer.play();
    }
  }

  void dispose() {
    clickPlayer.dispose();
    gameMusicPlayer.dispose();
    tabClickPlayer.dispose();
    achievementPlayer.dispose();
    correctAnswerPlayer.dispose();
    wrongAnswerPlayer.dispose();
  }
}
