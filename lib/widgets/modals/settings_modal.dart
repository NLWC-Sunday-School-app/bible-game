import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/services/base_url_service.dart';
import 'package:bible_game/widgets/modals/edit_profile.dart';
import 'package:bible_game/widgets/modals/logout_modal.dart';
import 'package:bible_game/widgets/modals/reset_password_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';
import 'delete_account_modal.dart';

class SettingsModal extends StatefulWidget {
  const SettingsModal({Key? key}) : super(key: key);

  @override
  State<SettingsModal> createState() => _SettingsModalState();
}

class _SettingsModalState extends State<SettingsModal> {
  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();
    AuthController authController = Get.put(AuthController());
    UserController _userController = Get.put(UserController());
    return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 25.w),
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          child: SizedBox(
            height: Get.width >= 500 ? 600.h : Get.height >= 800 ? 550.h : 650.h,
            width: Get.width >= 500? 500.h : 400.h,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/modal_layout_2.png'),
                    fit: BoxFit.fill),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50.h,
                  ),
                  GestureDetector(
                    onTap: () => {
                      _userController.soundIsOff.isFalse ? _userController.playGameSound() : null,
                      Get.back()
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 15.0.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/images/icons/close.png',
                            width: 40.w,
                          )
                        ],
                      ),
                    ),
                  ),
                  AutoSizeText(
                    'YOUR PROFILE',
                    style: TextStyle(
                        fontFamily: 'Neuland',
                        fontSize: 24.sp,
                        color: const Color(0xFF4075BB)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Image.network(
                    '${BaseUrlService.avatarBaseUrl}/${_userController.myUser['id']}.png',
                    width: 60.w,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Obx(
                    () => AutoSizeText(
                      (_userController.myUser['name']),
                      style: TextStyle(
                          fontSize: 20.sp,
                          color: const Color(0xFF323B63),
                          fontFamily: 'Neuland',
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                    onTap: (){
                      _userController.soundIsOff.isFalse ? _userController.playGameSound() : null;
                      Get.back();
                      Get.dialog(const EditProfileModal(),);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        SvgPicture.asset('assets/images/icons/edit.svg', width: 15.w,),
                        SizedBox(width: 5.w,),
                        Text(
                          'Edit your Profile',
                          style: TextStyle(
                              color: const Color(0xFF4075BB),
                             fontSize: 14.sp,
                             fontWeight: FontWeight.w500,
                             decoration: TextDecoration.underline
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 10.h,),
                  GestureDetector(
                    onTap: (){
                      _userController.soundIsOff.isFalse ? _userController.playGameSound() : null;
                      Get.back();
                      Get.dialog(const EditProfileModal(),);
                    },
                    child: InkWell(
                      onTap: (){
                        Get.back();
                        Get.dialog(const ResetPasswordModal());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/icons/blue_padlock.png', width: 15.w,),
                          SizedBox(width: 5.w,),
                          Text(
                            'Reset Password',
                            style: TextStyle(
                                color: const Color(0xFF4075BB),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Obx(
                            () => IconButton(
                              iconSize: 50,
                              onPressed: () =>{
                                _userController.soundIsOff.isFalse ? _userController.playGameSound() : null,
                                _userController.toggleGameSound(),
                              },

                              icon: _userController.soundIsOff.value
                                  ? Image.asset(
                                      'assets/images/icons/volume_down.png',
                                    )
                                  : Image.asset(
                                      'assets/images/icons/volume_up.png',
                                    ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Obx(
                            () => IconButton(
                                iconSize: 50,
                                onPressed: () =>{
                                  _userController.soundIsOff.isFalse ? _userController.playGameSound() : null,
                                  _userController.toggleGameMusic(),
                                },
                                icon: _userController.musicIsOff.value
                                    ? Image.asset(
                                        'assets/images/icons/music_off.png',
                                      )
                                    : Image.asset(
                                        'assets/images/icons/music_on.png',
                                      )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Obx(
                            () => IconButton(
                                iconSize: 50,
                                onPressed: () =>{
                                  _userController.soundIsOff.isFalse ? _userController.playGameSound() : null,
                                  _userController.toggleNotification(),
                                },

                                icon: _userController.notificationIsOff.value
                                    ? Image.asset(
                                        'assets/images/icons/notification_off.png',
                                      )
                                    : Image.asset(
                                        'assets/images/icons/notification.png',
                                      )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () => {
                      _userController.soundIsOff.isFalse ? _userController.playGameSound() : null,
                      Get.back(),
                      Get.dialog(const LogoutModal()),
                    },
                    child: Container(
                        width: 200.w,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                            color: const Color(0xFF548BD5),
                            border: Border.all(color: const Color(0xFF548CD7)),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(40))),
                        child: Text(
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
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: (){
                      Get.back();
                      Get.dialog(const DeleterAccountModal());
                    },
                    child: const Text(
                      'Delete Account', style: TextStyle(
                       color: Colors.red,
                       decoration: TextDecoration.underline
                     ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
