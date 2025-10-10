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
  late StompClient _stompClient;
  final MultiplayerBloc _multiplayerBloc;
  final AuthenticationBloc _authenticationBloc;
  final SettingsBloc _settingsBloc;
  final MultiplayerRepository _multiplayerRepository;
  final Completer<void> _connectedCompleter = Completer<void>();

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

  void connect(){
    _stompClient = StompClient(
      config: StompConfig.sockJS(
        onConnect: (stompFrame){
          print("Stomp client details ==  " + _stompClient.connected.toString());
          if (!_connectedCompleter.isCompleted) {
            _connectedCompleter.complete();
          }
          _stompClient.subscribe(
            destination: '/user/queue/events',
            callback: (StompFrame frame) {
              print("frame:${frame.body}");
            },
          );

          _stompClient.subscribe(
              destination: '/user/queue/heartbeat',
              callback: (frame) {
                print('Heartbeat pong: ${frame.body}');
              });
          // print("📌 Subscribed to /topic/...");
        },
        url: 'https://api.staging.biblegame.app/ws?token=${GetStorage().read('user_token')}',
        onWebSocketError:(e)=> print('Error: ${e}'),
        onStompError: (d) => print("stomp error:${d.body}"),
        onDisconnect: (d)=> print("disconnect"),
        stompConnectHeaders: {
          'Authorization': 'Bearer ${GetStorage().read('user_token')}',
        },
        webSocketConnectHeaders: {
          'Authorization': 'Bearer ${GetStorage().read('user_token')}',
        },
      ),
    );
    _stompClient.activate();
  }

  Future<void> subscribeToWaitingRoom()async{
    // Wait until connected
    if (!_connectedCompleter.isCompleted) {
      print('⏳ Waiting for connection...');
      await _connectedCompleter.future;
    }
    emit(state.copyWith(playersJoined: WaitingRoomModel.fromJson({})));
    if(_stompClient.connected){
      _stompClient.subscribe(
        destination: '/topic/room/${_multiplayerBloc.state.createGameRoomResponse.id}',
        callback: (StompFrame frame)async{
          print("frame:${frame.body}");
          final body = json.decode(frame.body!);
          emit(state.copyWith(eventType: body["type"]));
          if(body["type"] == "GAME_STARTED"){
            final questionList = body['data']['questions'];
            final data = json.decode(questionList);
            final response = (data['data'] as List)
                .map((e) => Datum.fromJson(e))
                .toList();
            emit(state.copyWith(questionData: response));
          }
          if((body['players'] != null) && (body["type"] == "PLAYER_JOINED" || body["type"] == "PLAYER_EJECTED" || body["type"] == "PLAYER_LEFT")){
            final response = WaitingRoomModel.fromJson(body);
            emit(state.copyWith(playersJoined: response, newPlayerJoined: true));
            emit(state.copyWith(playersJoined: response, newPlayerJoined: false));
          }
          if(body["type"] == "PLAYER_ANSWERED"){
            emit(state.copyWith(playerAnswersDetails: PlayerAnswers.fromJson(body), userToastMessage: ""));
            if(state.playersJoined.players.firstWhere((element) => element.userId == _authenticationBloc.state.user.id.toString()).id == state.playerAnswersDetails.playerId){
              emit(state.copyWith(coinsGained: state.playerAnswersDetails.data!.playerScore, userToastMessage: state.playerAnswersDetails.toastNotificationMessage, newPlayerJoined: true, userPlayerId: state.playerAnswersDetails.playerId));
              emit(state.copyWith(newPlayerJoined: false));
            }
          }
          if(body["type"] == "POSITION_UPDATED"){
            emit(state.copyWith(positionUpdate: PositionUpdate.fromJson(body)));
            final userPositionUpdate = state.positionUpdate.data!.leaderboard.firstWhere((element) =>element.playerId == state.userPlayerId);
              emit(state.copyWith(userRank:userPositionUpdate.rank,newPlayerJoined: true));
            emit(state.copyWith(userRank:userPositionUpdate.rank,newPlayerJoined: false));
          }
          if(body["type"] == "GAME_FINISHED"){
            emit(state.copyWith(gameFinishedEvent: GameFinishedEvent.fromJson(body)));
            await playLog();
          }
          if(body["type"] == "GAME_RESTARTED"){
            final response = WaitingRoomModel.fromJson(body);
            emit(state.copyWith(playersJoined: response, newPlayerJoined: true));
            emit(state.copyWith(playersJoined: response, newPlayerJoined: false));
          }
        },
      );
    }else{
      debugPrint("⚠️ Not connected yet");
    }
  }

  void sendGameAnswer(questionIndex, answer, questionStartTime){
    final playerId = state.playersJoined.players.firstWhere((element) => element.userId == _authenticationBloc.state.user.id.toString()).id;
    if (questionStartTime == null) {
      throw Exception("Question start time not set");
    }
    print(questionStartTime);
    print(DateTime.now());
    print(jsonEncode({
      'roomId': state.playersJoined.roomId,
      'questionIndex': questionIndex,
      'answer': answer,
      'startTime': questionStartTime.millisecond,
      'currentTime': DateTime.now().millisecond,
      // 'date': (questionStartTime.millisecond - DateTime.now().millisecond),
      'responseTimeMs': DateTime.now().difference(questionStartTime).inMilliseconds,
      'responseTimeConvert': (DateTime.now().difference(questionStartTime).inMilliseconds / 1000)
    }));
    _stompClient.send(
      destination: '/app/game.answer',
      body: jsonEncode({
        'playerId': playerId,
        'roomId': state.playersJoined.roomId,
        'questionIndex': questionIndex,
        'answer': answer,
        'responseTimeMs': DateTime.now().difference(questionStartTime).inMilliseconds,
      })
    );
  }

  Future<void> playLog()async{
    final finishedEventData = state.gameFinishedEvent.data!.leaderboard.firstWhere((element) => element.playerId == state.userPlayerId);
    final prefs = await SharedPreferences.getInstance();
    final deviceName = prefs.getString('deviceName');
    final deviceOs = prefs.getString('deviceOs');
    try {
      // emit(state.copyWith(isLoadingCreateGameRoom: true));
      final response =
          await _multiplayerRepository.sendGameData(
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
    } catch (_) {
    }
  }

  @override
  Future<void> close() {
    _stompClient.deactivate();
    print("STOMP DEACTIVATED");
    return super.close();
  }
  void closeWebsocket() {
    _stompClient.deactivate();
  }


  Future<void> onOptionSelected(
      int selectedOptionIndex,
      Datum gameQuestion,
      int gameQuestionIndex,
      questionStartTime
      )async
  {
    final soundManager = _settingsBloc.soundManager;
    final settingsState = _settingsBloc.state;
    sendGameAnswer(gameQuestionIndex, gameQuestion.options[selectedOptionIndex], questionStartTime);
    if (!state.hasAnswered) {
      // int coinsGained = state.coinsGained ?? 0;
      // int totalBonusCoinsGained = state.totalBonusCoinsGained ?? 0;
      int noOfCorrectAnswers = state.noOfCorrectAnswers;
      final pointsPerQuestion =
      int.parse(settingsState.gamePlaySettings['num_whoiswho_plays']);
      final isCorrect = gameQuestion.correctOption ==
          gameQuestion.options[selectedOptionIndex];
      if (isCorrect) {
        noOfCorrectAnswers++;
        soundManager.playCorrectAnswerSound();
        // coinsGained = coinsGained;
      } else {
        soundManager.playWrongAnswerSound();
      }
      emit(state.copyWith(
        hasAnswered: true,
        isCorrectAnswer: isCorrect,
        correctAnswer: gameQuestion.correctOption,
        selectedOptionIndex: selectedOptionIndex,
        // coinsGained: coinsGained,
        noOfCorrectAnswers: noOfCorrectAnswers,
      ));
    }
  }

  void onMoveToNextPage() {
    emit(state.copyWith(
        hasAnswered: false,
    ));
    if ((state.questionData.length ?? 0) >
        (state.selectedOptionIndex ?? 0) + 1) {
      emit(state.copyWith(
        hasAnswered: false,
        selectedOptionIndex: null,
        isCorrectAnswer: null,
        correctAnswer: null,
      ));
    }
  }
}
