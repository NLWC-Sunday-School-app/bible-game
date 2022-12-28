import 'package:bible_game/screens/quick_game/step_two.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/tags.dart';

import '../services/user_service.dart';

class TagsPillController extends GetxController {
  bool pillIsSelected = false;
  var selectedPillCount = 0.obs;
  var selectedPill = [].obs;
  var tagList = <Tags>[].obs;
  var isLoading = false.obs;

  void getTags() async {
    isLoading(true);
    try{
       tagList.value = await UserService.getScriptureTags();
       isLoading(false);
    }catch(e){
      isLoading(false);
    }
  }

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

  @override
  void onInit() {
    super.onInit();
    getTags();
  }
}


