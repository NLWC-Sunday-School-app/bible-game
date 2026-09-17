import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:bible_game/features/multi_player/repository/multiplayer_repository.dart';
import 'package:bible_game_api/bible_game_api.dart';
import 'package:bible_game_api/model/game_invites_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import 'multiplayer_event.dart';

part 'multiplayer_state.dart';

class MultiplayerBloc extends Bloc<MultiplayerEvent, MultiplayerState> {
  final MultiplayerRepository _multiplayerRepository;
  final AuthenticationBloc _authenticationBloc;
  StreamSubscription? _pollSubscription;
  StreamSubscription? _authSubscription;

  MultiplayerBloc(
      {
        required MultiplayerRepository multiplayerRepository,
        required AuthenticationBloc authenticationBloc,
      })
      :
      _multiplayerRepository = multiplayerRepository,
        _authenticationBloc = authenticationBloc,
        super(MultiplayerState.initial()) {
    on<CreateGameRoom>(_onCreateGameRoom);
    on<JoinRoom>(_onJoinRoom);
    on<KickOut>(_onKickOut);
    on<LeaveRoom>(_onLeaveRoom);
    on<ConfigureGameRoom>(_onConfigureGameRoom);
    on<GameInvites>(_onGameInvites);
    on<FetchGameInvites>(_onFetchGameInvite);
    on<FetchOnlinePlayers>(_onFetchOnlinePlayers);
    on<SearchOnlinePlayers>(_onSearchOnlinePlayers);
    on<CountInvite>(_onCountInvite);
    on<AcceptAndJoin>(_onAcceptAndJoin);
    on<Reject>(_onReject);
    on<StartPolling>(_onStartPolling);
    on<StopPolling>(_onStopPolling);

    // Polling used to start and stop with the multiplayer screen, so an invite
    // arriving anywhere else in the app went unnoticed until you happened to
    // open that tab. Tie it to the session instead, the way the websocket is.
    if (_authenticationBloc.state.isLoggedIn) add(const StartPolling());
    _authSubscription = _authenticationBloc.stream.listen((authState) {
      if (authState.isLoggedIn && _pollSubscription == null) {
        add(const StartPolling());
      }
      if (!authState.isLoggedIn) add(const StopPolling());
    });
  }

  Future<void> _onCreateGameRoom(
      CreateGameRoom event,
      Emitter<MultiplayerState> emit) async {
    try {
      emit(state.copyWith(isLoadingCreateGameRoom: true, hasCreateGameRoomFailed: false));
      final response =
      await _multiplayerRepository.createGameRoom(_authenticationBloc.state.user.id);
      emit(state.copyWith(
          createGameRoomResponse: response, isLoadingCreateGameRoom: false, hasCreatedGameRoom: true, hasCreateGameRoomFailed: false));
    } catch (_) {
      emit(state.copyWith(
          isLoadingCreateGameRoom: false, hasCreatedGameRoom: false, hasCreateGameRoomFailed: true));
    }
  }

  Future<void> _onJoinRoom(
      JoinRoom event,
      Emitter<MultiplayerState> emit) async {
    try {
      emit(state.copyWith(isJoiningRoom: true, hasJoinedRoom: false));
      final response =
      await _multiplayerRepository.joinRoom(event.inviteCode, _authenticationBloc.state.user.id);
      print(response);
      emit(state.copyWith(createGameRoomResponse: response,isJoiningRoom: false, hasJoinedRoom: true));
      emit(state.copyWith(hasJoinedRoom: false));
    } catch (_) {
      emit(state.copyWith(
          isJoiningRoom: false, hasJoinedRoom: false));
    }
  }

  Future<void> _onLeaveRoom(
      LeaveRoom event,
      Emitter<MultiplayerState> emit) async {
    try {
      emit(state.copyWith(isLeavingRoom: true, hasLeaveRoom: false));
      final response =
      await _multiplayerRepository.leaveRoom(state.createGameRoomResponse.id, event.playerId);
      emit(state.copyWith(isLeavingRoom: false, hasLeaveRoom: true));
      emit(state.copyWith(hasLeaveRoom: false));
    } catch (_) {
      emit(state.copyWith(isLeavingRoom: false, hasLeaveRoom: false));
    }
  }

  Future<void> _onKickOut(
      KickOut event,
      Emitter<MultiplayerState> emit) async {
    try {
      emit(state.copyWith(isLoadingKickOut: true, hasKickedOut: false));
      final response =
      await _multiplayerRepository.kickOut(state.createGameRoomResponse.id, event.playerId);
      emit(state.copyWith(isLoadingKickOut: false, hasKickedOut: true));
      emit(state.copyWith(hasKickedOut: false));
    } catch (_) {
      emit(state.copyWith(isLoadingKickOut: false, hasKickedOut: false));
    }
  }

  Future<void> _onConfigureGameRoom(
      ConfigureGameRoom event,
      Emitter<MultiplayerState> emit) async {
    try {
      emit(state.copyWith(isLoadingConfigureGameRoom: true, hasConfigureGameRoomFailed: false, hostVictoryCondition: event.conditionValue));
      final response =
      await _multiplayerRepository.configureGameRoom(
          state.createGameRoomResponse.id,
          _authenticationBloc.state.user.id,
          event.gameType,
          event.questionType,
          event.conditionType,
          event.conditionValue,
          event.secondsPerQuestion
      );
      emit(state.copyWith(
          isLoadingConfigureGameRoom: false, hasConfiguredGameRoom: true, hasConfigureGameRoomFailed: false));
    } catch (_) {
      emit(state.copyWith(
          isLoadingConfigureGameRoom: false, hasConfiguredGameRoom: false, hasConfigureGameRoomFailed: true));
    }
  }

  Future<void> _onGameInvites(
      GameInvites event,
      Emitter<MultiplayerState> emit) async {
    try {
      emit(state.copyWith(isLoadingGameInvite: true, hasInvitedUser: false));
      final response =
      await _multiplayerRepository.gameInvite(
          event.inviteeUsername,
          state.createGameRoomResponse.id,
          event.gameType
      );
      emit(state.copyWith(
          isLoadingGameInvite: false,
          hasInvitedUser: true,
          gameInviteError: ''));
    } catch (e) {
      debugPrint('⚠️ invite to ${event.inviteeUsername} failed '
          '(room ${state.createGameRoomResponse.id}): $e');
      // The API layer throws the server's own wording for this endpoint, which
      // is already written for players. Anything else is a network or parsing
      // failure and gets a generic line rather than a stack trace.
      final reason = e is String && e.trim().isNotEmpty
          ? e.trim()
          : 'Your invite could not be sent. Please try again.';
      emit(state.copyWith(
          isLoadingGameInvite: false,
          hasInvitedUser: false,
          gameInviteError: reason));
    }
  }

  Future<void> _onFetchGameInvite(
      FetchGameInvites event,
      Emitter<MultiplayerState> emit) async {
    try {
      emit(state.copyWith(isFetchingListOfGameInvite: true, hasFetchedGameInvite: false));
      final response =
      await _multiplayerRepository.fetchGameInvite();
      emit(state.copyWith(
          isFetchingListOfGameInvite: false, hasFetchedGameInvite: true, listOfInvite: response));
    } catch (e) {
      debugPrint('⚠️ fetchGameInvite failed: $e');
      emit(state.copyWith(
          isFetchingListOfGameInvite: false, hasFetchedGameInvite: false));
    }
  }

  Future<void> _onFetchOnlinePlayers(
      FetchOnlinePlayers event, Emitter<MultiplayerState> emit) async {
    emit(state.copyWith(isFetchingOnlinePlayers: true));
    try {
      final page = await _multiplayerRepository.fetchOnlinePlayers();
      emit(state.copyWith(
          isFetchingOnlinePlayers: false,
          onlinePlayers: page.players,
          onlinePlayersTotal: page.total));
    } catch (e) {
      // Keep whatever was listed; an empty tab with a trace beats a blank one
      // with none.
      debugPrint('\u26A0\uFE0F fetchOnlinePlayers failed: $e');
      emit(state.copyWith(isFetchingOnlinePlayers: false));
    }
  }

  /// The query the host last typed. Responses arrive in whatever order the
  /// network returns them, so a slow "to" landing after a fast "tobi" would
  /// otherwise replace the results with the ones for a prefix already gone.
  String _latestSearchQuery = '';

  Future<void> _onSearchOnlinePlayers(
      SearchOnlinePlayers event, Emitter<MultiplayerState> emit) async {
    final query = event.query.trim();
    _latestSearchQuery = query;

    if (query.isEmpty) {
      emit(state.copyWith(
          playerSearchResults: const [],
          isSearchingPlayers: false,
          playerSearchQuery: ''));
      return;
    }

    emit(state.copyWith(isSearchingPlayers: true, playerSearchQuery: query));
    try {
      final page = await _multiplayerRepository.fetchOnlinePlayers(
          search: query, size: 20);
      if (query != _latestSearchQuery) return;
      emit(state.copyWith(
          isSearchingPlayers: false, playerSearchResults: page.players));
    } catch (e) {
      debugPrint('\u26A0\uFE0F searchOnlinePlayers("$query") failed: $e');
      if (query != _latestSearchQuery) return;
      // An empty result and a failed request must not look the same: the UI
      // offers "invite anyway" on empty, which would be wrong advice here.
      emit(state.copyWith(
          isSearchingPlayers: false, playerSearchResults: const []));
    }
  }

  Future<void> _onCountInvite(
      CountInvite event,
      Emitter<MultiplayerState> emit) async {
    try {
      final response =
      await _multiplayerRepository.countInvite();
      emit(state.copyWith(inviteCount:response['count']));
    } catch (e) {
      // Keep the previous count, but do not fail silently — a broken badge
      // with no trace was previously indistinguishable from "no invites".
      debugPrint('⚠️ countInvite failed: $e');
    }
  }

  Future<void> _onAcceptAndJoin(
      AcceptAndJoin event,
      Emitter<MultiplayerState> emit) async {
    try {
      emit(state.copyWith(isLoadingAcceptInvite: true, hasAcceptedInvite: false));
      final response =
      await _multiplayerRepository.acceptAndJoin(event.inviteId);
      emit(state.copyWith(
          isLoadingAcceptInvite: false, hasAcceptedInvite: true, createGameRoomResponse: response));
      emit(state.copyWith(
          hasAcceptedInvite: false));
      // add(JoinRoom(response.inviteCode!));
    } catch (_) {
      emit(state.copyWith(
          isLoadingAcceptInvite: false, hasAcceptedInvite: false));
    }
  }

  Future<void> _onReject(
      Reject event,
      Emitter<MultiplayerState> emit) async {
    try {
      emit(state.copyWith(isLoadingRejectInvite: true, hasRejectedInvite: false));
      final response =
      await _multiplayerRepository.reject(event.inviteId);
      emit(state.copyWith(
          isLoadingRejectInvite: false, hasRejectedInvite: true));
      add(FetchGameInvites());
    } catch (_) {
      emit(state.copyWith(
          isLoadingRejectInvite: false, hasRejectedInvite: false));
    }
  }

  Future<void> _onStartPolling(
      StartPolling event,
      Emitter<MultiplayerState> emit) async {
    // Cancel any existing polling
    await _pollSubscription?.cancel();

    // Stream.periodic does not emit until the first interval has elapsed, so
    // arriving on the tab meant a 10 second wait before the count was fetched
    // at all -- the badge sat on whatever was already in state, which is 0 on a
    // fresh launch. Fetch straight away, then poll.
    add(CountInvite());
    // The list too, so opening Game Requests shows its contents rather than an
    // empty panel while the request is still in flight.
    add(FetchGameInvites());

    _pollSubscription = Stream.periodic(
      const Duration(seconds: 10),
    ).listen((_) {
      add(CountInvite());
      // The list too, not just the count: the banner needs to know who invited
      // you and to what, and the count alone cannot say.
      add(FetchGameInvites());
    });
  }

  Future<void> _onStopPolling(
      StopPolling event,
      Emitter<MultiplayerState> emit) async {
    await _pollSubscription?.cancel();
    _pollSubscription = null;
  }

  @override
  Future<void> close() async {
    await _pollSubscription?.cancel();
    await _authSubscription?.cancel();
    return super.close();
  }

}
