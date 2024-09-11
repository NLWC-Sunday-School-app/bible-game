import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:the_bible_game/shared/features/authentication/bloc/authentication_bloc.dart';

import '../../../../shared/constants/app_routes.dart';
import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/utils/avatar_credentials.dart';

void showLogoutModal(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color.fromRGBO(40, 40, 40, 0.95),
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          backgroundColor: Colors.transparent,
          insetAnimationCurve: Curves.easeIn,
          insetAnimationDuration: const Duration(milliseconds: 500),
          child: LogoutModal(),
        );
      });
}

class LogoutModal extends StatelessWidget {
  const LogoutModal({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.hasLoggedOut) {
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(context,
              AppRoutes.home, (Route<dynamic> route) => false);
          final prefs = SharedPreferences.getInstance();
          prefs.then((sharedPreferences) {
            sharedPreferences.remove('userToken');
            sharedPreferences.remove('refreshToken');
          });
        }
      },
      builder: (context, state) {
        return

          SizedBox(
          height: 400.h,
          width: 350.h,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ProductImageRoutes.streakModalBg),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 40.w,
                    ),
                    Spacer(),
                    StrokeText(
                      text: 'Log out',
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700),
                      strokeColor: const Color(0xFF272D39),
                      strokeWidth: 3,
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        IconImageRoutes.blueCircleCancel,
                        width: 35.w,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 4.w,
                      color: const Color(0xFF4A91FF),
                    ),
                  ),
                  child:
                  SvgPicture.network(
                    '${AvatarCredentials.BaseURL}/${state.user.id}.svg?apikey=${AvatarCredentials.APIKey}/',
                    width: 70.w,
                    semanticsLabel: 'avatar',
                    placeholderBuilder: (BuildContext context) => Image.asset(ProductImageRoutes.defaultAvatar, width: 50.w,),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Are you sure you want \nto log out ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                GestureDetector(
                  onTap: () {
                    context
                        .read<AuthenticationBloc>()
                        .add(AuthenticationLogoutRequested());
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              ProductImageRoutes.streakRestoreButtonBg),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Center(
                        child: state.isLoggingOut
                            ? SizedBox(
                              height: 20.h,
                              width: 20.w,
                              child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                            )
                            : StrokeText(
                                text: 'Yes, log me out',
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                                strokeColor: const Color(0xFF272D39),
                                strokeWidth: 3,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
