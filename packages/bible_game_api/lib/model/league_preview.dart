import 'package:equatable/equatable.dart';

class LeaguePreview extends Equatable {
  final String name;
  final int id;
  final int playerCount;
  final String icon;

  const LeaguePreview({
    required this.name,
    required this.id,
    required this.playerCount,
    required this.icon,
  });
  // 200

  factory LeaguePreview.fromJson(Map<String, dynamic> json) => LeaguePreview(
      name: json["name"],
      id: json["id"],
      playerCount: json["playerCount"],
      icon: json["icon"]);

  @override

  List<Object?> get props => [name, id, playerCount, icon];
}
