import 'dart:convert';

import 'package:equatable/equatable.dart';

class Leaderboard extends Equatable {
  final int userId;
  final int walletBalance;
  final String name;
  final int position;
  final dynamic country;
  final String status;

  const Leaderboard({
    required this.userId,
    required this.walletBalance,
    required this.position,
    required this.name,
    required this.status,
    required this.country,
  });

  factory Leaderboard.fromJson(Map<String, dynamic> json) => Leaderboard(
      userId: json["userId"],
      walletBalance: json["balance"],
      name: json["name"],
      position: json["position"],
      status: json["status"],
      country: json["country"]
  );

  @override
  List<Object?> get props => [
        userId,
        walletBalance,
        position,
        name,
        status,
        country,
      ];
}
