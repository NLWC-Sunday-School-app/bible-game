import 'dart:convert';

List<Ads> adsFromJson(String str) => List<Ads>.from(json.decode(str).map((x) => Ads.fromJson(x)));


class Ads{
  String title;
  String imageUrl;

  Ads({required this.title, required this.imageUrl});

  factory Ads.fromJson(Map<String, dynamic> json) => Ads(
    title: json["title"],
    imageUrl: json["image"],
  );


}

