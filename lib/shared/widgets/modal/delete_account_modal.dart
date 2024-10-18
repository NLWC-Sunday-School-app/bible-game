import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

import '../../constants/app_routes.dart';
import '../../features/settings/bloc/settings_bloc.dart';

void showDeleteAccountModal(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteAccountModal();
      });
}

class DeleteAccountModal extends StatelessWidget {
  const DeleteAccountModal({super.key});

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.hasLoggedOut) {
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.home, (Route<dynamic> route) => false);
          GetStorage().remove('user_token');
          GetStorage().remove('refresh_token');
        }
      },
      builder: (context, state) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          backgroundColor: Colors.transparent,
          child: SizedBox(
            height: 550.h,
            width: 500.w,
            child: Container(
              decoration: const BoxDecoration(
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
                    onTap: () {
                      soundManager.playClickSound();
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 15.0.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            IconImageRoutes.closeModal,
                            width: 40.w,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Are you sure you \nwant to delete\n your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24.sp,
                        color: const Color(0xFF4075BB)),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(
                    "You will lose all your data \nand won't be able to get it back.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        height: 1.5),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      soundManager.playClickSound();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 200.w,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          color: const Color(0xFFE8F8FF),
                          border: Border.all(color: const Color(0xFF548CD7)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(40))),
                      child: Text(
                        "NO I DONT",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Neuland',
                            letterSpacing: 1,
                            color: const Color(0xFF323B63),
                            fontSize: 14.sp),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      soundManager.playClickSound();
                      context.read<AuthenticationBloc>().add(DeleteAccount());
                    },
                    child:

                    Container(
                      width: 200.w,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          color: const Color(0xFF548CD7),
                          border: Border.all(color: const Color(0xFF548CD7)),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(40))),
                      child:
                      state.isDeletingAccount ?  const Center(
                        child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFFFFFFFF),
                            )),
                      ): Text(
                        'yes, delete',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Neuland',
                            letterSpacing: 1,
                            color: Colors.white,
                            fontSize: 14.sp),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
    ;
  }
}
