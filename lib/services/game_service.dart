import 'dart:convert';
import 'package:bible_game/models/leaderboard.dart';
import 'package:bible_game/models/whoIsWhoLevel.dart';
import 'package:bible_game/services/user_service.dart';
import 'package:bible_game/utilities/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../models/fourScripturesOneWord.dart';
import '../models/games.dart';
import '../models/globalLeaderboard.dart';
import '../models/question.dart';
import '../models/whoIsWho.dart';
import '../utilities/dio_exceptions.dart';
import '../widgets/who_is_who/who_is_who_level.dart';
import 'base_url_service.dart';

class GameService {
  static dynamic token = GetStorage().read('user_token');

  static Future<List<Question>> getGameQuestions(gameMode, userRank, tags) async {
    try{
      final response = await DioClient().dio.post('/games/play', data: {
        'gameMode': gameMode,
        'userRank': userRank,
        'tags': tags
      });
      print('test1 ${response.data['plays']}');
      final gameQuestions = (response.data['plays'] as List)
            .map((e) => Question.fromJson(e))
             .toList();

      return gameQuestions;
    }on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<List<Question>> getGameQuestionsWithoutToken(gameMode, userRank, tags) async{
    try{
       final response = await DioClient().dio.post('/games/play/open', data: {
         'gameMode': gameMode,
         'userRank': userRank,
         'tags': tags
       });
       final gameQuestions = (response.data['plays'] as List)
           .map((e) => Question.fromJson(e))
           .toList();
       return gameQuestions;
    }on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }

  }

  static Future<List<Leaderboard>> getGameLeaderBoard(id) async{
    try{
       final response = await DioClient().dio.get('/playlog/leaderboards/$id');
       final leaderBoardData = (response.data as List)
         .map((e) => Leaderboard.fromJson(e))
         .toList();
       return leaderBoardData;
    }on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }

  }

  static Future<List<Leaderboard>> getFourScriptureGameLeaderBoard(campaignType) async{
    try{
       final response = await DioClient().dio.get('/playlog/campaigns/leaderboards?campaign=$campaignType&limit=20');
       final leaderBoardData = (response.data as List)
           .map((e) => Leaderboard.fromJson(e))
           .toList();
       return leaderBoardData;
    }on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }

  }

  static Future<List<Leaderboard>> getFourScriptureGameLeaderBoardWithoutToken(campaignType) async{
    try{
      final response = await DioClient().dio.get('/playlog/open/campaigns/leaderboards?campaign=$campaignType&limit=20');
      final leaderBoardData = (response.data as List)
          .map((e) => Leaderboard.fromJson(e))
          .toList();
      return leaderBoardData;
    }on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }

  }

  static Future<List<GlobalLeaderboard>> getGlobalGameLeaderBoard(campaignType) async{
    try{
      final response = await DioClient().dio.get('/playlog/campaigns/leaderboards?campaign=$campaignType&limit=20');
      final globalLeaderBoardData = (response.data as List)
          .map((e) => GlobalLeaderboard.fromJson(e))
          .toList();
      return globalLeaderBoardData;
    }on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<List<Leaderboard>> getGameLeaderBoardWithoutToken(id) async{
    try{
      final response = await DioClient().dio.get('/playlog/open/leaderboards/$id');
      final leaderBoardData = (response.data as List)
          .map((e) => Leaderboard.fromJson(e))
          .toList();
      return leaderBoardData;
    }on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<void> sendGameData(gameMode, totalScore, baseScore, bonusScore, averageTimeSpent,playerRank, noOfCorrectAnswers, playerId, userProgress, numberOfRoundsLeft) async {

    var gameData = {
      'game_mode': gameMode, 'total_score': totalScore, 'base_score': baseScore,
      'bonus_score': bonusScore, 'average_time_spent': averageTimeSpent, 'player_rank': playerRank,
      'number_of_correct_answers': noOfCorrectAnswers, 'player_id': playerId, 'user_progress': userProgress, 'number_of_rounds': numberOfRoundsLeft
    };
    print(gameData);
    try{
      final response = await DioClient().dio.post('/playlog', data: gameData);
    }on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<void> sendGameDataByToken(gameMode, totalScore, baseScore, bonusScore, averageTimeSpent,
      playerRank, noOfCorrectAnswers, playerId, userProgress, numberOfRoundsLeft,token,) async {

    var gameData = {
      'game_mode': gameMode, 'total_score': totalScore, 'base_score': baseScore,
      'bonus_score': bonusScore, 'average_time_spent': averageTimeSpent, 'player_rank': playerRank,
      'number_of_correct_answers': noOfCorrectAnswers, 'player_id': playerId, 'user_progress': userProgress, 'number_of_rounds': numberOfRoundsLeft
    };

    try{
       final response = await DioClient().dio.post('/playlog', data: gameData);
    }on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }

  }

  static Future<List<GlobalGames>> getGlobalGames() async{
    try{
      final response = await DioClient().dio.get('/catalog');
      final globalGameCatalog = (response.data as List)
            .map((e) => GlobalGames.fromJson(e))
             .toList();
      return globalGameCatalog;
    }on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<List<FourScripturesOneWordQuestion>> getFourScripturesOneWordQuestions(levelNumber) async{
    try{
      final response = await DioClient().dio.get('/four-scripts-one-word?level=$levelNumber');
      final questions = (response.data as List)
            .map((e) => FourScripturesOneWordQuestion.fromJson(e))
            .toList();
      return questions;
    }on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }

  }

  static Future<dynamic>updateUserFourScriptureOneWordLevel(userId, newLevel) async {
    try{
       final response = await DioClient().dio.get('/four-scripts-one-word/users/$userId/level/$newLevel/update');
       return response.data;
    }on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }

  }

  static Future<int>getTotalNoOfQuestionsInFourScriptures()async {
    try{
      final response = await DioClient().dio.get('/four-scripts-one-word/total');
      return response.data;
    }on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }

  }

  static Future<List<WhoIsWho>> getWhoIsWhoQuestions() async{
    try{
      final response = await DioClient().dio.get('/whoiswho/game');
      final questions = (response.data as List)
          .map((e) => WhoIsWho.fromJson(e))
          .toList();
      return questions;
    }on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }
  }

  static Future<List<WhoIsWhoGameLevel>> getWhoIsWhoLevels() async{
    try{
      final response = await DioClient().dio.get('/whoiswho/levels/user');
      final levels = (response.data as List)
          .map((e) => WhoIsWhoGameLevel.fromJson(e))
          .toList();
      return levels;
    }on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }

  }

  static Future<dynamic> buyFromStore(userId, amount) async {
    try{
      final response = await DioClient().dio.post('/store/payment', data:{
        "userId": userId,
        "amount": amount,
        "description": "Game Extra time"

      });
      return response.statusCode;
    } on DioException catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      throw errorMessage;
    }

  }


}