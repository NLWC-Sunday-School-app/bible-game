import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:the_bible_game/features/home/widget/modals/reset_password_modal.dart';
import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/widgets/blue_button.dart';

void showLoginModal(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return
          Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
          backgroundColor: Colors.transparent,
          insetAnimationCurve: Curves.easeIn,
          insetAnimationDuration: const Duration(milliseconds: 500),
          child: SizedBox(
            height: 500.h,
            width: 500.w,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.modalBg),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 50.h,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            IconImageRoutes.closeModal,
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
                    text: 'Log in to play',
                    textStyle: TextStyle(
                      color: const Color(0xFF1768B9),
                      fontFamily: 'Mikado',
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w900,
                    ),
                    strokeColor: Colors.white,
                    strokeWidth: 5,
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    'Pick up from where you stopped!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Mikado'),
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
                            height: 1.5.h,
                            color: const Color(0xFF104387),
                            fontSize: 12.sp,
                            ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFD4DDDF),
                          focusColor: Colors.red,
                          errorStyle: TextStyle(fontSize: 12.sp),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: 'Input your email',
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
                        validator: (text) {},
                        onChanged: (text) => {},
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 45.0.w),
                    child: SizedBox(
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: false,
                        style: TextStyle(
                            height: 1.2.h,
                            color: const Color(0xFF104387),
                        ),
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                            onTap: () {},
                            child: Image.asset(
                              IconImageRoutes.eyeOpen,
                              scale: 1.5,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFD4DDDF),
                          errorStyle: TextStyle(fontSize: 12.sp),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          hintText: 'Password',
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: const BorderSide(
                                color: Color(0xFFD4DDDF),
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide(
                                color: Color(0xFFD4DDDF),
                                width: 1.5.w,
                              )),
                        ),
                        validator: (text) {},
                        onChanged: (text) => {},
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  BlueButton(
                    width: 250.w,
                    buttonText: 'Login',
                    buttonIsLoading: false,
                    onTap: () {
                      Navigator.pop(context);
                      showLoginModal(context);
                    },
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.pop(context);
                      showResetPasswordModal(context);
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: const Color(0xFF4075BB),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Mikado',
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
