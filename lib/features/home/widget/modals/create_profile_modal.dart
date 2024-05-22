import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import '../../../../shared/constants/image_routes.dart';
import 'package:country_picker/country_picker.dart';

import '../../../../shared/widgets/blue_button.dart';

void showCreateProfileModal(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
          backgroundColor: Colors.transparent,
          insetAnimationCurve: Curves.easeIn,
          insetAnimationDuration: const Duration(milliseconds: 500),
          child: SingleChildScrollView(
            child: SizedBox(
              height: 650.h,
              width: 650.w,
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
                      text: 'Create Profile',
                      textStyle: TextStyle(
                        color: const Color(0xFF1768B9),
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
                            height: 1.3.sp,
                            color: const Color(0xFF104387),
                            fontSize: 13.sp,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp("[A-Za-z0-9#-]*"),
                            ),
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
                                color: Color(0xFFB3C1C6),
                                width: 1.5,
                              ),
                            ),
                          ),
                          validator: (text) {},
                          onChanged: (text) => {},
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
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
                          validator: (text) {},
                          onChanged: (text) => {},
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 45.0.w),
                      child: SizedBox(
                        child: TextFormField(
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              showPhoneCode: false,
                              onSelect: (Country country) {},
                            );
                          },
                          style: TextStyle(
                            height: 1.5.h,
                            color: const Color(0xFF104387),
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
                          validator: (text) {},
                          onChanged: (text) => {},
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 45.0.w),
                      child: SizedBox(
                        child: TextFormField(
                          obscureText: true,
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
                              onTap: () => {},
                              child: Image.asset(
                                IconImageRoutes.eyeClose,
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
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.r),
                                borderSide: const BorderSide(
                                    color: Color(0xFFD4DDDF), width: 1.5)),
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
                      buttonText: 'Create Profile',
                      buttonIsLoading: false,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
}
