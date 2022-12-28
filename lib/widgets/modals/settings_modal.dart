import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';

class SettingsModal extends StatefulWidget {
  const SettingsModal({Key? key}) : super(key: key);

  @override
  State<SettingsModal> createState() => _SettingsModalState();
}

class _SettingsModalState extends State<SettingsModal> {


  @override
  Widget build(BuildContext context) {
    final assetsAudioPlayer = AssetsAudioPlayer();
    AuthController authController = Get.put(AuthController());
    UserController _userController = Get.put(UserController());
    return Dialog(
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          child: SizedBox(
            height: 500,
            width: 350,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/modal_layout_2.png'),
                    fit: BoxFit.fill),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const AutoSizeText(
                    'YOUR PROFILE',
                    style: TextStyle(
                        fontFamily: 'Neuland',
                        fontSize: 28,
                        color: Color(0xFF4075BB)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SvgPicture.network(
                    'https://api.multiavatar.com/${_userController.myUser['id']}.svg ',
                    width: 60,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Obx(
                      ()=> AutoSizeText(
                      (_userController.myUser['name']),
                      style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF4075BB),
                          fontFamily: 'Neuland',
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15))
                    ),
                    child: Obx(
                        () => Text(
                        'LEVEL: ${_userController.myUser['rank'].toString().toUpperCase()}',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Obx(
                            ()=> IconButton(
                              iconSize: 50,
                                onPressed: () => _userController.toggleSound(),
                                icon: _userController.soundIsOff.value ? Image.asset('assets/images/icons/volume_down.png',) :  Image.asset('assets/images/icons/volume_up.png',),),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Obx(
                              ()=> IconButton(
                                iconSize: 50,
                                onPressed: () => _userController.toggleNotification(),
                                icon: _userController.notificationIsOff.value ? Image.asset('assets/images/icons/notification_off.png',) : Image.asset('assets/images/icons/notification.png',)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () => {
                      authController.logoutUser(),
                    },
                    child: Obx(
                      () => Container(
                        width: 200.w,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                            color: const Color(0xFF4075BB),
                            border: Border.all(color: const Color(0xFF548CD7)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(40))),
                        child: authController.isLoadingLogout.isTrue
                            ? const Center(
                                child: SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFFFFFFFF),
                                    )),
                              )
                            : Text(
                                'LOG OUT',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Neuland',
                                    letterSpacing: 1,
                                    color: const Color(0xFFFFFFFF),
                                    fontSize: 14.sp),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
