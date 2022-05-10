import 'package:bible_game/screens/authentication/signup.dart';
import 'package:bible_game/screens/tab_main_screen.dart';
import 'package:bible_game/widgets/onboarding/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static String routeName = "/login-screen";

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
                          'Sign in',
                          style: TextStyle(
                              fontSize: 34.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color.fromRGBO(54, 42, 122, 1)),
                        ),
                        SizedBox(
                          height: 28.h,
                        ),
                        TextField(
                          style:
                              const TextStyle(height: 0.8, color: Colors.black),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: 'Email Address ',
                          ),
                        ),
                        SizedBox(
                          height: 13.h,
                        ),
                        SizedBox(
                          height: 13.h,
                        ),
                        TextField(
                          style:
                              const TextStyle(height: 0.8, color: Colors.black),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: 'Password ',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 350.h, left: 30.w),
                child: Image.asset('assets/images/cloud_two.png'),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 400.h),
                  child: AuthButton(
                    buttonText: 'SIGN IN',
                    goToNextScreen: () => goToLoginScreen(context),
                  ),
                ),
              ),
              Center(
                child: InkWell(
                  onTap: () => goToTabMainScreen(context),
                  child: Container(
                    margin: EdgeInsets.only(top: 500.h),
                    child: Text(
                      'New here? Get started',
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                          color: const Color(0xFFFFFFFF)),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
    );
  }
}
