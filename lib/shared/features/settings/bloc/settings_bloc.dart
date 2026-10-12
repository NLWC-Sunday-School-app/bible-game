import 'package:bible_game/features/memory_verses/model/memory_verse.dart';
import 'package:bible_game_api/model/game_ads.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/awesome_notification.dart';
import '../../../utils/hourly_verse_notification.dart';
import '../../../utils/verse_frequency.dart';
import '../../../utils/verse_topics.dart';
import '../../../utils/verse_widget_sync.dart';

import '../../user/repository/user_repository.dart';
import '../sound_manager.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SoundManager soundManager;
  final UserRepository _userRepository;

  SettingsBloc(this.soundManager, {required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SettingsState.initial()) {
    on<ToggleSound>(_onToggleSound);
    on<ToggleMusic>(_onToggleMusic);
    on<TogglePushNotifications>(_onTogglePushNotifications);
    on<FetchGamePlaySettings>(_onFetchGamePlaySettings);
    on<FetchAds>(_onFetchAds);
    on<UpdateSoundState>(_onUpdateSoundState);
    on<LoadNotificationSetting>(_onLoadNotificationSetting);
    on<SetVerseFrequency>(_onSetVerseFrequency);
    on<SetVerseTopics>(_onSetVerseTopics);

    // Restore the stored preference so the toggle reflects reality on launch.
    add(LoadNotificationSetting());
  }

  Future<void> _onLoadNotificationSetting(
      LoadNotificationSetting event, Emitter<SettingsState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    await retireVerseOffSwitch(prefs);
    emit(state.copyWith(
      isPushOn: prefs.getBool(AwesomeNotification.pushPrefKey) ?? true,
      verseFrequencyHours:
          resolveVerseFrequency(prefs.getInt(kVerseFrequencyPrefKey)),
    ));
    try {
      emit(state.copyWith(verseTopics: await loadVerseTopicIds()));
    } catch (e) {
      debugPrint('\u26A0\uFE0F Could not load verse topics: $e');
    }
  }

  /// Changing the frequency reschedules immediately, so the choice takes
  /// effect now rather than at the next launch.
  Future<void> _onSetVerseFrequency(
      SetVerseFrequency event, Emitter<SettingsState> emit) async {
    final hours = resolveVerseFrequency(event.hours);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(kVerseFrequencyPrefKey, hours);
    emit(state.copyWith(verseFrequencyHours: hours));
    await _applyVerseSettings();
  }

  /// Same as the frequency: the widgets and the lock screen verses switch to
  /// the new topics now.
  Future<void> _onSetVerseTopics(
      SetVerseTopics event, Emitter<SettingsState> emit) async {
    final topics = await MemoryVerseData.loadTopics();
    final ids =
        resolveVerseTopics(event.topicIds, [for (final t in topics) t.id]);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(kVerseTopicsPrefKey, ids);
    emit(state.copyWith(verseTopics: ids));
    await _applyVerseSettings();
  }

  Future<void> _applyVerseSettings() async {
    final topics = state.verseTopics.isEmpty
        ? await loadVerseTopicIds()
        : state.verseTopics;
    await VerseWidgetSync.update(
        hours: state.verseFrequencyHours, topics: topics);

    try {
      await HourlyVerseNotification.scheduleHourlyVerses(
          everyHours: state.verseFrequencyHours, topics: topics);
    } catch (e) {
      debugPrint('\u26A0\uFE0F Could not reschedule verses: $e');
    }
  }

  void _onToggleSound(ToggleSound event, Emitter<SettingsState> emit)async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final newState = state.copyWith(isSoundOn: !state.isSoundOn);
    await prefs.setBool('isSoundOn', !state.isSoundOn);
    emit(newState);
    soundManager.updateSettings(newState);
  }

  void _onToggleMusic(ToggleMusic event, Emitter<SettingsState> emit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final newState = state.copyWith(isMusicOn: !state.isMusicOn);
    await prefs.setBool('isMusicOn', !state.isMusicOn);
    emit(newState);
    soundManager.updateSettings(newState);
  }

  /// Off deletes this device's push token and, for a signed-in user, clears
  /// the one the backend sends to; on registers a fresh one. The app's own
  /// scheduled notifications are untouched either way.
  Future<void> _onTogglePushNotifications(
      TogglePushNotifications event, Emitter<SettingsState> emit) async {
    final enabled = !state.isPushOn;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AwesomeNotification.pushPrefKey, enabled);
    emit(state.copyWith(isPushOn: enabled));

    try {
      final signedIn =
          (GetStorage().read('user_token') as String?)?.isNotEmpty ?? false;
      if (enabled) {
        final token = await AwesomeNotification.getFirebaseMessagingToken();
        if (token.isEmpty) return;
        await prefs.setString('fcmToken', token);
        if (signedIn) await _userRepository.updateUserFCMToken(token);
      } else {
        await AwesomeNotification.deleteFirebaseMessagingToken();
        await prefs.remove('fcmToken');
        if (signedIn) await _userRepository.updateUserFCMToken('');
      }
    } catch (e) {
      debugPrint('\u26A0\uFE0F Push notification toggle: $e');
    }
  }

  Future<void> _onFetchAds(FetchAds event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(isLoadingAds: true));
    try {
      final response = await _userRepository.getAds();
      emit(state.copyWith(isLoadingAds: false, adContent: response));
    } catch (_) {
      emit(state.copyWith(isLoadingAds: false));
    }
  }

  Future<void> _onFetchGamePlaySettings(
      FetchGamePlaySettings event, Emitter<SettingsState> emit) async {
    try {
      final gamePlaySettings = await _userRepository.getUserGamePlaySettings();
      emit(state.copyWith(gamePlaySettings: gamePlaySettings));
    } catch (_) {

    }
  }

  void _onUpdateSoundState(UpdateSoundState event, Emitter<SettingsState> emit)async{
      final newState = state.copyWith(isMusicOn: event.isMusicOn, isSoundOn: event.isSoundOn);
      emit(newState);
      soundManager.updateSettings(newState);
  }
}
