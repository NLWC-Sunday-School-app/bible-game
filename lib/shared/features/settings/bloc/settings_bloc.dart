import 'package:bible_game/features/memory_verses/model/memory_verse.dart';
import 'package:bible_game_api/model/game_ads.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/devotional_notification.dart';
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
    on<ToggleNotification>(_onToggleNotification);
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
    emit(state.copyWith(
      isNotificationOn: prefs.getBool('isNotificationOn') ?? true,
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

    if (!state.isNotificationOn) return;
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

  /// The toggle used to flip a flag in memory and nothing else -- it neither
  /// persisted nor touched the schedules, so verses kept arriving after it was
  /// switched off and it reset on every launch.
  Future<void> _onToggleNotification(
      ToggleNotification event, Emitter<SettingsState> emit) async {
    final enabled = !state.isNotificationOn;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNotificationOn', enabled);
    emit(state.copyWith(isNotificationOn: enabled));

    try {
      if (enabled) {
        await DevotionalNotification.scheduleDailyReminder();
        await HourlyVerseNotification.scheduleHourlyVerses(
            everyHours: state.verseFrequencyHours);
      } else {
        await DevotionalNotification.cancelDailyReminder();
        await HourlyVerseNotification.cancelHourlyVerses();
      }
    } catch (e) {
      // Scheduling throws if the notification permission was never granted.
      debugPrint('\u26A0\uFE0F Notification toggle: $e');
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
