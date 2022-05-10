import 'package:bible_game/widgets/onboarding/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'login.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  static String routeName = "/signup-screen";

  void goToLoginScreen(BuildContext context) {
    Navigator.of(context).pushNamed(LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF7663E5),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              SizedBox(
                height: 501.h,
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
                        TextField(
                          style:
                              const TextStyle(height: 0.8, color: Colors.black),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: 'Enter Your ',
                          ),
                        ),
                        SizedBox(
                          height: 13.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextField(
                                style: const TextStyle(
                                    height: 0.8, color: Colors.black),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  hintText: 'Enter Your ',
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 13,
                            ),
                            Expanded(
                              child: TextField(
                                style: const TextStyle(
                                    height: 0.8, color: Colors.black),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  hintText: 'Enter Your ',
                                ),
                              ),
                            ),
                          ],
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
                            hintText: 'Enter Your ',
                          ),
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
                            hintText: 'Enter Your ',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // SvgPicture.asset('assets/images/clouds.svg')
              Container(
                margin: EdgeInsets.only(top: 520.h, left: 150.w),
                child: Image.asset('assets/images/cloud.png'),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 550.h),
                  child: AuthButton(
                    buttonText: 'GET STARTED',
                    goToNextScreen: () => goToLoginScreen(context),
                  ),
                ),
              ),
              Center(
                child: InkWell(
                  onTap: () => goToLoginScreen(context),
                  child: Container(
                    margin: EdgeInsets.only(top: 650.h),
                    child: Text(
                      'Have an account? Sign in',
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
      ),
    );
  }
}
