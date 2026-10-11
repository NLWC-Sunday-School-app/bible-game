import 'dart:async';
import 'package:flutter/foundation.dart';

import 'package:bible_game/features/multi_player/repository/multiplayer_repository.dart';
import 'package:bible_game_api/bible_game_api.dart';
import 'package:bible_game_api/model/game_invites_model.dart';
import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import '../active_room_store.dart';
import '../resumable_room.dart';
import '../../../shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import 'multiplayer_event.dart';

part 'multiplayer_state.dart';

class MultiplayerBloc extends Bloc<MultiplayerEvent, MultiplayerState> {
  final MultiplayerRepository _multiplayerRepository;
  final AuthenticationBloc _authenticationBloc;
  final ActiveRoomStore _activeRoomStore;
  StreamSubscription? _pollSubscription;
  StreamSubscription? _authSubscription;

  MultiplayerBloc(
      {
        required MultiplayerRepository multiplayerRepository,
        required AuthenticationBloc authenticationBloc,
        ActiveRoomStore? activeRoomStore,
      })
      :
      _multiplayerRepository = multiplayerRepository,
        _authenticationBloc = authenticationBloc,
        _activeRoomStore = activeRoomStore ?? ActiveRoomStore(),
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
    on<CheckActiveRoom>(_onCheckActiveRoom);
    on<ResumeActiveRoom>(_onResumeActiveRoom);
    on<DiscardActiveRoom>(_onDiscardActiveRoom);
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
      // hasCreatedGameRoom has to go back down before it can go up again: the
      // listener waiting on it fires on the false->true edge, and a flag left
      // latched at true from the previous room never produces another one.
      emit(state.copyWith(
          isLoadingCreateGameRoom: true,
          hasCreatedGameRoom: false,
          hasCreateGameRoomFailed: false));
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
      await _rememberRoom(response);
      add(const CheckActiveRoom());
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
      // Forgotten before the request, not after: leaving is what the player
      // asked for, and a failed request should not bring the room back as
      // something to resume.
      await _forgetRoom(state.createGameRoomResponse.id, emit);
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
      // Likewise, and this one was reaching players: configuring a second room
      // in one session left hasConfiguredGameRoom already true, so the guarded
      // listener saw no edge, never opened the waiting room, and the host was
      // returned to the form they had just submitted.
      emit(state.copyWith(
          isLoadingConfigureGameRoom: true,
          hasConfiguredGameRoom: false,
          hasConfigureGameRoomFailed: false,
          hostVictoryCondition: event.conditionValue));
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
      // Saved once configured rather than on create: the code is only worth
      // coming back to once there is a game behind it. The create response
      // lists the host alone, so its one active player is the host's own.
      final room = state.createGameRoomResponse;
      await _rememberRoom(room,
          playerId: room.activePlayers.firstOrNull?.toString());
      add(const CheckActiveRoom());
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
      await _rememberRoom(response);
      add(const CheckActiveRoom());
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

  String get _userId => _authenticationBloc.state.user.id.toString();

  Future<void> _rememberRoom(CreateGameRoomModel room, {String? playerId}) async {
    final roomId = room.id;
    final inviteCode = room.inviteCode;
    if (roomId == null || inviteCode == null) return;
    try {
      await _activeRoomStore.save(
          roomId: roomId,
          inviteCode: inviteCode,
          userId: _userId,
          playerId: playerId);
    } catch (e) {
      debugPrint('⚠️ could not save active room $roomId: $e');
    }
  }

  Future<void> _forgetRoom(String? roomId, Emitter<MultiplayerState> emit) async {
    if (roomId == null) return;
    try {
      await _activeRoomStore.clear(roomId);
    } catch (e) {
      debugPrint('⚠️ could not clear active room $roomId: $e');
    }
    if (state.resumableRoom?.details.id == roomId) {
      emit(state.copyWith(clearResumableRoom: true));
    }
  }

  /// The saved room as the server has it now, or null once it is gone for
  /// good -- deleted, or closed to a player who is no longer in it. Throws on
  /// anything else, network trouble included, so a dropped connection does
  /// not wipe out the one record of a room that is still there.
  Future<ResumableRoom?> _loadResumable(ActiveRoom saved) async {
    final RoomDetailsModel details;
    try {
      details = await _multiplayerRepository.getRoomDetails(saved.roomId);
    } catch (e) {
      if (e.toString().contains('ApiException: 404')) {
        await _activeRoomStore.clear(saved.roomId);
        return null;
      }
      rethrow;
    }

    var myPlayerId = details.players
        .firstWhereOrNull((p) => p.playerId != null && p.playerId == saved.playerId)
        ?.playerId;
    // A guest's player id only reaches us in a socket frame, which may never
    // have arrived before they left. Names are unique accounts-wide, so the
    // roster entry under ours is ours -- but only when no id was recorded: a
    // recorded id that is missing means we were removed.
    if (myPlayerId == null && saved.playerId == null) {
      final myName = _authenticationBloc.state.user.name.toLowerCase();
      myPlayerId = details.players
          .firstWhereOrNull((p) => p.playerName?.toLowerCase() == myName)
          ?.playerId;
    }
    if (myPlayerId != null && myPlayerId != saved.playerId) {
      await _activeRoomStore.rememberPlayerId(saved.roomId, myPlayerId);
    }

    // Out of the room and it is no longer taking players: nothing to go back to.
    if (myPlayerId == null && !details.isWaiting) {
      await _activeRoomStore.clear(saved.roomId);
      return null;
    }

    return ResumableRoom(
      details: details,
      isHost: details.hostId == _userId,
      myPlayerId: myPlayerId,
    );
  }

  /// Finds players by name through the online players search, for a server
  /// whose room details carry names only. Best effort: anyone not found, or a
  /// failed search, just leaves that row with what it already has.
  Future<List<OnlinePlayer>> _lookUpPlayers(Iterable<String> names) async {
    final results = await Future.wait(names.map((name) async {
      try {
        final page = await _multiplayerRepository.fetchOnlinePlayers(
            search: name, size: 5);
        return page.players.firstWhereOrNull(
            (p) => p.username.toLowerCase() == name.toLowerCase());
      } catch (e) {
        debugPrint('⚠️ looking up player "$name" failed: $e');
        return null;
      }
    }));
    return results.whereType<OnlinePlayer>().toList();
  }

  Future<void> _onCheckActiveRoom(
      CheckActiveRoom event,
      Emitter<MultiplayerState> emit) async {
    final saved = _activeRoomStore.read(_userId);
    if (saved == null) {
      if (state.resumableRoom != null) {
        emit(state.copyWith(clearResumableRoom: true));
      }
      return;
    }
    try {
      final resumable = await _loadResumable(saved);
      emit(resumable == null
          ? state.copyWith(clearResumableRoom: true)
          : state.copyWith(resumableRoom: resumable));
    } catch (e) {
      // Keep whatever was shown; the next check or a tap on it will retry.
      debugPrint('⚠️ checkActiveRoom failed for ${saved.roomId}: $e');
    }
  }

  Future<void> _onResumeActiveRoom(
      ResumeActiveRoom event,
      Emitter<MultiplayerState> emit) async {
    if (state.isResumingRoom) return;
    emit(state.copyWith(
        isResumingRoom: true, hasResumedRoom: false, resumeError: ''));

    const gone = 'That game has ended. Create a new one to play again.';
    try {
      final saved = _activeRoomStore.read(_userId);
      var resumable = saved == null ? null : await _loadResumable(saved);
      if (resumable == null) {
        emit(state.copyWith(
            isResumingRoom: false, clearResumableRoom: true, resumeError: gone));
        return;
      }

      if (!resumable.isMember) {
        // Still open, but our player is gone: come back in by the code, as
        // anyone with it would.
        final joined = await _multiplayerRepository.joinRoom(
            resumable.inviteCode, _authenticationBloc.state.user.id);
        await _rememberRoom(joined);
        final rejoined = _activeRoomStore.read(_userId);
        resumable = rejoined == null ? null : await _loadResumable(rejoined);
        if (resumable == null) {
          emit(state.copyWith(
              isResumingRoom: false, clearResumableRoom: true, resumeError: gone));
          return;
        }
      } else if (resumable.details.isActive) {
        // Questions are timed and dealt from the GAME_STARTED frame, which
        // has already gone out; there is no joining a round halfway through.
        emit(state.copyWith(
            isResumingRoom: false,
            resumableRoom: resumable,
            resumeError:
                'That round is still being played. You can rejoin when it ends.'));
        return;
      } else if (resumable.details.isFinished && resumable.isHost) {
        // A finished room reopens under the same code, so the friends who
        // already have it can come straight back in.
        await _multiplayerRepository.restartGame(
            resumable.details.id, _authenticationBloc.state.user.id);
        final saved = _activeRoomStore.read(_userId);
        resumable = saved == null ? null : await _loadResumable(saved);
        if (resumable == null) {
          emit(state.copyWith(
              isResumingRoom: false, clearResumableRoom: true, resumeError: gone));
          return;
        }
      }

      resumable = resumable.withKnownPlayers(
          await _lookUpPlayers(resumable.unidentifiedPlayerNames));

      emit(state.copyWith(
          createGameRoomResponse: resumable.toCreateGameRoomModel(),
          resumableRoom: resumable,
          isResumingRoom: false,
          hasResumedRoom: true));
      emit(state.copyWith(hasResumedRoom: false));
    } catch (e) {
      debugPrint('⚠️ resumeActiveRoom failed: $e');
      emit(state.copyWith(
          isResumingRoom: false,
          resumeError:
              "Couldn't get back into your game. Check your connection and try again."));
    }
  }

  Future<void> _onDiscardActiveRoom(
      DiscardActiveRoom event,
      Emitter<MultiplayerState> emit) async {
    final resumable = state.resumableRoom;
    await _activeRoomStore.clear(resumable?.details.id);
    emit(state.copyWith(clearResumableRoom: true));

    final roomId = resumable?.details.id;
    final playerId = resumable?.myPlayerId;
    if (roomId == null || playerId == null) return;
    try {
      await _multiplayerRepository.leaveRoom(roomId, playerId);
    } catch (e) {
      debugPrint('⚠️ leaving discarded room $roomId failed: $e');
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
