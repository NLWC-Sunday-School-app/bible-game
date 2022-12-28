import 'dart:convert';

List<Tags> tagsFromJson(String str) => List<Tags>.from(json.decode(str).map((x) => Tags.fromJson(x)));

String tagsToJson(List<Tags> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class Tags{
   int id;
   String tag;

   Tags({required this.id, required this.tag});

   factory Tags.fromJson(Map<String, dynamic> json) => Tags(
       id: json["id"],
       tag: json["name"],
   );

   Map<String, dynamic> toJson() => {
     "id": id,
     "name":tag
   };
}

