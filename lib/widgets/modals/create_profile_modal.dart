import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stroke_text/stroke_text.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';
import '../../utilities/validator.dart';
import '../button/modal_blue_button.dart';

class CreateProfileModal extends StatefulWidget {
  const CreateProfileModal({Key? key}) : super(key: key);

  @override
  State<CreateProfileModal> createState() => _CreateProfileModalState();
}

class _CreateProfileModalState extends State<CreateProfileModal> {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  bool isToggle = true;
  String selectedCountry = '';
  final textEditingController = TextEditingController();

  void toggle() {
    setState(() {
      isToggle = !isToggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    UserController _userController = Get.put(UserController());
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: SizedBox(
          height: Get.width >= 500 ? 700.h : 650.h,
          width: Get.width >= 500 ? 600.w : 500.w,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/aesthetics/modal_bg.png'),
                  fit: BoxFit.fill),
            ),
            child: Form(
              key: _signUpFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40.h,
                  ),
                  GestureDetector(
                    onTap: () => {
                      _userController.soundIsOff.isFalse
                          ? _userController.playGameSound()
                          : null,
                      Get.back()
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 35.0.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            'assets/images/icons/close.png',
                            width: 35.w,
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  StrokeText(
                    text: 'Create Profile',
                    textStyle: TextStyle(
                      color: const Color(0xFF1768B9),
                      fontFamily: 'Mikado',
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w900,
                    ),
                    strokeColor: Colors.white,
                    strokeWidth: 5,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Create a profile to save your \ngame progress!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Mikado',
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 45.0.w),
                    child: SizedBox(
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            height: 1.5.sp,
                            color: const Color(0xFF104387),
                            fontFamily: 'Mikado',
                            fontSize: 13.sp),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("[A-Za-z0-9#-]*")),
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFD4DDDF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          hintText: 'What’s your nick name?',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.r),
                              borderSide: const BorderSide(
                                color: Color(0xFFD4DDDF),
                              )),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0.r),
                            borderSide: const BorderSide(
                                color: Color(0xFFB3C1C6), width: 1.5),
                          ),
                        ),
                        validator: (text) {
                          var validation = Validator.validateName(text!);
                          return validation;
                        },
                        onChanged: (text) =>
                            {authController.username.value = text.removeAllWhitespace},
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
                            height: 1.5.h,
                            color: const Color(0xFF104387),
                            fontFamily: 'Mikado',
                            fontSize: 13.sp),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFD4DDDF),
                          focusColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          hintText: 'What’s your email?',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.r),
                              borderSide: const BorderSide(
                                color: Color(0xFFD4DDDF),
                              )),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0.r),
                            borderSide: const BorderSide(
                                color: Color(0xFFB3C1C6), width: 1.5),
                          ),
                        ),
                        validator: (text) {
                          var validation = Validator.validateEmail(text!);
                          return validation;
                        },
                        onChanged: (text) =>
                            {authController.emailAddress.value = text.removeAllWhitespace},
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
                        controller: textEditingController,
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            showPhoneCode: false,
                            onSelect: (Country country) {
                              setState(() => {
                                    textEditingController.text =
                                        country.flagEmoji + country.name
                                  });
                              authController.country.value = country.name;
                            },
                          );
                        },
                        style: TextStyle(
                          height: 1.5.h,
                          color: const Color(0xFF104387),
                          fontFamily: 'Mikado',
                          fontSize: 14.sp,
                        ),
                        readOnly: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFD4DDDF),
                          focusColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          hintText: 'Select your country',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.r),
                              borderSide: const BorderSide(
                                color: Color(0xFFD4DDDF),
                              )),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0.r),
                            borderSide: const BorderSide(
                                color: Color(0xFFB3C1C6), width: 1.5),
                          ),
                          suffixIcon: const Icon(Icons.arrow_drop_down_sharp),
                        ),
                        validator: (text) {
                          var validation = Validator.validateCountry(text!);
                          return validation;
                        },
                        onChanged: (text) =>
                            {authController.emailAddress.value = text.removeAllWhitespace},
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
                          height: 1.5.h,
                          color: const Color(0xFF104387),
                          fontFamily: 'Mikado',
                          fontSize: 13.sp,
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFD4DDDF),
                          suffixIcon: GestureDetector(
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
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          hintText: 'Password',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.r),
                              borderSide: const BorderSide(
                                color: Color(0xFFD4DDDF),
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.r),
                              borderSide: const BorderSide(
                                  color: Color(0xFFD4DDDF), width: 1.5)),
                        ),
                        validator: (text) {
                          var validation = Validator.validatePassword(text!);
                          return validation;
                        },
                        onChanged: (text) =>
                            {authController.password.value = text.removeAllWhitespace},
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height <= 670 ? 15.h : 20.h,
                  ),
                  Obx(
                    () => ModalBlueButton(
                      buttonText: 'Create Profile',
                      buttonIsLoading: authController.isLoadingRegistration.value,
                      onTap: () {
                        if (_signUpFormKey.currentState!.validate()) {
                          authController.registerUser();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
