import 'package:another_flushbar/flushbar.dart';
import 'package:bible_game/shared/widgets/custom_toast.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:get/get.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:bible_game/shared/widgets/blue_button.dart';

import '../../constants/image_routes.dart';

void showCountryUpdateModal(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CountryUpdateModal();
      });
}

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
                    image: AssetImage(ProductImageRoutes.modalBg),
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
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 20.0.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Image.asset(
                              IconImageRoutes.blueCircleCancel,
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
                              onSelect: (Country country) {
                                setState(() => {
                                      textEditingController.text =
                                          country.flagEmoji + country.name,
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
                          onChanged: (text) => {},
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height <= 670 ? 15.h : 20.h,
                    ),
                    SizedBox(
                      height: 18.h,
                    ),
                    BlocConsumer<UserBloc, UserState>(
                      listener: (context, state) {
                        if (state.hasUpdatedCountry) {
                          Navigator.pop(context);
                          showCustomToast(context, 'Updated successfully');

                          context
                              .read<AuthenticationBloc>()
                              .add(FetchUserDataRequested());
                        }
                      },
                      builder: (context, state) {
                        return BlueButton(
                          onTap: () {
                            if (selectedCountry.isNotEmpty) {
                              context
                                  .read<UserBloc>()
                                  .add(UpdateCountry(selectedCountry));
                            }
                          },
                          isActive: !selectedCountry.isEmpty,
                          buttonText: 'Update profile',
                          buttonIsLoading: state.isUpdatingCountry,
                          width: 200.w,
                        );
                      },
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
