part of 'user_bloc.dart';

class UserState extends Equatable {
  final bool isLoadingAds;
  final List<GameAds>? adContent;
  final List<PilgrimProgressLevelData>? pilgrimProgressDetails;
  final List<Leaderboard>? globalLeaderboard;
  final List<Leaderboard>? countryLeaderboard;
  final bool isFetchingGlobalLeaderboard;
  final bool isFetchingCountryLeaderboard;
  final Map<String, dynamic> userStreakDetails;
  final bool isUpdatingProfile;
  final bool updatedProfile;
  final bool failedToUpdate;
  final bool isPurchasingGem;
  final bool isRestoringStreak;
  final bool isOnboardingCollaborator;
  final bool hasSentCollaboratorMail;
  final bool isUpdatingCountry;
  final bool hasUpdatedCountry;

  const UserState(
      {this.isLoadingAds = false,
      this.adContent,
      this.pilgrimProgressDetails,
      this.globalLeaderboard = const [],
      this.isFetchingGlobalLeaderboard = false,
      this.isFetchingCountryLeaderboard = false,
      this.countryLeaderboard = const [],
      this.userStreakDetails = const {},
      this.isUpdatingProfile = false,
      this.updatedProfile = false,
      this.failedToUpdate = false,
      this.isPurchasingGem = false,
      this.isRestoringStreak = false,
      this.isOnboardingCollaborator = false,
      this.hasSentCollaboratorMail = false,
      this.isUpdatingCountry = false,
      this.hasUpdatedCountry = false});

  UserState copyWith(
      {List<PilgrimProgressLevelData>? pilgrimProgressDetails,
      List<Leaderboard>? globalLeaderboard,
      bool? isFetchingGlobalLeaderboard,
      bool? isFetchingCountryLeaderboard,
      List<Leaderboard>? countryLeaderboard,
      Map<String, dynamic>? userStreakDetails,
      bool? isUpdatingProfile,
      bool? updatedProfile,
      bool? failedToUpdate,
      bool? isPurchasingGem,
      bool? isRestoringStreak,
      bool? isOnboardingCollaborator,
      bool? hasSentCollaboratorMail,
      bool? isUpdatingCountry,
      bool? hasUpdatedCountry}) {
    return UserState(
        pilgrimProgressDetails:
            pilgrimProgressDetails ?? this.pilgrimProgressDetails,
        globalLeaderboard: globalLeaderboard ?? this.globalLeaderboard,
        isFetchingGlobalLeaderboard:
            isFetchingGlobalLeaderboard ?? this.isFetchingGlobalLeaderboard,
        isFetchingCountryLeaderboard:
            isFetchingCountryLeaderboard ?? this.isFetchingCountryLeaderboard,
        countryLeaderboard: countryLeaderboard ?? this.countryLeaderboard,
        userStreakDetails: userStreakDetails ?? this.userStreakDetails,
        isUpdatingProfile: isUpdatingProfile ?? this.isUpdatingProfile,
        updatedProfile: updatedProfile ?? this.updatedProfile,
        failedToUpdate: failedToUpdate ?? this.failedToUpdate,
        isPurchasingGem: isPurchasingGem ?? this.isPurchasingGem,
        isRestoringStreak: isRestoringStreak ?? this.isRestoringStreak,
        isOnboardingCollaborator:
            isOnboardingCollaborator ?? this.isOnboardingCollaborator,
        hasSentCollaboratorMail:
            hasSentCollaboratorMail ?? this.hasSentCollaboratorMail,
        isUpdatingCountry: isUpdatingCountry ?? this.isUpdatingCountry,
      hasUpdatedCountry:  hasUpdatedCountry ?? this.hasUpdatedCountry
    );
  }

  @override
  List<Object?> get props => [
        pilgrimProgressDetails,
        globalLeaderboard,
        isFetchingGlobalLeaderboard,
        isFetchingCountryLeaderboard,
        countryLeaderboard,
        userStreakDetails,
        isUpdatingProfile,
        updatedProfile,
        failedToUpdate,
        isPurchasingGem,
        isRestoringStreak,
        isOnboardingCollaborator,
        hasSentCollaboratorMail,
        isUpdatingCountry,
        hasUpdatedCountry
      ];
}
