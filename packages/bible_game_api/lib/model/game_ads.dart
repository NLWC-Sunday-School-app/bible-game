import 'dart:convert';

List<GameAds> adsFromJson(String str) => List<GameAds>.from(json.decode(str).map((x) => GameAds.fromJson(x)));


class GameAds{
  String title;
  String imageUrl;

  GameAds({required this.title, required this.imageUrl});

  factory GameAds.fromJson(Map<String, dynamic> json) => GameAds(
    title: json["title"],
    imageUrl: json["image"],
  );


}

// final String playsPerRoundQuickGame;
// final String charityToFatherTotal;
// final String whoIsWhoQuestionsPassmark;
// final String babeChildPlayTime;
// final String baseScoreQuickGame;
// final String babeToChildTotal;
// final String campaignBaseScore;
// final String primaryGameType;
// final String baseScorePilgrimProgress;
// final String youngBelieverToCharityTotal;
// final String fatherToElderTotal;
// final String passOnFirstTrialScore;
// final String hardGameSpeed;
// final String playsPerRoundPilgrimProgress;
// final String isCampaignActive;
// final String intermediateGameSpeed;
// final String hintIncrementalScore;
// final String optionsPerPlay;
// final String allowMultipleGameTypes;
// final String childToYoungBelieverTotal;
// final String youngBelieverElderPlayTime;
// final String numCampaign_play;