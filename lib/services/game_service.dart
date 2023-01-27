import 'dart:convert';
import 'package:bible_game/models/leaderboard.dart';
import 'package:bible_game/services/user_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/question.dart';
import 'base_url_service.dart';

class GameService {
  static var baseUrl = BaseUrlService.baseUrl;
  static dynamic token = GetStorage().read('user_token');
  static  Map<String, String> headers = {'Content-Type': 'application/json','accept': 'application/json', 'Authorization': 'Bearer ${GetStorage().read('user_token')}'};


  static Future<List<Question>> getGameQuestions(gameMode, userRank, tags) async {
    print('olp: ${ GetStorage().read('user_token')}');
    var response = await http.post(Uri.parse('$baseUrl/games/play'), headers: headers, body: jsonEncode({'gameMode': gameMode, 'userRank': userRank, 'tags': tags}));
    return questionFromJson(response.body);
  }

  static Future<List<Question>> getGameQuestionsWithoutToken(gameMode, userRank, tags) async{
    var response = await http.post(Uri.parse('$baseUrl/games/play/open'), headers: headers, body: jsonEncode({'gameMode': gameMode, 'userRank': userRank, 'tags': tags}));
    return questionFromJson(response.body);
  }

  static Future<List<Leaderboard>> getGameLeaderBoard(id) async{
    var response = await http.get(Uri.parse('$baseUrl/playlog/leaderboards/$id'), headers: headers);
   print(leaderBoardFromJson(response.body));
    return leaderBoardFromJson(response.body);
  }

  static Future<List<Leaderboard>> getNativityGameLeaderBoard() async{
    var response = await http.get(Uri.parse('$baseUrl/playlog/campaigns/leaderboards?campaign=CAMPAIGN_NATIVITY&limit=20'), headers: headers);
    print(leaderBoardFromJson(response.body));
    return leaderBoardFromJson(response.body);
  }

  static Future<List<Leaderboard>> getGameLeaderBoardWithoutToken(id) async{
    var response = await http.get(Uri.parse('$baseUrl/playlog/open/leaderboards/$id'), headers: headers);
    return leaderBoardFromJson(response.body);
  }


  static Future<void> sendGameData(gameMode, totalScore, baseScore, bonusScore, averageTimeSpent,playerRank, noOfCorrectAnswers, playerId, userProgress, numberOfRoundsLeft) async {
    var response = await http.post(Uri.parse('$baseUrl/playlog'), headers: headers,
        body: jsonEncode({'game_mode': gameMode, 'total_score': totalScore, 'base_score': baseScore,
         'bonus_score': bonusScore, 'average_time_spent': averageTimeSpent, 'player_rank': playerRank,
          'number_of_correct_answers': noOfCorrectAnswers, 'player_id': playerId, 'user_progress': userProgress, 'number_of_rounds': numberOfRoundsLeft}));
     print(jsonEncode({'game_mode': gameMode, 'total_score': totalScore, 'base_score': baseScore,
       'bonus_score': bonusScore, 'average_time_spent': averageTimeSpent, 'player_rank': playerRank,
       'number_of_correct_answers': noOfCorrectAnswers, 'player_id': playerId, 'user_progress': userProgress, 'number_of_rounds': numberOfRoundsLeft}));
  }

  static Future<void> sendGameDataByToken(gameMode, totalScore, baseScore, bonusScore, averageTimeSpent,
      playerRank, noOfCorrectAnswers, playerId, userProgress, numberOfRoundsLeft,token,) async {
    var response = await http.post(Uri.parse('$baseUrl/playlog'), headers: {'Content-Type': 'application/json',
    'accept': 'application/json', 'Authorization': 'Bearer $token'},
        body: jsonEncode({'game_mode': gameMode, 'total_score': totalScore, 'base_score': baseScore,
          'bonus_score': bonusScore, 'average_time_spent': averageTimeSpent, 'player_rank': playerRank,
          'number_of_correct_answers': noOfCorrectAnswers, 'player_id': playerId, 'user_progress': userProgress, 'number_of_rounds': numberOfRoundsLeft}));
  }



}