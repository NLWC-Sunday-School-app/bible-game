import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import '../models/ads.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class UserController extends GetxController {
  final myUser = <String, dynamic>{}.obs;
  final name = ''.obs;
  final userPilgrimProgress = <dynamic>[].obs;
  final userGameSettings = <String, dynamic>{}.obs;
  final tempPlayerPoint = 0.obs;
  final adsData = <Ads>[].obs;
  var isLoaded = true.obs;
  var isUpdatingCountry = false.obs;
  var isLoadingAds = true.obs;
  var musicIsOff = false.obs;
  var soundIsOff = false.obs;
  var notificationIsOff = false.obs;
  GetStorage box = GetStorage();
  final player = AudioPlayer();
  final player2 = AudioPlayer();
  final player3 = AudioPlayer();
  final player4 = AudioPlayer();
  final player5 = AudioPlayer();
  final backgroundMusicPlayer = AudioPlayer();

  toggleGameMusic() {
    musicIsOff.value = !musicIsOff.value;
    if (musicIsOff.isTrue) {
      backgroundMusicPlayer.pause();
      box.write('pauseGameMusic', true);
    } else {
      backgroundMusicPlayer.play();
      box.write('pauseGameMusic', false);
    }
  }

  Future<void> playGameSound() async {
    await player2.setAsset('assets/audios/click.mp3');
    await player2.play();
  }

  Future<void> playSelectTabSound() async {
    await player3.setAsset('assets/audios/select_tab.mp3');
    await player3.play();
  }

  Future<void> playCorrectAnswerSound() async {
    await player4.setAsset('assets/audios/success.mp3');
    await player4.setVolume(0.4);
    await player4.play();
  }

  Future<void> playWrongAnswerSound() async {
    await player5.setAsset('assets/audios/wrong_answer.wav');
    await player5.play();
  }

  toggleGameSound() {
    soundIsOff.value = !soundIsOff.value;
    if (soundIsOff.isTrue) {
      box.write('pauseGameSound', true);
    } else {
      box.write('pauseGameSound', false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
    player2.dispose();
  }

  toggleNotification() {
    notificationIsOff.value = !notificationIsOff.value;
  }

  setAdsData() async {
    try {
      isLoadingAds(true);
      var adsList = await UserService.getAds();
      adsData.value = adsList;
      isLoaded(false);
      isLoadingAds(false);
    } catch (e) {
      isLoadingAds(false);
    }
  }

  getUserData() async {
    var isLoggedIn = box.read('userLoggedIn') ?? false;
    if (isLoggedIn) {
      try {
        await UserService.getUserData();
        await UserService.getUserPilgrimProgress();
      } catch (e) {}
    }
  }

  updateCountry(String country) async{
    var isLoggedIn = box.read('userLoggedIn') ?? false;
    if(isLoggedIn){
      isUpdatingCountry.value = true;
      await UserService.updateCountry(country);
      isUpdatingCountry.value = false;
      Get.back();
    }
  }

  Future<void> setSoundValue() async {
    await backgroundMusicPlayer.setAsset('assets/audios/background_music.mp3');
    await backgroundMusicPlayer.setVolume(0.1);
    await backgroundMusicPlayer.setLoopMode(LoopMode.all);
    await player2.setAsset('assets/audios/click.mp3');
    await player2.setVolume(0.5);
    musicIsOff.value = box.read('pauseGameMusic') ?? false;
    soundIsOff.value = box.read('pauseGameSound') ?? false;
  }

  @override
  void onClose() {
    player.dispose();
  }

  @override
  void onInit() async {
    super.onInit();
    await setAdsData();
    await setSoundValue();
  }
}
