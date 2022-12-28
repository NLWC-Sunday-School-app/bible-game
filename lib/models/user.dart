
import 'dart:convert';

List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class User {

   int id;
   String name;
   String email;
   String phoneNumber;
   String profileUrl;
   int score;
   String rank;

  User({required this.id, required this.name, required this.email, required this.phoneNumber, required this.profileUrl, required this.score, required this.rank});

   factory User.fromJson(Map<String, dynamic> json) => User(
     id: json["id"],
     name: json["name"],
     email: json["email"],
     phoneNumber: json["phoneNumber"],
     profileUrl: json["profileUrl"],
     score: json["score"],
     rank: json["rank"]
   );

   Map<String, dynamic> toJson() => {
     "id": id,
     "name":name,
     "email": email,
     "phoneNumber": phoneNumber,
     "profileUrl": profileUrl,
     "score": score,
     "rank": rank
   };

}