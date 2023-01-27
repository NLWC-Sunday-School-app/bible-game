import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import '../models/ads.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class UserController extends GetxController {
  final myUser = <String, dynamic>{}.obs;
  final name = ''.obs;
  final userPilgrimProgress = [].obs;
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


  toggleMusic(){

    if(soundIsOff.isFalse){
      player2.setAsset('assets/audios/click.mp3');
      player2.play();
    }
    musicIsOff.value = !musicIsOff.value;
    if(musicIsOff.isTrue){
      player.pause();
      box.write('pauseMusic', true);
    }else{
      player.play();
      box.write('pauseMusic', false);
    }
  }

  toggleSound(){
    player2.setAsset('assets/audios/click.mp3');
    player2.play();
    soundIsOff.value = !soundIsOff.value;
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
    player2.dispose();
  }

  toggleNotification(){
    if(soundIsOff.isFalse){
      player2.setAsset('assets/audios/click.mp3');
      player2.play();
    }
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

  getUserData() async{
    var isLoggedIn = box.read('userLoggedIn') ?? false;
    if(isLoggedIn){
      await UserService.getUserData();
      await UserService.getUserPilgrimProgress();
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await setAdsData();
  }
}
