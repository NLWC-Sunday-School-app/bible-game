import 'dart:convert';
import 'package:equatable/equatable.dart';

// Function to convert JSON string to List<User>
List<User> userFromJson(String str) =>
    List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

// Function to convert List<User> to JSON string
String userToJson(List<User> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String profileUrl;
  final int highScore;
  final String rank;
  final int fourScripturesScore;
  final int fourScriptsLevel;
  final int coinWalletBalance;
  final String fcmToken;
  final String country;
  final int streak;
  final int gems;
  final bool isWalletInitialized;

  final String role;

  const User(
      {required this.id,
      required this.name,
      required this.email,
      required this.profileUrl,
      required this.rank,
      required this.highScore,
      required this.fourScripturesScore,
      required this.fourScriptsLevel,
      required this.coinWalletBalance,
      required this.fcmToken,
      required this.country,
      required this.streak,
      required this.gems,
      required this.isWalletInitialized,
      required this.role});

  // Factory constructor for creating a User instance from JSON
  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      profileUrl: json["profileUrl"],
      highScore: json["highScore"],
      rank: json["rank"],
      fourScripturesScore: json["fourScriptScore"],
      fourScriptsLevel: json["fourScriptsLevel"],
      coinWalletBalance: json["coinWalletBalance"],
      fcmToken: json["fcmToken"],
      country: json["country"],
      streak: json["streak"],
      gems: json["gems"],
      isWalletInitialized: json["isWalletInitialized"],
      role: json["role"]);

  // Method to convert a User instance to JSON
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "profileUrl": profileUrl,
        "highScore": highScore,
        "rank": rank,
        "coinWalletBalance": coinWalletBalance,
        "fourScriptScore": fourScripturesScore,
        "fourScriptsLevel": fourScriptsLevel,
        "fcmToken": fcmToken,
        "country": country,
        "streak": streak,
        "gems": gems,
        "isWalletInitialized": isWalletInitialized,
        "role": role
      };

  // Override props for Equatable
  @override
  List<Object?> get props => [
        id,
        name,
        email,
        profileUrl,
        highScore,
        fourScripturesScore,
        fourScriptsLevel,
        coinWalletBalance,
        fcmToken,
        rank,
        country,
        streak,
        gems,
        isWalletInitialized,
        role
      ];
}

// Example of an empty User instance
const emptyUser = User(
    id: 0,
    name: '',
    email: '',
    profileUrl: '',
    rank: '',
    highScore: 0,
    fourScripturesScore: 0,
    fourScriptsLevel: 0,
    coinWalletBalance: 0,
    fcmToken: '',
    country: '',
    streak: 0,
    gems: 0,
    isWalletInitialized: false,
    role: '');
