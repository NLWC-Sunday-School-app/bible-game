import 'package:equatable/equatable.dart';

class UserLeaguePreview extends Equatable {
  final String name;
  final int id;
  final int playerCount;
  final String icon;

  const UserLeaguePreview({
    required this.name,
    required this.id,
    required this.playerCount,
    required this.icon,
  });

  factory UserLeaguePreview.fromJson(Map<String, dynamic> json) => UserLeaguePreview(
      name: json["league_name"],
      id: json["league_id"],
      playerCount: json["total_players"],
      icon: json["league_icon"]);

  @override

  List<Object?> get props => [name, id, playerCount, icon];
}
