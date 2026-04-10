import 'package:equatable/equatable.dart';

class PilgrimProgressLevelData extends Equatable {
  const PilgrimProgressLevelData({
    required this.id,
    required this.uuid,
    required this.userId,
    required this.rankId,
    required this.progress,
    required this.numberOfRounds,
  });

  final int? id;
  final String? uuid;
  final int? userId;
  final int? rankId;
  final double? progress;
  final int? numberOfRounds;

  factory PilgrimProgressLevelData.fromJson(Map<String, dynamic> json){
    return PilgrimProgressLevelData(
      id: json["id"],
      uuid: json["uuid"],
      userId: json["userId"],
      rankId: json["rankId"],
      progress: json["progress"],
      numberOfRounds: json["numberOfRounds"],
    );
  }

  @override
  List<Object?> get props => [id, uuid, userId, rankId, progress, numberOfRounds];

}
