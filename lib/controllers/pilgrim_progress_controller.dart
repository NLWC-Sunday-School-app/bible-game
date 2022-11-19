import 'package:bible_game/models/question.dart';
import 'package:get/get.dart';

import '../screens/pilgrim_progress/pilgrim_progress_question_screen.dart';

class PilgrimProgressController extends GetxController {
  var babeProgressLevelValue = 0.0.obs;
  var childProgressLevelValue = 0.0.obs;
  var youngBelieverProgressLevelValue = 0.0.obs;
  var charityProgressLevelValue = 0.0.obs;
  var fatherProgressLevelValue = 0.0.obs;
  var elderProgressLevelValue = 0.0.obs;
  final questionData = [].obs;

  var selectedLevel = ''.obs;
  var durationPerQuestion = 20;

  var babeLevelIsLocked = false.obs;
  var childLevelIsLocked = true.obs;
  var youngBelieversLevelIsLocked = true.obs;
  var charityLevelIsLocked = true.obs;
  var fatherLevelIsLocked = true.obs;
  var elderLevelIsLocked = true.obs;

  setSelectedLevel(level) {
    selectedLevel.value = level;
    switch (level) {
      case 'babe':
        durationPerQuestion = 20;
        break;
      case 'child':
        durationPerQuestion = 20;
        break;
      case 'young believer':
        durationPerQuestion = 10;
        break;
      case 'charity':
        durationPerQuestion = 10;
        break;
      case 'father':
        durationPerQuestion = 5;
        break;
      case 'elder':
        durationPerQuestion = 5;
        break;
      default:
        break;
    }
    print(level);
    getSelectedLevelQuestions(level);
  }

  getSelectedLevelQuestions(level) {
    questionData.value = pilgrimQuestionsData;
    Get.to(() => const PilgrimProgressQuestionScreen(),
        transition: Transition.rightToLeftWithFade);
  }


}
