import 'dart:async';

import 'package:bible_game_api/model/league_data.dart';
import 'package:bible_game_api/model/league_preview.dart';
import 'package:bible_game_api/model/user_league_preview.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../repository/fantasy_league_repository.dart';

part 'fantasy_league_event.dart';

part 'fantasy_league_state.dart';

class FantasyLeagueBloc extends Bloc<FantasyLeagueEvent, FantasyLeagueState> {
  final FantasyLeagueRepository _fantasyLeagueRepository;
  final AuthenticationBloc _authenticationBloc;
  final SettingsBloc _settingsBloc;

  FantasyLeagueBloc(
      {required AuthenticationBloc authenticationBloc,
      required FantasyLeagueRepository fantasyLeagueRepository,
      required SettingsBloc settingsBloc})
      : _fantasyLeagueRepository = fantasyLeagueRepository,
        _authenticationBloc = authenticationBloc,
        _settingsBloc = settingsBloc,
        super(FantasyLeagueState()) {
    on<CreateFantasyLeague>(_onCreateFantasyLeague);
    on<FetchOpenLeagues>(_onFetchOpenLeagues);
    on<FetchUserLeagues>(_onFetchUserLeagues);
    on<ViewLeagueData>(_onViewLeagueData);
    on<LeaveLeague>(_onLeaveLeague);
    on<JoinLeague>(_onJoinLeague);
    on<FindLeague>(_onFindLeague);
    on<JoinLeagueWithCode>(_onJoinLeagueWithCode);
    on<EditFantasyLeague>(_onEditFantasyLeague);
    on<EndFantasyLeague>(_onEndFantasyLeague);
  }

  Future<void> _onCreateFantasyLeague(
      CreateFantasyLeague event, Emitter<FantasyLeagueState> emit) async {
    try {
      emit(state.copyWith(
          isCreatingLeague: true,
          hasCreatedLeague: false,
          createdLeagueData: null,
          failedToCreate: false,
      ));
      final response = await _fantasyLeagueRepository.createFantasyBibleLeague(
          event.name, event.goal, event.isOpen, event.seasonEnd);

      emit(state.copyWith(
          isCreatingLeague: false,
          hasCreatedLeague: true,
          createdLeagueData: response, failedToCreate: false));
    } catch (_) {
      emit(state.copyWith(isCreatingLeague: false, failedToCreate: true));
      emit(state.copyWith(isCreatingLeague: false, failedToCreate: false));
    }
  }

  Future<void> _onEditFantasyLeague(
      EditFantasyLeague event, Emitter<FantasyLeagueState> emit) async {
    try {
      emit(state.copyWith(
        isEditingLeague: true,
        hasEditedLeague: false,
        failedToEdit: false,
      ));
     await _fantasyLeagueRepository.editFantasyBibleLeague(
          event.name, event.isOpen, event.leagueId);
      add(ViewLeagueData(event.leagueId));
      add(FetchUserLeagues());
      emit(state.copyWith(
          isEditingLeague: false,
          hasEditedLeague: true,
          failedToEdit: false));
      emit(state.copyWith(hasEditedLeague: false));
    } catch (_) {
      emit(state.copyWith(isEditingLeague: false, failedToEdit: true));
      emit(state.copyWith(isEditingLeague: false, failedToEdit: false));
    }
  }

  Future<void> _onEndFantasyLeague(
      EndFantasyLeague event, Emitter<FantasyLeagueState> emit) async {
    try {
      emit(state.copyWith(
          isLeavingLeague: true, failedToLeave: false, hasLeftLeague: false));
      await _fantasyLeagueRepository.endFantasyBibleLeague(
          event.name, event.isOpen, event.leagueId);
      add(ViewLeagueData(event.leagueId));
      add(FetchUserLeagues());
      add(FetchOpenLeagues());
      emit(state.copyWith(
          isLeavingLeague: false, failedToLeave: false, hasLeftLeague: true));
      emit(state.copyWith(
          isLeavingLeague: false, failedToLeave: false, hasLeftLeague: false));
      emit(state.copyWith(hasEditedLeague: false));
    } catch (_) {
      emit(state.copyWith(
          isLeavingLeague: false, failedToLeave: true, hasLeftLeague: false));
      emit(state.copyWith(
          isLeavingLeague: false, failedToLeave: false, hasLeftLeague: false));
    }
  }

  Future<void> _onFetchOpenLeagues(
      FetchOpenLeagues event, Emitter<FantasyLeagueState> emit) async {
    try {
      emit(state.copyWith(isFetchingOpenLeagues: true));
      final response = await _fantasyLeagueRepository.getOpenLeagues();
      emit(state.copyWith(openLeagues: response, isFetchingOpenLeagues: false));
    } catch (_) {
      emit(state.copyWith(isFetchingOpenLeagues: false));
    }
  }

  Future<void> _onFindLeague(
      FindLeague event, Emitter<FantasyLeagueState> emit) async {
    try {
      emit(state.copyWith(isFetchingOpenLeagues: true));
      final response = await _fantasyLeagueRepository.findLeagues(event.code);
      ;
      emit(state.copyWith(openLeagues: response, isFetchingOpenLeagues: false));
    } catch (_) {
      emit(state.copyWith(isFetchingOpenLeagues: false));
    }
  }

  Future<void> _onFetchUserLeagues(
      FetchUserLeagues event, Emitter<FantasyLeagueState> emit) async {
    try {
      emit(state.copyWith(isFetchingUserLeagues: true));
      final response = await _fantasyLeagueRepository
          .getUserLeagues(_authenticationBloc.state.user.id);
      emit(state.copyWith(userLeagues: response, isFetchingUserLeagues: false));
    } catch (_) {
      emit(state.copyWith(isFetchingUserLeagues: false));
    }
  }

  Future<void> _onViewLeagueData(
      ViewLeagueData event, Emitter<FantasyLeagueState> emit) async {
    try {
      emit(state.copyWith(
          isFetchingLeagueData: true, leagueData: emptyLeagueData));
      final response =
          await _fantasyLeagueRepository.viewLeagueData(event.leagueId);
      print('response $response');
      emit(state.copyWith(leagueData: response, isFetchingLeagueData: false));
    } catch (_) {
      emit(state.copyWith(isFetchingLeagueData: false));
    }
  }

  Future<void> _onLeaveLeague(
      LeaveLeague event, Emitter<FantasyLeagueState> emit) async {
    try {
      emit(state.copyWith(
          isLeavingLeague: true, failedToLeave: false, hasLeftLeague: false));
      await _fantasyLeagueRepository.leaveLeague(event.leagueId);
      add(FetchOpenLeagues());
      add(FetchUserLeagues());
      emit(state.copyWith(
          isLeavingLeague: false, failedToLeave: false, hasLeftLeague: true));
      emit(state.copyWith(
          isLeavingLeague: false, failedToLeave: false, hasLeftLeague: false));
    } catch (_) {
      emit(state.copyWith(
          isLeavingLeague: false, failedToLeave: true, hasLeftLeague: false));
      emit(state.copyWith(
          isLeavingLeague: false, failedToLeave: false, hasLeftLeague: false));
    }
  }

  Future<void> _onJoinLeague(
      JoinLeague event, Emitter<FantasyLeagueState> emit) async {
    try {
      emit(state.copyWith(isLeavingLeague: true, failedToJoin: false));
      await _fantasyLeagueRepository.joinLeague(event.leagueId);
      emit(state.copyWith(
          isLeavingLeague: false, failedToJoin: false, hasJoinedLeague: true));
      emit(state.copyWith(
          isLeavingLeague: false, failedToJoin: false, hasJoinedLeague: false));
      add(FetchOpenLeagues());
    } catch (_) {
      emit(state.copyWith(
          isLeavingLeague: false, failedToJoin: true, hasJoinedLeague: false));
      emit(state.copyWith(
          isLeavingLeague: false, failedToJoin: false, hasJoinedLeague: false));
    }
  }

  Future<void> _onJoinLeagueWithCode(
      JoinLeagueWithCode event, Emitter<FantasyLeagueState> emit) async {
    try {
      emit(state.copyWith(isLeavingLeague: true, failedToJoin: false));
     final response = await _fantasyLeagueRepository.joinLeagueWithCode(event.leagueCode);
      emit(state.copyWith(
        joinedLeagueData: response,
          isLeavingLeague: false, failedToJoin: false, hasJoinedLeague: true));
      emit(state.copyWith(
          isLeavingLeague: false, failedToJoin: false, hasJoinedLeague: false));
      add(FetchOpenLeagues());
    } catch (_) {
      emit(state.copyWith(
          isLeavingLeague: false, failedToJoin: true, hasJoinedLeague: false));
      emit(state.copyWith(
          isLeavingLeague: false, failedToJoin: false, hasJoinedLeague: false));
    }
  }
}
