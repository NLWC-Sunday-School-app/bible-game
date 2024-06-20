import 'dart:convert';
import 'package:equatable/equatable.dart';

// Function to convert JSON string to List<User>
List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

// Function to convert List<User> to JSON string
String userToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String profileUrl;
  final int score;
  final String rank;

  // Constructor
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profileUrl,
    required this.score,
    required this.rank,
  });

  // Factory constructor for creating a User instance from JSON
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phoneNumber: json["phoneNumber"],
    profileUrl: json["profileUrl"],
    score: json["score"],
    rank: json["rank"],
  );

  // Method to convert a User instance to JSON
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phoneNumber": phoneNumber,
    "profileUrl": profileUrl,
    "score": score,
    "rank": rank,
  };

  // Override props for Equatable
  @override
  List<Object?> get props => [id, name, email, phoneNumber, profileUrl, score, rank];
}

// Example of an empty User instance
const emptyUser = User(
  id: 0,
  name: '',
  email: '',
  phoneNumber: '',
  profileUrl: '',
  score: 0,
  rank: '',
);
