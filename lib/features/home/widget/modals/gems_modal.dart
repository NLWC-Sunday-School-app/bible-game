import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/features/settings/bloc/settings_bloc.dart';

void showGemsModal(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: const Color.fromRGBO(40, 40, 40, 0.95),
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
        backgroundColor: Colors.transparent,
        insetAnimationCurve: Curves.easeIn,
        insetAnimationDuration: const Duration(milliseconds: 500),
        child: GemsModal(),
      );
    },
  );
}

class GemsModal extends StatelessWidget {
  const GemsModal({super.key});

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    var formatter = NumberFormat('#,###,###');
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return SizedBox(
          height: 380.h,
          width: 350.w,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ProductImageRoutes.gemsModalBg),
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
                      text: 'Gems',
                      textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700),
                      strokeColor: const Color(0xFF855113),
                      strokeWidth: 3,
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        soundManager.playClickSound();
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        IconImageRoutes.blueCircleCancel,
                        width: 34.w,
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                  ],
                ),
                SizedBox(
                  height: 60.h,
                ),
                Image.asset(
                  IconImageRoutes.gemIcon,
                  width: 90.w,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  'You have a total of',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  formatter.format(state.user!.gems),
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 44.sp,
                      color: Colors.white),
                ),
                Text(
                  'Buy a gem with ${context.read<SettingsBloc>().state.gamePlaySettings['gem_price']} coins',
                  style: TextStyle(fontSize: 14.sp, color: Colors.white),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
