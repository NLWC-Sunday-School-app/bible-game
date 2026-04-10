part of 'fantasy_league_bloc.dart';

class FantasyLeagueState extends Equatable {
  final List<LeaguePreview> openLeagues;
  final List<UserLeaguePreview> userLeagues;
  final LeagueData leagueData;
  final bool isFetchingOpenLeagues;
  final bool isFetchingUserLeagues;
  final bool isFetchingLeagueData;
  final bool isCreatingLeague;
  final bool isEditingLeague;
  final bool hasEditedLeague;
  final bool hasCreatedLeague;
  final Map<String, dynamic>? createdLeagueData;
  final bool isLeavingLeague;
  final bool isJoiningLeague;
  final bool failedToJoin;
  final bool failedToLeave;
  final bool failedToCreate;
  final bool failedToEdit;
  final bool hasLeftLeague;
  final bool hasJoinedLeague;
  final Map<String, dynamic>? joinedLeagueData;

  const FantasyLeagueState({
    this.openLeagues = const [],
    this.userLeagues = const [],
    this.leagueData = emptyLeagueData,
    this.isFetchingOpenLeagues = false,
    this.isFetchingLeagueData = false,
    this.isFetchingUserLeagues = false,
    this.isCreatingLeague = false,
    this.isEditingLeague = false,
    this.failedToEdit = false,
    this.hasEditedLeague = false,
    this.hasCreatedLeague = false,
    this.createdLeagueData,
    this.isLeavingLeague = false,
    this.isJoiningLeague = false,
    this.failedToJoin = false,
    this.failedToLeave = false,
    this.failedToCreate = false,
    this.hasLeftLeague = false,
    this.hasJoinedLeague = false,
    this.joinedLeagueData,
  });

  FantasyLeagueState copyWith({
    List<LeaguePreview>? openLeagues,
    List<UserLeaguePreview>? userLeagues,
    LeagueData? leagueData,
    bool? isFetchingOpenLeagues,
    bool? isFetchingUserLeagues,
    bool? isFetchingLeagueData,
    bool? isCreatingLeague,
    bool? isEditingLeague,
    bool? hasEditedLeague,
    bool? failedToEdit,
    bool? hasCreatedLeague,
    bool? isLeavingLeague,
    bool? isJoiningLeague,
    bool? failedToJoin,
    bool? failedToLeave,
    bool? failedToCreate,
    bool? hasLeftLeague,
    bool? hasJoinedLeague,
    Map<String, dynamic>? createdLeagueData,
    Map<String, dynamic>? joinedLeagueData,
  }) {
    return FantasyLeagueState(
        openLeagues: openLeagues ?? this.openLeagues,
        userLeagues: userLeagues ?? this.userLeagues,
        leagueData: leagueData ?? this.leagueData,
        isFetchingUserLeagues:
            isFetchingUserLeagues ?? this.isFetchingUserLeagues,
        isFetchingLeagueData: isFetchingLeagueData ?? this.isFetchingLeagueData,
        isFetchingOpenLeagues:
            isFetchingOpenLeagues ?? this.isFetchingOpenLeagues,
        isCreatingLeague: isCreatingLeague ?? this.isCreatingLeague,
        hasCreatedLeague: hasCreatedLeague ?? this.hasCreatedLeague,
        createdLeagueData: createdLeagueData ?? this.createdLeagueData,
        joinedLeagueData: joinedLeagueData ?? this.joinedLeagueData,
        isJoiningLeague: isJoiningLeague ?? this.isJoiningLeague,
        isLeavingLeague: isLeavingLeague ?? this.isLeavingLeague,
        failedToJoin: failedToJoin ?? this.failedToJoin,
        failedToLeave: failedToLeave ?? this.failedToLeave,
        failedToCreate: failedToCreate ?? this.failedToCreate,
        hasLeftLeague: hasLeftLeague ?? this.hasLeftLeague,
        hasJoinedLeague: hasJoinedLeague ?? this.hasJoinedLeague,
        hasEditedLeague: hasEditedLeague ?? this.hasEditedLeague,
        failedToEdit: failedToEdit ?? this.failedToEdit,
        isEditingLeague: isEditingLeague ?? this.isEditingLeague);
  }

  @override
  List<Object?> get props => [
        userLeagues,
        openLeagues,
        leagueData,
        isFetchingUserLeagues,
        isFetchingOpenLeagues,
        isFetchingLeagueData,
        isCreatingLeague,
        hasCreatedLeague,
        createdLeagueData,
        isJoiningLeague,
        isLeavingLeague,
        failedToJoin,
        failedToLeave,
        failedToCreate,
        hasLeftLeague,
        hasJoinedLeague,
        joinedLeagueData,
        isEditingLeague,
        hasEditedLeague,
        failedToEdit
      ];
}
