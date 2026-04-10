import 'dart:convert';

import 'package:equatable/equatable.dart';

List<QuickGameTopic> tagsFromJson(String str) => List<QuickGameTopic>.from(
    json.decode(str).map((x) => QuickGameTopic.fromJson(x)));

String tagsToJson(List<QuickGameTopic> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QuickGameTopic extends Equatable {
  final int id;
  final String tag;

  const QuickGameTopic({required this.id, required this.tag});

  factory QuickGameTopic.fromJson(Map<String, dynamic> json) => QuickGameTopic(
        id: json["id"],
        tag: json["name"],
      );

  Map<String, dynamic> toJson() => {"id": id, "name": tag};

  @override
  List<Object> get props => [id, tag];
}
