import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/user_controller.dart';
import '../../utilities/validator.dart';
import '../button/modal_blue_button.dart';
import 'package:get/get.dart';

class CountryUpdateModal extends StatefulWidget {
  const CountryUpdateModal({Key? key}) : super(key: key);

  @override
  State<CountryUpdateModal> createState() => _CountryUpdateModalState();
}

class _CountryUpdateModalState extends State<CountryUpdateModal> {
  final GlobalKey<FormState> _updateFormKey = GlobalKey<FormState>();
  final textEditingController = TextEditingController();
  String selectedCountry = '';

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());
    UserController _userController = Get.put(UserController());
    return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          child: SizedBox(
            height: Get.width >= 500 ? 450.h : 450.h,
            width: Get.width >= 500 ? 600.w : 500.w,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/aesthetics/modal_bg.png'),
                    fit: BoxFit.fill),
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
                        _userController.soundIsOff.isFalse
                            ? _userController.playGameSound()
                            : null,
                        Get.back()
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 20.0.w),
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
                      text: 'Update your profile',
                      textStyle: TextStyle(
                        color: const Color(0xFF1768B9),
                        fontFamily: 'Mikado',
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w900,
                      ),
                      strokeColor: Colors.white,
                      strokeWidth: 5,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'Bible game friends are now in your city! \nWhat country do you reside?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Mikado'),
                    ),
                    SizedBox(
                      height: 40.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 45.0.w),
                      child: SizedBox(
                        child: TextFormField(
                          controller: textEditingController,
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              showPhoneCode: true,
                              // optional. Shows phone code before the country name.
                              onSelect: (Country country) {
                                setState(() => {
                                      textEditingController.text = country.flagEmoji + country.name,
                                       selectedCountry = country.name
                                    });
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
                              suffixIcon:
                                  const Icon(Icons.arrow_drop_down_sharp)),
                          onChanged: (text) =>
                              {authController.emailAddress.value = text},
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height <= 670 ? 15.h : 20.h,
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    Obx(
                      () => ModalBlueButton(
                        buttonIsLoading:
                            _userController.isUpdatingCountry.value,
                        buttonText: 'Update profile',
                        onTap: () {
                          _userController
                              .updateCountry(selectedCountry);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
