import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import '../../controllers/auth_controller.dart';
import '../../utilities/validator.dart';

class CreateProfileModal extends StatefulWidget {
  const CreateProfileModal({Key? key}) : super(key: key);

  @override
  State<CreateProfileModal> createState() => _CreateProfileModalState();
}

class _CreateProfileModalState extends State<CreateProfileModal> {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  bool isToggle = true;

  void toggle() {
    setState(() {
      isToggle = !isToggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    final player = AudioPlayer();
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: SizedBox(
          height: Get.width >= 500 ? 700.h :650.h,
          width:  Get.width >= 500 ? 600.w :500.w,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/modal_layout_2.png'),
                fit: BoxFit.fill
              ),
              ),
            child: Form(
              key: _signUpFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50.h,
                  ),
                  GestureDetector(
                    onTap: () => {
                      player.setAsset('assets/audios/click.mp3'),
                      player.play(),
                      Get.back()
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 15.0.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset('assets/images/icons/close.png', width: 50.w,)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  AutoSizeText(
                    'CREATE PROFILE',
                    style: TextStyle(
                        fontFamily: 'Neuland',
                        fontSize: 24.sp,
                        color: const Color(0xFF4075BB)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AutoSizeText(
                    'Create a profile to save your \ngame progress!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14.sp,fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 45.0.w),
                    child: SizedBox(
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            height: 1.5.sp, color: const Color(0xFF104387),
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFD4DDDF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: 'What’s your nick name?',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Color(0xFFD4DDDF),
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Color(0xFFD4DDDF), width: 1.5)),
                        ),
                        validator: (text) {
                          var validation = Validator.validateName(text!);
                          return validation;
                        },
                        onChanged: (text) =>
                        {authController.username.value = text},
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height <= 670 ? 15.h : 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 45.0.w),
                    child: SizedBox(
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                            height: 1.5.h, color: const Color(0xFF104387)),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFD4DDDF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: 'What’s your email?',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Color(0xFFD4DDDF),
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Color(0xFFD4DDDF), width: 1.5)),
                        ),
                        validator: (text) {
                          var validation = Validator.validateEmail(text!);
                          return validation;
                        },
                        onChanged: (text) =>
                        {authController.emailAddress.value = text},
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height <= 670 ? 15.h : 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 45.0.w),
                    child: SizedBox(
                      child: TextFormField(
                        obscureText: isToggle,
                        style: TextStyle(
                            height: 1.5.h, color: const Color(0xFF104387)),
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFD4DDDF),
                          suffixIcon:   GestureDetector(
                            onTap: () => toggle(),
                            child: !isToggle
                                ? Image.asset(
                              'assets/images/icons/eye_open.png',
                              scale: 1.5,
                            )
                                : Image.asset(
                              'assets/images/icons/eye_closed.png',
                              scale: 1.5,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: 'Password',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                color: Color(0xFFD4DDDF),
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(
                                  color: Color(0xFFD4DDDF), width: 1.5)),
                        ),
                        validator: (text) {
                          var validation = Validator.validatePassword(text!);
                          return validation;
                        },
                        onChanged: (text) =>
                        {authController.password.value = text},
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height <= 670 ? 15 : 20,
                  ),
                  GestureDetector(
                    onTap: () => {
                      if (_signUpFormKey.currentState!.validate())
                        authController.registerUser()
                    },
                    child: Obx(
                          () => Container(
                        width: 200.w,
                        padding: EdgeInsets.symmetric(
                            vertical: Get.height <= 670 ? 10 : 15),
                        decoration: BoxDecoration(
                            color: const Color(0xFF548CD7),
                            border: Border.all(color: const Color(0xFF548CD7)),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(40))),
                        child: authController.isLoadingRegistration.isTrue
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
                          'CREATE PROFILE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'Neuland',
                              letterSpacing: 1,
                              color: Colors.white,
                              fontSize: 14.sp),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ),
          ),
      ),
      );
  }
}
