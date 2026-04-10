import 'package:bible_game_api/api/api_client.dart';
import 'package:bible_game_api/model/game_question.dart';
import 'package:bible_game_api/model/who_is_who_question.dart';
import 'package:bible_game_api/utils/api_exception.dart';
import 'package:flutter/cupertino.dart';

import '../model/four_scriptures.dart';
import '../model/global_game.dart';
import '../model/global_leaderboard.dart';
import '../model/leaderboard.dart';
import '../model/league_data.dart';
import '../model/league_preview.dart';
import '../model/pilgrim_progress_level_data.dart';
import '../model/quick_game_topic.dart';
import '../model/user_league_preview.dart';
import '../model/who_is_who_level.dart';

class GameAPI {
  final ApiClient apiClient;

  GameAPI(this.apiClient);

  Future<List<GameQuestion>> getQuestions(gameMode, userRank, tags) async {
    try {
      final response = await apiClient.post('/games/play',
          data: {'gameMode': gameMode, 'userRank': userRank, 'tags': tags});
      final gameQuestions = (response.data['plays'] as List)
          .map((e) => GameQuestion.fromJson(e))
          .toList();
      return gameQuestions;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<List<GameQuestion>> getGameQuestionsWithoutToken(
      gameMode, userRank, tags) async {
    try {
      final response = await apiClient.post('/games/play/open',
          data: {'gameMode': gameMode, 'userRank': userRank, 'tags': tags});
      final gameQuestions = (response.data['plays'] as List)
          .map((e) => GameQuestion.fromJson(e))
          .toList();
      return gameQuestions;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<List<QuickGameTopic>> getQuickGameTopics() async {
    try {
      final response = await apiClient.get('/tag');
      final tags = (response.data as List)
          .map((e) => QuickGameTopic.fromJson(e))
          .toList();
      return tags;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<List<Leaderboard>> getGameLeaderBoard(id) async {
    try {
      final response = await apiClient.get('/playlog/leaderboards/$id');
      final leaderBoardData =
          (response.data as List).map((e) => Leaderboard.fromJson(e)).toList();
      return leaderBoardData;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<List<Leaderboard>> getFourScriptureGameLeaderBoard(
      campaignType) async {
    try {
      final response = await apiClient.get(
          '/playlog/campaigns/leaderboards?campaign=$campaignType');
      final leaderBoardData = (response.data['data'] as List)
          .map((e) => Leaderboard.fromJson(e))
          .toList();

      return leaderBoardData;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<List<Leaderboard>> getFourScriptureGameLeaderBoardWithoutToken(
      campaignType) async {
    try {
      final response = await apiClient.get(
          '/playlog/open/campaigns/leaderboards?campaign=$campaignType&limit=20');
      final leaderBoardData =
          (response.data as List).map((e) => Leaderboard.fromJson(e)).toList();
      return leaderBoardData;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<List<GlobalChallengeLeaderboard>> getGlobalGameLeaderBoard(
      campaignType) async {
    try {
      final response = await apiClient.get(
          '/playlog/campaigns/leaderboards?campaign=$campaignType&limit=50');

      final leaderBoardData = (response.data['data'] as List)
          .map((e) => GlobalChallengeLeaderboard.fromJson(e))
          .toList();

      return leaderBoardData;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<void> sendGameData(
      gameMode,
      totalScore,
      baseScore,
      bonusScore,
      averageTimeSpent,
      playerRank,
      noOfCorrectAnswers,
      playerId,
      userProgress,
      numberOfRoundsLeft, deviceName, deviceOs) async {
    var gameData = {
      'game_mode': gameMode,
      'total_score': totalScore,
      'base_score': baseScore,
      'bonus_score': bonusScore,
      'average_time_spent': averageTimeSpent,
      'player_rank': playerRank,
      'number_of_correct_answers': noOfCorrectAnswers,
      'player_id': playerId,
      'user_progress': userProgress,
      'number_of_rounds': numberOfRoundsLeft,
      'deviceName': deviceName,
      'deviceOs': deviceOs
    };
    try {
      final response = await apiClient.post('/playlog', data: gameData);
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<List<GlobalGame>> getGlobalGames() async {
    try {
      final response = await apiClient.get('/catalog');
      final globalGameCatalog =
          (response.data as List).map((e) => GlobalGame.fromJson(e)).toList();
      return globalGameCatalog;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<void> updateGlobalChallengeGame(id, title, description, image,
      campaignTag, isActive, isComingSoon, startDate, endDate) async {
    try {
      final response = await apiClient.patch('/catalog/$id', data: {
        "title": title,
        "description": description,
        "image": image,
        "campaign_tag": campaignTag,
        "is_active": isActive,
        "is_coming_soon": isComingSoon,
        "start_date": startDate,
        "end_date": endDate
      });
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<List<FourScripturesOneWordQuestion>> getFourScripturesOneWordQuestions(
      levelNumber) async {
    try {
      final response =
          await apiClient.get('/four-scripts-one-word?level=$levelNumber');
      final questions = (response.data as List)
          .map((e) => FourScripturesOneWordQuestion.fromJson(e))
          .toList();
      return questions;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<dynamic> updateUserFourScriptureOneWordLevel(userId, newLevel) async {
    try {
      final response = await apiClient
          .get('/four-scripts-one-word/users/$userId/level/$newLevel/update');
      return response.data;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<int> getTotalNoOfQuestionsInFourScriptures() async {
    try {
      final response = await apiClient.get('/four-scripts-one-word/total');
      return response.data;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<List<GameQuestion>> getWhoIsWhoQuestions() async {
    try {
      final response = await apiClient.get('/whoiswho/game');
      final questions =
          (response.data as List).map((e) => GameQuestion.fromJson(e)).toList();
      return questions;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<List<GameQuestion>> getGlobalChallengeQuestions(gameTag) async {
    try {
      final response = await apiClient.get('/v2/global-challenge/game?tag=${gameTag}');
      final questions =
      (response.data as List).map((e) => GameQuestion.fromJson(e)).toList();
      return questions;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<List<WhoIsWhoGameLevel>> getWhoIsWhoLevels() async {
    try {
      final response = await apiClient.get('/whoiswho/levels/user');
      final levels = (response.data as List)
          .map((e) => WhoIsWhoGameLevel.fromJson(e))
          .toList();
      return levels;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<bool> buyFromStore(userId, amount) async {
    try {
      final response = await apiClient.post('/store/payment', data: {
        "userId": userId,
        "amount": amount,
        "description": "Game Extra time"
      });
      return response.statusCode == 200;
    } on ApiException catch (e) {
      return false;
    }
  }

  Future<bool> sendWhoIsWhoGameData(
      totalScore, playerId, levelId, completedLevel) async {
    try {
      final response = await apiClient.post('/whoiswho/logs', data: {
        "total_score": totalScore,
        "player_id": playerId,
        "level_id": levelId,
        "completed_level": completedLevel
      });
      return response.statusCode == 200;
    } on ApiException catch (e) {
      return false;
    }
  }

  Future<List<PilgrimProgressLevelData>> getUserPilgrimProgress(userId) async {
    try {
      final response = await apiClient.get('/user/progress/$userId');
      final progressData = (response.data as List)
          .map((e) => PilgrimProgressLevelData.fromJson(e))
          .toList();

      return progressData;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<bool> updatePlayerRank(id, newRank) async {
    try {
      final response =
          await apiClient.patch('/users/$id/rank?newRank=$newRank', data: {});
      return response.statusCode == 200;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<Map<String, dynamic>> createFantasyBibleLeague(name, goal, isOpen, seasonEnd) async {
    try {
     final response =  await apiClient.post('/leagues', data: {
        "name": name,
        "goal": goal,
        "isOpen": isOpen,
        "seasonEnd": seasonEnd
      });
     return response.data;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<List<LeaguePreview>> getOpenLeagues() async {
    try {
      final response = await apiClient.get('/leagues/open');
      final openLeagues = (response.data as List)
          .map((e) => LeaguePreview.fromJson(e))
          .toList();
      return openLeagues;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<List<LeaguePreview>> findLeague(code) async {
    try {
      final response = await apiClient.get('/leagues/find?query=$code');
      final openLeagues = (response.data as List)
          .map((e) => LeaguePreview.fromJson(e))
          .toList();
      return openLeagues;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<List<QuickGameTopic>> findQuickGameTopic(code) async {
    try {
      final response = await apiClient.get('/tag/search?query=$code');
      final tags = (response.data as List)
          .map((e) => QuickGameTopic.fromJson(e))
          .toList();
      return tags;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<List<UserLeaguePreview>> getUserLeagues(userId) async {
    try {
      final response = await apiClient.get('/leagues/user/$userId');
      final openLeagues = (response.data as List)
          .map((e) => UserLeaguePreview.fromJson(e))
          .toList();
      return openLeagues;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<LeagueData> viewLeagueData(leagueId) async {
    try {
      final response = await apiClient.get('/leagues/$leagueId/board');
      return LeagueData.fromJson(response.data);
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<void> joinLeague(leagueId) async {
    try {
      await apiClient.get('/leagues/$leagueId/join');
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<Map<String, dynamic>> joinLeagueWithCode(leagueCode) async {
    try {
      final response =  await apiClient.get('/leagues/join?code=$leagueCode');
      return response.data;
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<void> leaveLeague(leagueId) async {
    try {
      await apiClient.delete('/leagues/$leagueId/leave');
    } on ApiException catch (e) {
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<Map<String, dynamic>> editFantasyBibleLeague(name, isOpen, leagueId,) async{
    try{
      final response =  await apiClient.patch('/leagues/$leagueId ', data: {
         "name": name,
         "isOpen": isOpen,
       });
       return response.data;
    }on ApiException catch (e){
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }

  Future<Map<String, dynamic>> endFantasyBibleLeague(name, isOpen, leagueId,) async{
    try{
      final response =  await apiClient.patch('/leagues/$leagueId ', data: {
        "name": name,
        "isOpen": isOpen,
         "status": "ENDED"
      });
      return response.data;
    }on ApiException catch (e){
      final errorMessage = e.toString();
      throw errorMessage;
    }
  }




}
