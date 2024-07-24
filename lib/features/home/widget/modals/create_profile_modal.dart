import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:the_bible_game/features/home/widget/modals/successful_registration_modal.dart';
import 'package:the_bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../../shared/constants/image_routes.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/utils/token_notifier.dart';
import '../../../../shared/utils/validation.dart';
import '../../../../shared/widgets/blue_button.dart';
import 'package:provider/provider.dart';
import 'package:bible_game_api/utils/api_exception.dart';

void showCreateProfileModal(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
            backgroundColor: Colors.transparent,
            insetAnimationCurve: Curves.easeIn,
            insetAnimationDuration: const Duration(milliseconds: 500),
            child: CreateProfileModal());
      });
}

class CreateProfileModal extends StatefulWidget {
  const CreateProfileModal({super.key});

  @override
  State<CreateProfileModal> createState() => _CreateProfileModalState();
}

class _CreateProfileModalState extends State<CreateProfileModal> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  String countryName = '';
  bool _hasToggledPasswordVisibility = true;

  void togglePasswordVisibility() {
    setState(() {
      _hasToggledPasswordVisibility = !_hasToggledPasswordVisibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 690.h,
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
                height: 40.h,
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
              Form(
                key: _registerFormKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 45.0.w),
                      child: SizedBox(
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: userNameController,
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
                          validator: (text) {
                            return Validator.validateName(text!);
                          },
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
                          controller: emailController,
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
                            return Validator.validateEmail(text!);
                          },
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
                          controller: countryController,
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              showPhoneCode: false,
                              onSelect: (Country country) {
                                setState(() => countryController.text =
                                    country.flagEmoji + " " + country.name);
                                countryName = country.name;
                              },
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
                          validator: (text) {
                            return Validator.validateCountry(text!);
                          },
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
                          obscureText: _hasToggledPasswordVisibility,
                          controller: passwordController,
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
                              onTap: () => togglePasswordVisibility(),
                              child: Image.asset(
                                _hasToggledPasswordVisibility
                                    ? IconImageRoutes.eyeClose
                                    : IconImageRoutes.eyeOpen,
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
                          validator: (text) {
                            return Validator.validatePassword(text!);
                          },
                          onChanged: (text) => {},
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    BlocConsumer<AuthenticationBloc, AuthenticationState>(
                      listener: (context, state) {
                        if (state.user != null) {
                          Navigator.pop(context);
                          showSuccessfulRegistrationModal(context);
                          final tokenNotifier = Provider.of<TokenNotifier>(
                              context,
                              listen: false);
                          tokenNotifier.setToken(state.token);

                          //save refresh token
                          final prefs = SharedPreferences.getInstance();
                          prefs.then((sharedPreferences) {
                            sharedPreferences.setString(
                                'refreshToken', state.refreshToken!);
                          });
                        } else if (state.isUnauthenticated) {
                          ApiException.showSnackBar(context);
                        }
                      },
                      builder: (context, state) {
                        return BlueButton(
                          width: 250.w,
                          buttonText: 'Create Profile',
                          buttonIsLoading: state.isLoadingLogin,
                          onTap: () {
                            if (_registerFormKey.currentState!.validate()) {
                              context
                                  .read<AuthenticationBloc>()
                                  .add(AuthenticationRegisterRequested(
                                    userNameController.text,
                                    emailController.text,
                                    passwordController.text,
                                    '123djsjkdjksjljkljdljskj',
                                    countryName,
                                  ));
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
