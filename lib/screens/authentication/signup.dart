
import 'package:bible_game/utilities/validator.dart';
import 'package:bible_game/widgets/onboarding/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import 'login.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static String routeName = "/signup-screen";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _registrationFormKey = GlobalKey<FormState>();

 AuthController authController = Get.put(AuthController());
  onCountryChange(CountryCode countryCode){
    authController.countryCode.value = countryCode.toString().substring(1);
  }
  void goToLoginScreen(BuildContext context) {
    Navigator.of(context).pushNamed(LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
        backgroundColor: const Color(0xFF7663E5),
        body: SingleChildScrollView(
          child: Form(
            key: _registrationFormKey,
            child: Stack(
              children: [
                SizedBox(
                  height: 500.h,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xfff2f3f7),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(60.r),
                        bottomRight: Radius.circular(60.r),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 22.0.w, right: 22.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 50.h,
                            ),
                            Text(
                              'WORDGAME',
                              style: TextStyle(
                                color: const Color(0xFF362A7A),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            Text(
                              'Get started',
                              style: TextStyle(
                                  fontSize: 34.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color.fromRGBO(54, 42, 122, 1)),
                            ),
                            SizedBox(
                              height: 28.h,
                            ),

                          ],
                        ),

                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 150.h),
                  padding: EdgeInsets.symmetric(horizontal: 22.w),
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (text) {
                        var validation = Validator.validateName(text!);
                        return validation;
                        },
                        style: const TextStyle(height: 1.3, color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'Name',
                          hintText: 'Name',
                        ),
                        onChanged: (text) => {authController.username.value = text},
                      ),
                      SizedBox(
                        height: 13.h,
                      ),
                      Row(
                        children: [
                          Container(
                            height: 58.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromRGBO(118, 99, 229, 1),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CountryCodePicker(
                              onChanged: onCountryChange,
                              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                              initialSelection: 'NG',
                              favorite: ['NG'],
                              // optional. Shows only country name and flag
                              showCountryOnly: false,
                              // optional. Shows only country name and flag when popup is closed.
                              showOnlyCountryWhenClosed: false,
                              flagDecoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                ),
                              ),
                              flagWidth: 50.w,
                              // optional. aligns the flag and the Text left
                              alignLeft: false,
                            ),
                          ),
                              const SizedBox(width: 20,),
                              Expanded(
                                child: TextFormField(
                                  keyboardType: TextInputType.phone,
                                  style: const TextStyle(
                                      height: 1.3, color: Colors.black),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),

                                    hintText: 'Phone Number',
                                  ),
                                  validator: (text) {
                                    var validation = Validator.validatePhoneNumber(text!);
                                    return validation;
                                  },
                                  onChanged: (text) => {
                                    authController.phoneNumber.value = authController.countryCode.value + text,
                                  },
                                ),
                              ),
                        ],
                      ),
                      SizedBox(
                        height: 13.h,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        style:
                        const TextStyle(height: 1.3, color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'Email Address',
                          hintText: 'Email Address',
                        ),
                        validator: (text) {
                          var validation = Validator.validateEmail(text!);
                          return validation;
                        },
                        onChanged: (text) => {authController.emailAddress.value = text},
                      ),
                      SizedBox(
                        height: 13.h,
                      ),
                      TextFormField(
                        obscureText: true,
                        style:
                        const TextStyle(height: 1.3, color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'Password',
                          hintText: 'Password',
                        ),
                        validator: (text) {
                          var validation = Validator.validatePassword(text!);
                          return validation;
                        },
                        onChanged: (text) => {authController.password.value = text},
                      ),
                      const SizedBox(height: 180,),

                      Center(
                        child: Obx( () => AuthButton(
                            isLoading: authController.isLoadingRegistration.value,
                            buttonText: 'GET STARTED',
                            goToNextScreen: () => {
                          if (_registrationFormKey.currentState!.validate()) {
                            authController.registerUser()
                          },
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 30,),
                      Center(
                        child: GestureDetector(
                          onTap: () => Get.to(() => const LoginScreen()),
                          child: Text(
                            'Have an account? Sign in',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                                color: const Color(0xFFFFFFFF)),
                          ),
                        ),
                      )

                    ],),
                ),
                // SvgPicture.asset('assets/images/clouds.svg')
                Container(
                  margin: EdgeInsets.only(top: 520.h, left: 200.w),
                  child: Image.asset('assets/images/cloud.png'),
                ),

              ],
            ),
          ),
        ),
    );
  }
}
