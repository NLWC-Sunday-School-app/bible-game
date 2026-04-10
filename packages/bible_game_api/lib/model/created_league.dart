class CreatedLeague {
  int? id;
  String? uuid;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? code;
  int? goal;
  int? adminId;
  bool? isOpen;
  String? icon;
  String? seasonEnd;
  String? status;

  CreatedLeague(
      {this.id,
        this.uuid,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.code,
        this.goal,
        this.adminId,
        this.isOpen,
        this.icon,
        this.seasonEnd,
        this.status});

  CreatedLeague.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    name = json['name'];
    code = json['code'];
    goal = json['goal'];
    adminId = json['adminId'];
    isOpen = json['isOpen'];
    icon = json['icon'];
    seasonEnd = json['seasonEnd'];
    status = json['status'];
  }

}
