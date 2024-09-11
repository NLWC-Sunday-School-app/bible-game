import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:the_bible_game/features/who_is_who/bloc/who_is_who_bloc.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';
import 'package:the_bible_game/shared/widgets/blue_button.dart';

import '../../../../shared/constants/app_routes.dart';
import '../../../../shared/features/settings/bloc/settings_bloc.dart';

void showWiwTryAgainModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return WiwTryAgainModal();
    },
  );
}

class WiwTryAgainModal extends StatefulWidget {
  const WiwTryAgainModal({Key? key}) : super(key: key);

  @override
  State<WiwTryAgainModal> createState() => _WiwTryAgainModalState();
}

class _WiwTryAgainModalState extends State<WiwTryAgainModal> {
  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 0.w),
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: Get.width >= 500
            ? 400.h
            : Get.height >= 800
                ? 450.h
                : 500.h,
        width: Get.width >= 500 ? 400.h : 500.h,
        child: BlocBuilder<WhoIsWhoBloc, WhoIsWhoState>(
          builder: (context, state) {
            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.tryAgainModalBg),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  InkWell(
                    onTap: () {
                      context.read<WhoIsWhoBloc>().add(ClearWhoIsWhoGameData());
                      soundManager.playClickSound();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.whoIsWhoHomeScreen,
                        ModalRoute.withName('/home'),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 40.w),
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
                    height: 20.h,
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 2.w, color: const Color(0xFFCC2C39)),
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.r))),
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        width: 180.w,
                        child: Column(
                          children: [
                            Text(
                              'You earned',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: const Color(0xFFCC2C39),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  IconImageRoutes.coinIcon,
                                  width: 30.w,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  state.coinsGained.toString(),
                                  style: TextStyle(
                                      fontFamily: 'Mikado',
                                      fontSize: 40.sp,
                                      fontWeight: FontWeight.w900,
                                      color: const Color(0xFFCC2C39)),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.w,
                      ),
                      SizedBox(
                        width: 100.w,
                        child: Row(
                          children: [
                            Image.asset(
                              IconImageRoutes.blueCircleMark,
                              width: 24.w,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Column(
                              children: [
                                Text(
                                  '${state.noOfCorrectAnswers}/20',
                                  style: TextStyle(
                                      fontSize: 18.sp,
                                      fontFamily: 'Mikado',
                                      color: const Color(0xFF0155AF),
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  'answers',
                                  style: TextStyle(
                                      fontFamily: 'Mikado',
                                      fontSize: 13.sp,
                                      color: const Color(0xFF0155AF)),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      BlueButton(
                        buttonText: 'Play Again',
                        buttonIsLoading: false,
                        width: 230.w,
                        onTap: (){
                          context.read<WhoIsWhoBloc>().add(ClearWhoIsWhoGameData());
                          soundManager.playClickSound();
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.whoIsWhoHomeScreen,
                            ModalRoute.withName('/home'),
                          );
                        },
                      )
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // wiwGameQuestionController.sendGameData();
  }
}
