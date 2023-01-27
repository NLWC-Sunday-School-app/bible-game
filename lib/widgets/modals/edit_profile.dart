import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../utilities/validator.dart';

class EditProfileModal extends StatefulWidget {
  const EditProfileModal({Key? key}) : super(key: key);

  @override
  State<EditProfileModal> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfileModal> {
  final GlobalKey<FormState> _updateFormKey = GlobalKey<FormState>();
  UserController userController = Get.put(UserController());
  AuthController authController = Get.put(AuthController());
  final player = AudioPlayer();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isToggle = true;
  GetStorage box = GetStorage();

  @override
  void initState() {
    super.initState();
    print(userController.myUser);
    nameController.text = userController.myUser['name'];
    emailController.text = userController.myUser['email'];
    passwordController.text = box.read('password');
    authController.updatedName.value = userController.myUser['name'];
    authController.updatedPassword.value = box.read('password');
    authController.updatedEmailAddress.value = userController.myUser['email'];
    print(box.read('password'));
  }



  void toggle() {
    setState(() {
      isToggle = !isToggle;
    });
  }
  @override
  Widget build(BuildContext context) {

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: SizedBox(
          height: Get.width >= 500 ? 500.h : Get.height >= 800 ? 450.h : 500.h,
          width:  Get.width >= 500 ? 600.w :500.w,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/modal_layout_2.png'),
                  fit: BoxFit.fill
              ),
            ),
            child: Form(
              key: _updateFormKey,
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
                    'EDIT PROFILE',
                    style: TextStyle(
                        fontFamily: 'Neuland',
                        fontSize: 24.sp,
                        color: const Color(0xFF4075BB)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AutoSizeText(
                    'You can make updates to \n your profile',
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
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          height: 1.5.sp, color: const Color(0xFF104387), fontSize: 12.sp
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
                        {authController.updatedName.value = text},
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height <= 670 ? 15.h : 20.h,
                  ),

                  SizedBox(
                    height: Get.height <= 670 ? 15.h : 20.h,
                  ),

                  GestureDetector(
                    onTap: () => {
                      if (_updateFormKey.currentState!.validate())
                        authController.updateUserProfile(userController.myUser['id'])
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
                        child: authController.isLoadingUpdate.isTrue
                            ? Center(
                          child: SizedBox(
                              height: 20.w,
                              width: 20.w,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFFFFFFFF),
                              )),
                        )
                            : Text(
                          'UPDATE PROFILE',
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
