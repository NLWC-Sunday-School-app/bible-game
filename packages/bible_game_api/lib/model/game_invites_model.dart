import 'package:equatable/equatable.dart';

class GameInviteModel extends Equatable {
  GameInviteModel({
    required this.id,
    required this.inviterId,
    required this.inviterUsername,
    required this.inviteeId,
    required this.inviteeUsername,
    required this.roomId,
    required this.inviteCode,
    required this.gameMode,
    required this.status,
    required this.invitedAt,
    required this.respondedAt,
    required this.message,
    required this.pending,
    required this.expired,
  });

  final String? id;
  final int? inviterId;
  final String? inviterUsername;
  final int? inviteeId;
  final String? inviteeUsername;
  final String? roomId;
  final String? inviteCode;
  final String? gameMode;
  final String? status;
  final DateTime? invitedAt;
  final DateTime? respondedAt;
  final String? message;
  final bool? pending;
  final bool? expired;

  factory GameInviteModel.fromJson(Map<String, dynamic> json){
    return GameInviteModel(
      id: json["id"],
      inviterId: json["inviterId"],
      inviterUsername: json["inviterUsername"],
      inviteeId: json["inviteeId"],
      inviteeUsername: json["inviteeUsername"],
      roomId: json["roomId"],
      inviteCode: json["inviteCode"],
      gameMode: json["gameMode"],
      status: json["status"],
      invitedAt: DateTime.tryParse(json["invitedAt"] ?? ""),
      respondedAt: DateTime.tryParse(json["respondedAt"] ?? ""),
      message: json["message"],
      pending: json["pending"],
      expired: json["expired"],
    );
  }

  @override
  List<Object?> get props => [
    id, inviterId, inviterUsername, inviteeId, inviteeUsername, roomId, inviteCode, gameMode, status, invitedAt, respondedAt, message, pending, expired, ];
}
