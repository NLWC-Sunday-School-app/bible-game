import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/features/who_is_who/bloc/who_is_who_bloc.dart';
import 'package:bible_game/features/who_is_who/widget/modal/wiw_try_again_modal.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/widgets/blue_button.dart';

import '../../../../shared/features/settings/bloc/settings_bloc.dart';

void showWhoIsWhoTimeUpModal(BuildContext context, {
  int? gameTimePurchasePrice,
  required VoidCallback onTap
}) {
  showDialog(
      barrierColor: const Color.fromRGBO(40, 40, 40, 0.9),
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          insetAnimationCurve: Curves.bounceInOut,
          insetAnimationDuration: const Duration(milliseconds: 500),
          child: WiwTimeUpModal(
            gameTimePurchasePrice: gameTimePurchasePrice.toString(),
            onTap: onTap,
          ),
        );
      });
}

class WiwTimeUpModal extends StatelessWidget {
  const WiwTimeUpModal({Key? key, required this.gameTimePurchasePrice, required this.onTap}) : super(key: key);

  final String gameTimePurchasePrice;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final soundManager = context.read<SettingsBloc>().soundManager;
    return SizedBox(
      height: screenWidth >= 500
          ? 400.h
          : screenHeight >= 800
          ? 450.h
          : 500.h,
      width: screenWidth >= 500 ? 400.h : 500.h,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ProductImageRoutes.timeUpBg),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 30.h,
            ),
            Column(
              children: [
                InkWell(
                  onTap: () {
                      soundManager.playClickSound();
                      Navigator.pop(context);
                      showWiwTryAgainModal(context);
                      BlocProvider.of<WhoIsWhoBloc>(context).add(SubmitWhoIsWhoScore());
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 50.w),
                    child: Align(
                      child: Image.asset(
                        IconImageRoutes.redCircleClose,
                        width: 50.w,
                      ),
                      alignment: Alignment.topRight,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  'Don’t lose your coins',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Mikado',
                      color: const Color(0xFFE81A31),
                      fontSize: 18.sp),
                ),
                SizedBox(
                  height: 15.h,
                ),
                Container(
                  width: 200.w,
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ProductImageRoutes.patternTwoBg),
                        fit: BoxFit.cover,
                      ),
                      color: const Color(0xFFD4E9F6).withOpacity(0.5),
                      border: Border.all(
                          width: 2.w, color: const Color(0xFF106CDC)),
                      borderRadius: BorderRadius.all(Radius.circular(8.r))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            IconImageRoutes.timer,
                            width: 30.w,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            ':60',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: const Color(0xFF0A5CAF),
                                fontFamily: 'Mikado',
                                fontWeight: FontWeight.w900,
                                fontSize: 34.sp),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Buy 60s to finish level',
                        style: TextStyle(
                            color: const Color(0xFF306DB6),
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Mikado',
                            fontSize: 16.sp),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
                BlueButton(
                  buttonText: 'Keep Playing',
                  onTap: onTap,
                  buttonIsLoading: false,
                  width: 240.w,
                  hasCustomWidget: true,
                  customWidget: Row(
                    children: [
                      Text(
                        'Keep Playing',
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                      const Spacer(),
                      Image.asset(
                        IconImageRoutes.coinIcon,
                        width: 18.w,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        gameTimePurchasePrice,
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
