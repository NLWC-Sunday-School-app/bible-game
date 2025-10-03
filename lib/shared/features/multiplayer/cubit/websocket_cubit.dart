import 'dart:convert';

import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game_api/bible_game_api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

part 'websocket_state.dart';

class WebsocketCubit extends Cubit<WebsocketState> {
  late StompClient _stompClient;
  final MultiplayerBloc _multiplayerBloc;
  WebsocketCubit({
    required MultiplayerBloc multiplayerBloc,
  })
      :
      _multiplayerBloc = multiplayerBloc,
        super(WebsocketState.initial());

  void connect(){
    _stompClient = StompClient(
      config: StompConfig.sockJS(
        onConnect: (stompFrame){
          print("Stomp client details ==  " + _stompClient.connected.toString());
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

  void subscribeToWaitingRoom(){
    emit(state.copyWith(playersJoined: WaitingRoomModel.fromJson({})));
    _stompClient.subscribe(
      destination: '/topic/room/${_multiplayerBloc.state.createGameRoomResponse.id}',
      callback: (StompFrame frame) {
        print("frame:${frame.body}");
        final body = json.decode(frame.body!);
        emit(state.copyWith(eventType: body["type"]));
        if(body["type"] == "GAME_STARTED"){
          final questionList = body['data']['questions'];
          final data = json.decode(questionList);
          final response = (data['data'] as List)
              .map((e) => Datum.fromJson(e))
              .toList();
          // print("MESSAGE: ${response}");
          emit(state.copyWith(questionData: response));
        }
        if(body['players'] != null){
          final response = WaitingRoomModel.fromJson(body);
          emit(state.copyWith(playersJoined: response));
          print(" STATE VALUE: ${state.playersJoined}");
        }
      },
    );
  }

  void disconnect(){
    _stompClient.deactivate();
  }
}
