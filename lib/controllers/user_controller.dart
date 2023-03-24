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
  var isLoaded = false.obs;
  var musicIsOff = false.obs;
  var soundIsOff = false.obs;
  var notificationIsOff = false.obs;
  GetStorage box = GetStorage();
  final player = AudioPlayer();
  final player2 = AudioPlayer();
  final player3 = AudioPlayer();
  final player4 = AudioPlayer();
  final player5 = AudioPlayer();

  toggleGameMusic() {
    musicIsOff.value = !musicIsOff.value;
    if (musicIsOff.isTrue) {
      player.pause();
      box.write('pauseGameMusic', true);
    } else {
      player.play();
      box.write('pauseGameMusic', false);
    }
  }
  playGameSound(){
    player2.setAsset('assets/audios/click.mp3');
    player2.play();
  }
  playSelectTabSound(){
    player3.setAsset('assets/audios/select_tab.mp3');
    player3.play();
  }
  playCorrectAnswerSound(){
    player4.setAsset('assets/audios/success.mp3');
    player4.setVolume(0.4);
    player4.play();
  }
  playWrongAnswerSound(){
    player5.setAsset('assets/audios/wrong_answer.wav');
    player5.play();
  }
  toggleGameSound() {
    soundIsOff.value = !soundIsOff.value;
    if(soundIsOff.isTrue){
      box.write('pauseGameSound', true);
    }else{
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
      var adsList = await UserService.getAds();
      adsData.value = adsList;
      isLoaded(true);
    } catch (e) {
      print(e);
    }
  }

  getUserData() async {
    var isLoggedIn = box.read('userLoggedIn') ?? false;
    if (isLoggedIn) {
      try{
        await UserService.getUserData();
        await UserService.getUserPilgrimProgress();
      }catch(e){

      }

    }
  }

  @override
  void onInit() async {
    super.onInit();
    player.setAsset('assets/audios/background_music.mp3');
    player.setVolume(0.1);
    player.setLoopMode(LoopMode.all);
    player2.setAsset('assets/audios/click.mp3');
    player2.setVolume(0.5);
    musicIsOff.value = box.read('pauseGameMusic') ?? false;
    soundIsOff.value = box.read('pauseGameSound') ?? false;
    await setAdsData();
  }
}
