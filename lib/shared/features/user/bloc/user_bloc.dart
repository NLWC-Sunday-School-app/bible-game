import 'package:bible_game_api/bible_game_api.dart';
import 'package:bible_game_api/model/pilgrim_progress_level_data.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_game/shared/utils/awesome_notification.dart';

import '../../authentication/bloc/authentication_bloc.dart';
import '../repository/user_repository.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _userRepository;
  final AuthenticationBloc _authenticationBloc;

  UserBloc({
    required UserRepository userRepository,
    required AuthenticationBloc authenticationBloc,
  })  : _userRepository = userRepository,
        _authenticationBloc = authenticationBloc,
        super(UserState()) {
    on<FetchGlobalLeaderBoard>(_onFetchGlobalLeaderBoard);
    on<FetchCountryLeaderBoard>(_onFetchCountryLeaderBoard);
    on<FetchUserStreakDetails>(_onFetchUserStreakDetails);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<PurchaseGem>(_onPurchaseGem);
    on<RestoreStreak>(_onRestoreStreak);
    on<OnboardCollaborator>(_onOnboardCollaborator);
    on<InitializeWallet>(_onInitializeWallet);
    on<UpdateCountry>(_onUpdateCountry);
    on<FetchUserYearlyRecap>(_onFetchUserYearlyRecap);
  }

  Future<void> _onFetchGlobalLeaderBoard(
      FetchGlobalLeaderBoard event, Emitter<UserState> emit) async {
    try {
      emit(state.copyWith(isFetchingGlobalLeaderboard: true));
      var response = await _userRepository.getGlobalLeaderBoard(event.isLoggedIn);
      print(response);
      emit(state.copyWith(
          globalLeaderboard: response, isFetchingGlobalLeaderboard: false));
    } catch (_) {}
  }

  Future<void> _onFetchCountryLeaderBoard(
      FetchCountryLeaderBoard event, Emitter<UserState> emit) async {
    try {
      emit(state.copyWith(isFetchingCountryLeaderboard: true));
      var response = await _userRepository
          .getCountryLeaderBoard(_authenticationBloc.state.user.country);
      print(response);
      emit(state.copyWith(
          countryLeaderboard: response, isFetchingCountryLeaderboard: false));
    } catch (_) {}
  }

  Future<void> _onFetchUserStreakDetails(
      FetchUserStreakDetails event, Emitter<UserState> emit) async {
    try {
      var response = await _userRepository
          .getStreakDetails(_authenticationBloc.state.user.id);
      emit(state.copyWith(userStreakDetails: response));
    } catch (_) {}
  }

  Future<void> _onFetchUserYearlyRecap(
      FetchUserYearlyRecap event, Emitter<UserState> emit) async {
    try {
      var response = await _userRepository
          .getUserYearlyRecap(_authenticationBloc.state.user.id);
      emit(state.copyWith(userYearlyRecap: response));
    } catch (_) {}
  }

  Future<void> _onUpdateUserProfile(
      UpdateUserProfile event, Emitter<UserState> emit) async {
    try {
      emit(state.copyWith(isUpdatingProfile: true, failedToUpdate: false));
      await _userRepository.updateUserProfile(
          _authenticationBloc.state.user.id, event.newUserName);
      emit(state.copyWith(
          isUpdatingProfile: false,
          updatedProfile: true,
          failedToUpdate: false));
    } catch (_) {
      emit(state.copyWith(isUpdatingProfile: false, failedToUpdate: true));
    }
  }

  Future<void> _onPurchaseGem(
      PurchaseGem event, Emitter<UserState> emit) async {
    try {
      emit(state.copyWith(isPurchasingGem: true));
      await _userRepository.purchaseGem(_authenticationBloc.state.user.id, '1');
      emit(state.copyWith(isPurchasingGem: false));
    } catch (_) {
      emit(state.copyWith(isPurchasingGem: false));
    }
  }

  Future<void> _onRestoreStreak(
      RestoreStreak event, Emitter<UserState> emit) async {
    try {
      emit(state.copyWith(isRestoringStreak: true));
      await _userRepository.restoreStreak(_authenticationBloc.state.user.id);
      emit(state.copyWith(isRestoringStreak: false));
    } catch (_) {
      emit(state.copyWith(isRestoringStreak: false));
    }
  }

  Future<void> _onOnboardCollaborator(
      OnboardCollaborator event, Emitter<UserState> emit) async {
    try {
      emit(state.copyWith(isOnboardingCollaborator: true, hasSentCollaboratorMail: false));
      await _userRepository.onboardCollaborator(_authenticationBloc.state.user.id);
      emit(state.copyWith(isOnboardingCollaborator: false, hasSentCollaboratorMail: true));
      emit(state.copyWith(isOnboardingCollaborator: false, hasSentCollaboratorMail: false));
    } catch (_) {
      emit(state.copyWith(isOnboardingCollaborator: false, hasSentCollaboratorMail: false));
    }
  }

  Future<void> _onInitializeWallet(InitializeWallet event, Emitter<UserState>emit) async{
     try{
        await _userRepository.initializeUserWallet();
     }catch(_){

     }
  }

  Future<void> _onUpdateCountry(UpdateCountry event, Emitter<UserState>emit) async{
    try{
      emit(state.copyWith(isUpdatingCountry: true, hasUpdatedCountry: false));
      await _userRepository.updateCountry(event.country);
      emit(state.copyWith(isUpdatingCountry: false, hasUpdatedCountry: true));
      emit(state.copyWith(isUpdatingCountry: false, hasUpdatedCountry: false));
    }catch(_){
      emit(state.copyWith(isUpdatingCountry: false, hasUpdatedCountry: false));
    }
  }
}
