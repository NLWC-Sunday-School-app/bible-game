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

class EditFantasyLeague extends FantasyLeagueEvent {
  final String name;
  final bool isOpen;
  final int leagueId;

  EditFantasyLeague(this.name,  this.isOpen, this.leagueId);

  @override
  List<Object> get props => [
    name,
    isOpen,
    leagueId,
  ];
}

class EndFantasyLeague extends FantasyLeagueEvent {
  final String name;
  final bool isOpen;
  final int leagueId;

  EndFantasyLeague(this.name,  this.isOpen, this.leagueId);

  @override
  List<Object> get props => [
    name,
    isOpen,
    leagueId,
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

class JoinLeagueWithCode extends FantasyLeagueEvent {
  final String leagueCode;

  JoinLeagueWithCode(this.leagueCode);

  @override
  List<Object> get props => [leagueCode];
}

class LeaveLeague extends FantasyLeagueEvent {
  final int leagueId;

  LeaveLeague(this.leagueId);

  @override
  List<Object> get props => [leagueId];
}
