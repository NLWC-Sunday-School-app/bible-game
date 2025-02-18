import 'dart:convert';

import 'package:stomp_dart_client/stomp_dart_client.dart';


class WebSocketService {
  late StompClient stompClient;

  void connect({
    required Function(String) onGameStart,
    required Function(Map<String, int>) onScoresUpdated,
  }) {
    stompClient = StompClient(
      config: StompConfig(
        url: 'ws://plankton-app-ikxuv.ondigitalocean.app/ws/websocket',
        onConnect: (StompFrame frame) {
          print('Websocket connected ${frame.body}');
          // Listen for game start event
          Future.delayed(Duration(milliseconds: 200), () {
            print('checking topic....');
            stompClient.subscribe(
              destination: '/topic/game-start',
              callback: (frame) {
                print('seeing, ${frame}');
                onGameStart("START");
                // print('Game start event received: ${frame.body}');
                // onGameStart(frame.body ?? "WAITING");
              },
            );
            print('done checking....');
          });


          // Listen for scores
          stompClient.subscribe(
            destination: '/topic/scores',
            callback: (frame) {
              print('seeing me, ${frame}');
              // final scores = Map<String, int>.from(frame.body != null
              //     ? jsonDecode(frame.body!)
              //     : {});
              // onScoresUpdated(scores);
              onScoresUpdated({"Player1": 10, "Player2": 15});
            },
          );
        },

        onWebSocketError: (dynamic error) => print('WebSocket Error: $error'),
        stompConnectHeaders: {'Authorization': 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxMjg1MSIsImlhdCI6MTczMjQzNzkwMiwiZXhwIjoxNzQ4MDQxMjAwfQ.Ftmb6aPJ3SO64k3zVX8Yy-N-nYXlgxUtfcdRh03ksW8KW1idiajuPItS83cRvp0T2ZNt_fztmEC3FgpNN3KNwQ'},
        webSocketConnectHeaders: {'Authorization': 'Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxMjg1MSIsImlhdCI6MTczMjQzNzkwMiwiZXhwIjoxNzQ4MDQxMjAwfQ.Ftmb6aPJ3SO64k3zVX8Yy-N-nYXlgxUtfcdRh03ksW8KW1idiajuPItS83cRvp0T2ZNt_fztmEC3FgpNN3KNwQ'},
      ),
    );

    stompClient.activate();
  }

  void sendReady(String username) {
    stompClient.send(
      destination: '/app/ready',
      body: username,
    );
  }
}
