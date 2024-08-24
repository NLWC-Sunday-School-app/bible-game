part of 'fantasy_league_bloc.dart';

sealed class FantasyLeagueEvent extends Equatable {
  const FantasyLeagueEvent();

  @override
  List<Object> get props => [];
}

class CreateFantasyLeague extends FantasyLeagueEvent {
  final String name;
  final int goal;
  final bool isOpen;
  final String seasonEnd;

  CreateFantasyLeague(this.name, this.goal, this.isOpen, this.seasonEnd);

  @override
  List<Object> get props => [
        name,
        goal,
        isOpen,
        seasonEnd,
      ];
}

class FetchOpenLeagues extends FantasyLeagueEvent {}

class FindLeague extends FantasyLeagueEvent {
  final String code;
  FindLeague(this.code);

  @override
  List<Object> get props => [code];
}

class FetchUserLeagues extends FantasyLeagueEvent {}

class ViewLeagueData extends FantasyLeagueEvent {
  final int leagueId;

  ViewLeagueData(this.leagueId);

  @override
  List<Object> get props => [leagueId];
}

class JoinLeague extends FantasyLeagueEvent {
  final int leagueId;

  JoinLeague(this.leagueId);

  @override
  List<Object> get props => [leagueId];
}

class LeaveLeague extends FantasyLeagueEvent {
  final int leagueId;

  LeaveLeague(this.leagueId);

  @override
  List<Object> get props => [leagueId];
}
