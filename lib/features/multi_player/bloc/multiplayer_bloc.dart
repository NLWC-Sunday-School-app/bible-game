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
    on<CountInvite>(_onCountInvite);
    on<AcceptAndJoin>(_onAcceptAndJoin);
    on<Reject>(_onReject);
  }

  Future<void> _onCreateGameRoom(
      CreateGameRoom event,
      Emitter<MultiplayerState> emit) async {
    try {
      emit(state.copyWith(isLoadingCreateGameRoom: true));
      final response =
      await _multiplayerRepository.createGameRoom(_authenticationBloc.state.user.id);
      emit(state.copyWith(
          createGameRoomResponse: response, isLoadingCreateGameRoom: false, hasCreatedGameRoom: true));
    } catch (_) {
      emit(state.copyWith(
          isLoadingCreateGameRoom: false, hasCreatedGameRoom: false));
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
      emit(state.copyWith(isLoadingConfigureGameRoom: true));
      final response =
      await _multiplayerRepository.configureGameRoom(
          state.createGameRoomResponse.id,
          _authenticationBloc.state.user.id,
          event.gameType,
          event.questionType,
          event.conditionType,
          event.conditionValue
      );
      emit(state.copyWith(
          isLoadingConfigureGameRoom: false, hasConfiguredGameRoom: true));
    } catch (_) {
      emit(state.copyWith(
          isLoadingCreateGameRoom: false, hasCreatedGameRoom: false));
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
          isLoadingGameInvite: false, hasInvitedUser: true));
    } catch (_) {
      emit(state.copyWith(
          isLoadingGameInvite: false, hasInvitedUser: false,));
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
    } catch (_) {
      emit(state.copyWith(
          isFetchingListOfGameInvite: false, hasFetchedGameInvite: false));
    }
  }

  Future<void> _onCountInvite(
      CountInvite event,
      Emitter<MultiplayerState> emit) async {
    try {
      final response =
      await _multiplayerRepository.countInvite();
      emit(state.copyWith(inviteCount:response['count']));
    } catch (_) {

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

}
