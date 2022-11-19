import 'package:bible_game/screens/quick_game/step_two.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/topic.dart';

class TopicPillController extends GetxController {
  bool pillIsSelected = false;
  var selectedPillCount = 0.obs;
  var selectedPill = [].obs;
  final List<Topic> _topics = topicsList
      .map(
        (topic) => Topic(topic['id'], topic['topic']),
      )
      .toList();

  List<Topic> get topics => _topics;

  togglePillColor() {
    // pillIsSelected = !pillIsSelected;
    if (selectedPillCount < 4) {
      // selectedPill.add(id);
      pillIsSelected = !pillIsSelected;
      selectedPillCount.value++;
      print(selectedPill);
    } else {
      Get.snackbar('Oops', 'You cannot select more than 3 topics',
      backgroundColor: const Color.fromRGBO(255, 129, 220, 0.9)
      );
    }
  }

  void goToQuickGameStepTwoScreen() {
    Get.to(() => const QuickGameStepTwoScreen());
  }
}
