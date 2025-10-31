import 'dart:async';
import 'dart:convert';

import 'package:bible_game/features/lightning_mode/bloc/lightning_mode_bloc.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/features/multi_player/widget/modal/player_answers.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/utils/custom_toast.dart';
import 'package:bible_game/shared/widgets/custom_toast.dart';
import 'package:bible_game_api/bible_game_api.dart';
import 'package:bible_game_api/model/game_finished_event.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../../../../features/multi_player/repository/multiplayer_repository.dart';
import '../../settings/bloc/settings_bloc.dart';

part 'websocket_state.dart';

class WebsocketCubit extends Cubit<WebsocketState> {
  StompClient? _stompClient;
  final MultiplayerBloc _multiplayerBloc;
  final AuthenticationBloc _authenticationBloc;
  final SettingsBloc _settingsBloc;
  final MultiplayerRepository _multiplayerRepository;
  final Completer<void> _connectedCompleter = Completer<void>();
  bool _isConnected = false;
  Timer? _connectionCheckTimer;

  WebsocketCubit({
    required MultiplayerRepository multiplayerRepository,
    required MultiplayerBloc multiplayerBloc,
    required SettingsBloc settingsBloc,
    required AuthenticationBloc authenticationBloc
  })
      :
        _multiplayerRepository = multiplayerRepository,
        _multiplayerBloc = multiplayerBloc,
        _settingsBloc = settingsBloc,
        _authenticationBloc = authenticationBloc,
        super(WebsocketState.initial());

  void connect() {
    if (_stompClient != null && _isConnected) {
      debugPrint('⚠️ Already connected');
      return;
    }

    debugPrint('🔌 Connecting to WebSocket...');

    _stompClient = StompClient(
      config: StompConfig.sockJS(
        onConnect: (stompFrame) async {
          debugPrint("✅ Stomp connected: ${_stompClient?.connected}");
          _isConnected = true;

          if (!_connectedCompleter.isCompleted) {
            _connectedCompleter.complete();
          }

          // Add small delay to ensure connection is fully ready
          await Future.delayed(Duration(milliseconds: 200));

          // Check connection before subscribing
          if (_stompClient?.connected == true) {
            try {
              _stompClient!.subscribe(
                destination: '/user/queue/events',
                callback: (StompFrame frame) {
                  debugPrint("📨 Events frame: ${frame.body}");
                },
              );
              debugPrint("✅ Subscribed to /user/queue/events");

              _stompClient!.subscribe(
                  destination: '/user/queue/heartbeat',
                  callback: (frame) {
                    debugPrint('💓 Heartbeat pong: ${frame.body}');
                  }
              );
              debugPrint("✅ Subscribed to /user/queue/heartbeat");
            } catch (e) {
              debugPrint('❌ Error subscribing in onConnect: $e');
            }
          } else {
            debugPrint('⚠️ Connection lost before subscribing');
          }
        },
        url: 'https://api.staging.biblegame.app/ws?token=${GetStorage().read('user_token')}',
        onWebSocketError: (e) {
          debugPrint('🔴 WebSocket Error: $e');
          _isConnected = false;
        },
        onStompError: (d) {
          debugPrint("🔴 Stomp error: ${d.body}");
          _isConnected = false;
        },
        onDisconnect: (d) {
          debugPrint("🔌 Disconnected");
          _isConnected = false;
        },
        stompConnectHeaders: {
          'Authorization': 'Bearer ${GetStorage().read('user_token')}',
        },
        webSocketConnectHeaders: {
          'Authorization': 'Bearer ${GetStorage().read('user_token')}',
        },
        // Add these for better stability
        reconnectDelay: Duration(seconds: 3),
        heartbeatIncoming: Duration(seconds: 10),
        heartbeatOutgoing: Duration(seconds: 10),
      ),
    );

    try {
      _stompClient!.activate();
      debugPrint('🚀 Stomp client activation started');
    } catch (e) {
      debugPrint('❌ Failed to activate client: $e');
      _isConnected = false;
    }
  }

  Future<void> subscribeToWaitingRoom() async {
    debugPrint('📋 Attempting to subscribe to waiting room...');

    // Wait until connected with timeout
    if (!_connectedCompleter.isCompleted) {
      debugPrint('⏳ Waiting for connection...');
      try {
        await _connectedCompleter.future.timeout(
          Duration(seconds: 10),
          onTimeout: () {
            debugPrint('❌ Connection timeout');
            throw TimeoutException('Connection timeout');
          },
        );
      } catch (e) {
        debugPrint('❌ Connection error: $e');
        return;
      }
    }

    // Additional delay to ensure connection is stable
    await Future.delayed(Duration(milliseconds: 300));

    emit(state.copyWith(playersJoined: WaitingRoomModel.fromJson({})));

    if (_stompClient?.connected == true && _isConnected) {
      final roomId = _multiplayerBloc.state.createGameRoomResponse.id;
      debugPrint('🎮 Subscribing to room: $roomId');

      try {
        _stompClient!.subscribe(
          destination: '/topic/room/$roomId',
          callback: (StompFrame frame) async {
            debugPrint("📨 Room frame: ${frame.body}");

            try {
              final body = json.decode(frame.body!);
              emit(state.copyWith(eventType: body["type"]));

              if (body["type"] == "GAME_STARTED") {
                final questionList = body['data']['questions'];
                final data = json.decode(questionList);
                final response = (data['data'] as List)
                    .map((e) => Datum.fromJson(e))
                    .toList();
                emit(state.copyWith(questionData: response));
              }

              if ((body['players'] != null) &&
                  (body["type"] == "PLAYER_JOINED" ||
                      body["type"] == "PLAYER_EJECTED" ||
                      body["type"] == "PLAYER_LEFT")) {
                final response = WaitingRoomModel.fromJson(body);
                emit(state.copyWith(playersJoined: response, newPlayerJoined: true));
                emit(state.copyWith(playersJoined: response, newPlayerJoined: false));
              }

              if (body["type"] == "PLAYER_ANSWERED") {
                emit(state.copyWith(
                    playerAnswersDetails: PlayerAnswers.fromJson(body),
                    userToastMessage: ""
                ));

                if (state.playersJoined.players.firstWhere(
                        (element) => element.userId == _authenticationBloc.state.user.id.toString()
                ).id == state.playerAnswersDetails.playerId) {
                  emit(state.copyWith(
                      coinsGained: state.playerAnswersDetails.data!.playerScore,
                      userToastMessage: state.playerAnswersDetails.toastNotificationMessage,
                      newPlayerJoined: true,
                      userPlayerId: state.playerAnswersDetails.playerId
                  ));
                  emit(state.copyWith(newPlayerJoined: false));
                }
              }

              if (body["type"] == "POSITION_UPDATED") {
                emit(state.copyWith(positionUpdate: PositionUpdate.fromJson(body)));
                final userPositionUpdate = state.positionUpdate.data!.leaderboard
                    .firstWhere((element) => element.playerId == state.userPlayerId);
                emit(state.copyWith(userRank: userPositionUpdate.rank, newPlayerJoined: true));
                emit(state.copyWith(userRank: userPositionUpdate.rank, newPlayerJoined: false));
              }

              if (body["type"] == "GAME_FINISHED") {
                emit(state.copyWith(gameFinishedEvent: GameFinishedEvent.fromJson(body)));
                await playLog();
              }

              if (body["type"] == "GAME_RESTARTED") {
                final response = WaitingRoomModel.fromJson(body);
                emit(state.copyWith(playersJoined: response, newPlayerJoined: true));
                emit(state.copyWith(playersJoined: response, newPlayerJoined: false));
              }
            } catch (e) {
              debugPrint('❌ Error processing frame: $e');
            }
          },
        );
        debugPrint('✅ Successfully subscribed to waiting room');
      } catch (e) {
        debugPrint('❌ Failed to subscribe to waiting room: $e');
        debugPrint('   Connection status: ${_stompClient?.connected}');
      }
    } else {
      debugPrint("⚠️ Not connected yet. Connected: ${_stompClient?.connected}, IsConnected: $_isConnected");
    }
  }

  void sendGameAnswer(questionIndex, answer, questionStartTime) {
    if (_stompClient?.connected != true) {
      debugPrint('❌ Cannot send answer: Not connected');
      return;
    }

    final playerId = state.playersJoined.players.firstWhere(
            (element) => element.userId == _authenticationBloc.state.user.id.toString()
    ).id;

    if (questionStartTime == null) {
      throw Exception("Question start time not set");
    }

    final responseTimeMs = DateTime.now().difference(questionStartTime).inMilliseconds;

    debugPrint('📤 Sending answer - Response time: $responseTimeMs ms');

    try {
      _stompClient!.send(
          destination: '/app/game.answer',
          body: jsonEncode({
            'playerId': playerId,
            'roomId': state.playersJoined.roomId,
            'questionIndex': questionIndex,
            'answer': answer,
            'responseTimeMs': responseTimeMs,
          })
      );
      debugPrint('✅ Answer sent successfully');
    } catch (e) {
      debugPrint('❌ Failed to send answer: $e');
    }
  }

  Future<void> playLog() async {
    final finishedEventData = state.gameFinishedEvent.data!.leaderboard
        .firstWhere((element) => element.playerId == state.userPlayerId);
    final prefs = await SharedPreferences.getInstance();
    final deviceName = prefs.getString('deviceName');
    final deviceOs = prefs.getString('deviceOs');

    try {
      final response = await _multiplayerRepository.sendGameData(
          "MULTIPLAYER_GROUP",
          finishedEventData.score,
          0,
          0,
          8,
          _authenticationBloc.state.user.rank,
          state.noOfCorrectAnswers,
          _authenticationBloc.state.user.id,
          0,
          0,
          deviceName,
          deviceOs
      );
      debugPrint('✅ Game log sent successfully');
    } catch (e) {
      debugPrint('❌ Failed to send game log: $e');
    }
  }

  @override
  Future<void> close() {
    closeWebsocket();
    return super.close();
  }

  void closeWebsocket() {
    debugPrint('🔌 Closing WebSocket...');
    _connectionCheckTimer?.cancel();
    _isConnected = false;

    if (_stompClient != null) {
      try {
        _stompClient!.deactivate();
        debugPrint("✅ STOMP DEACTIVATED");
      } catch (e) {
        debugPrint("⚠️ Error deactivating STOMP: $e");
      }
      _stompClient = null;
    }
  }

  Future<void> onOptionSelected(
      int selectedOptionIndex,
      Datum gameQuestion,
      int gameQuestionIndex,
      questionStartTime
      ) async {
    final soundManager = _settingsBloc.soundManager;
    final settingsState = _settingsBloc.state;

    sendGameAnswer(gameQuestionIndex, gameQuestion.options[selectedOptionIndex], questionStartTime);

    if (!state.hasAnswered) {
      int noOfCorrectAnswers = state.noOfCorrectAnswers;
      final pointsPerQuestion =
      int.parse(settingsState.gamePlaySettings['num_whoiswho_plays']);
      final isCorrect = gameQuestion.correctOption ==
          gameQuestion.options[selectedOptionIndex];

      if (isCorrect) {
        noOfCorrectAnswers++;
        soundManager.playCorrectAnswerSound();
      } else {
        soundManager.playWrongAnswerSound();
      }

      emit(state.copyWith(
        hasAnswered: true,
        isCorrectAnswer: isCorrect,
        correctAnswer: gameQuestion.correctOption,
        selectedOptionIndex: selectedOptionIndex,
        noOfCorrectAnswers: noOfCorrectAnswers,
      ));
    }
  }

  void onMoveToNextPage() {
    emit(state.copyWith(hasAnswered: false));

    if ((state.questionData.length ?? 0) > (state.selectedOptionIndex ?? 0) + 1) {
      emit(state.copyWith(
        hasAnswered: false,
        selectedOptionIndex: null,
        isCorrectAnswer: null,
        correctAnswer: null,
      ));
    }
  }

  bool get isConnected => _isConnected && (_stompClient?.connected ?? false);
}