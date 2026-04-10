import 'package:bible_game/shared/features/localization/app_localization.dart';
import 'package:bible_game_api/utils/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';
import 'package:get/get.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/utils/validation.dart';
import '../../../../shared/widgets/blue_button.dart';

void showEditProfileModal(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditProfileModal();
      });
}

class EditProfileModal extends StatefulWidget {
  const EditProfileModal({Key? key}) : super(key: key);

  @override
  State<EditProfileModal> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfileModal> {
  final GlobalKey<FormState> _updateFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  bool isToggle = true;
  GetStorage box = GetStorage();

  @override
  void initState() {
    super.initState();
    nameController.text =
        BlocProvider.of<AuthenticationBloc>(context).state.user.name;
  }

  void toggle() {
    setState(() {
      isToggle = !isToggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalization.tr(context);
    final screenWidth =  MediaQuery.of(context).size.width;
    final screenHeight =  MediaQuery.of(context).size.height;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: SizedBox(
          height: screenWidth >= 500
              ? 500.h
              : screenHeight >= 800
                  ? 450.h
                  : 500.h,
          width: screenWidth >= 500 ? 600.w : 500.w,
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
                    onTap: () => {Navigator.pop(context)},
                    child: Padding(
                      padding: EdgeInsets.only(right: 15.0.w),
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
                    text: tr.t('auth_edit_profile'),
                    textStyle: TextStyle(
                      color: const Color(0xFF1768B9),
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w900,
                    ),
                    strokeColor: Colors.white,
                    strokeWidth: 5,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    tr.t('auth_edit_profile_subtitle'),
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
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            height: 1.5.sp,
                            color: const Color(0xFF104387),
                            fontSize: 14.sp,
                            fontFamily: 'Mikado'),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFD4DDDF),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: tr.t('auth_nickname_hint'),
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
                        onChanged: (text) => {},
                      ),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight <= 670.h ? 15.h : 20.h,
                  ),
                  BlocConsumer<UserBloc, UserState>(
                    listener: (context, state) {
                       if(state.updatedProfile){
                         Navigator.pop(context);
                         BlocProvider.of<AuthenticationBloc>(context).add(FetchUserDataRequested());
                       }
                       if(state.failedToUpdate == true){
                         ApiException.showSnackBar(context);
                       }
                    },
                    builder: (context, state) {
                      return BlueButton(
                        width: 250.w,
                        buttonText: tr.t('auth_update_profile'),
                        buttonIsLoading: state.isUpdatingProfile,
                        onTap: () {
                          if (_updateFormKey.currentState!.validate()){
                            context.read<UserBloc>().add(
                                UpdateUserProfile(nameController.text)
                            );
                          }

                        },
                      );
                    },
                  ),
                  SizedBox(
                    height: screenHeight <= 670.h ? 15.h : 20.h,
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
