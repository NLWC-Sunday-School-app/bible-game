class Metrics {
  final int membersCount;
  final bool leagueType;
  final String weeksLeft;
  final String coinTrack;

  const Metrics({
    required this.membersCount,
    required this.leagueType,
    required this.weeksLeft,
    required this.coinTrack,
  });

  factory Metrics.fromJson(Map<String, dynamic> json) {
    return Metrics(
      membersCount: json['membersCount'],
      leagueType: json['leagueType'],
      weeksLeft: json['weeksLeft'],
      coinTrack: json['coinTrack'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'membersCount': membersCount,
      'leagueType': leagueType,
      'weeksLeft': weeksLeft,
      'coinTrack': coinTrack,
    };
  }
}

class LeaderBoard {
  final String country;
  final String username;
  final int userId;
  final String points;
  final String rankName;
  final bool winner;
  final int position;

 const LeaderBoard({
    required this.country,
    required this.username,
    required this.userId,
    required this.points,
    required this.rankName,
    required this.winner,
    required this.position,
  });

  factory LeaderBoard.fromJson(Map<String, dynamic> json) {
    return LeaderBoard(
      country: json['country'],
      username: json['username'],
      userId: json['user_id'],
      points: json['points'],
      rankName: json['rank_name'],
      winner: json['winner'],
      position: json['position'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'username': username,
      'userId': userId,
      'points': points,
      'rankName': rankName,
      'winner': winner,
      'position': position,
    };
  }
}

class League {
  final int id;
  final String uuid;
  final String createdAt;
  final String updatedAt;
  final String name;
  final String code;
  final int goal;
  final int adminId;
  final bool isOpen;
  final String icon;
  final String seasonEnd;
  final String status;

 const League({
    required this.id,
    required this.uuid,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.code,
    required this.goal,
    required this.adminId,
    required this.isOpen,
    required this.icon,
    required this.seasonEnd,
    required this.status,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'],
      uuid: json['uuid'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      name: json['name'],
      code: json['code'],
      goal: json['goal'],
      adminId: json['adminId'],
      isOpen: json['isOpen'],
      icon: json['icon'],
      seasonEnd: json['seasonEnd'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'name': name,
      'code': code,
      'goal': goal,
      'adminId': adminId,
      'isOpen': isOpen,
      'icon': icon,
      'seasonEnd': seasonEnd,
      'status': status,
    };
  }
}

class LeagueData {
  final Metrics metrics;
  final List<LeaderBoard> leaderBoard;
  final League league;
  final bool isAuthUserMember;

  const LeagueData({
    required this.metrics,
    required this.leaderBoard,
    required this.league,
    required this.isAuthUserMember,
  });


  factory LeagueData.fromJson(Map<String, dynamic> json) {
    return LeagueData(
      metrics: Metrics.fromJson(json['metrics']),
      leaderBoard: (json['leaderBoard'] as List)
          .map((i) => LeaderBoard.fromJson(i))
          .toList(),
      league: League.fromJson(json['league']),
      isAuthUserMember: json['isAuthUserMember'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'metrics': metrics.toJson(),
      'leaderBoard': leaderBoard.map((i) => i.toJson()).toList(),
      'league': league.toJson(),
      'isAuthUserMember': isAuthUserMember,
    };
  }
}

const emptyLeagueData = LeagueData(
  metrics: Metrics(
    membersCount: 0,
    leagueType: false,
    coinTrack: '',
    weeksLeft: '',
  ),
  leaderBoard: [],
  league: League(
    id: 0,
    uuid: '',
    createdAt: '',
    updatedAt: '',
    name: '',
    code: '',
    goal: 0,
    adminId: 0,
    isOpen: false,
    icon: '',
    seasonEnd: '',
    status: '',
  ),
  isAuthUserMember: false,
);
