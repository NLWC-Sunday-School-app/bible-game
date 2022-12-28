import 'package:bible_game/screens/authentication/signup.dart';
import 'package:bible_game/screens/tabs/tab_main_screen.dart';
import 'package:bible_game/services/user_service.dart';
import 'package:bible_game/widgets/onboarding/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../utilities/validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static String routeName = "/login-screen";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  AuthController authController = Get.put(AuthController());

  void goToLoginScreen(BuildContext context) {
    Navigator.of(context).pushNamed(SignUpScreen.routeName);
  }

  void goToTabMainScreen(BuildContext context) {
    Navigator.of(context).pushNamed(TabMainScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: const Color(0xFF7663E5),
        body: SingleChildScrollView(
          child: Form(
            key: _loginFormKey,
            child: Stack(
              children: [
                SizedBox(
                  height: 359.h,
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
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
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
                            'Sign in',
                            style: TextStyle(
                                fontSize: 34.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color.fromRGBO(54, 42, 122, 1)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 350.h, left: 100.w),
                  child: Image.asset('assets/images/cloud_two.png'),
                ),
                Container(
                  margin: EdgeInsets.only(top: 150.h),
                  padding: EdgeInsets.symmetric(horizontal: 22.w),
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        style:
                        const TextStyle(height: 1.5, color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'Email Address',
                          hintText: 'Email Address ',
                        ),
                        validator: (text) {
                          var validation = Validator.validateEmail(text!);
                          return validation;
                        },
                        onChanged: (text) => { authController.emailAddress.value = text},

                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        style:
                        const TextStyle(height: 1.5, color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: 'Password',
                          hintText: 'Password ',
                        ),
                        validator: (text) {
                          var validation = Validator.validatePassword(text!);
                          return validation;
                        },
                        onChanged: (text) => { authController.password.value = text},
                      ),
                      const SizedBox(height: 150),
                      Center(
                        child: Obx(
                          () => AuthButton(
                            isLoading: authController.isLoadingLogin.value,
                            buttonText: 'SIGN IN',
                            goToNextScreen: () async => {
                              if (_loginFormKey.currentState!.validate()) {
                                await authController.loginUser(),
                                await UserService.getUserPilgrimProgress(),
                                await UserService.getUserGameSettings(),
                              },
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: GestureDetector(
                          onTap: () => Get.to(() => const SignUpScreen()),
                          child: Text(
                            'New here? Get started',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp,
                                color: const Color(0xFFFFFFFF)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}
