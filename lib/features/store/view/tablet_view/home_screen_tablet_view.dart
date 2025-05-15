import 'package:bible_game/shared/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:screenshot/screenshot.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/features/store/widget/modal/successfully_bought_gem_modal.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/widgets/green_button.dart';
import '../../../../shared/widgets/screen_app_bar.dart';
import '../../../home/widget/modals/create_profile_modal.dart';
import '../../../home/widget/modals/login_modal.dart';

class StoreHomeScreenTabletView extends StatefulWidget {
  const StoreHomeScreenTabletView({super.key});

  @override
  State<StoreHomeScreenTabletView> createState() => _StoreHomeScreenTabletViewState();
}

class _StoreHomeScreenTabletViewState extends State<StoreHomeScreenTabletView> {


  void showCustomToast(BuildContext context,) {
    FToast fToast = FToast();
    fToast.init(context);
    LinearGradient linearGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color.fromRGBO(34, 34, 34, 0.0),
        Color.fromRGBO(34, 34, 34, 0.2333),
        Color.fromRGBO(34, 34, 34, 0.141846),
        Color.fromRGBO(136, 136, 136, 0.0),
      ],
      stops: [
        0.0,
        0.375,
        0.62,
        1.0,
      ],
    );
    Widget toast = Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: linearGradient,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StrokeText(
            text: 'You don’t  have enough coins \nto get this! Play more games',
            textStyle: TextStyle(
              color: Color(0xFFFFD400),
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
            ),
            strokeColor: Color(0xFF000000),
            strokeWidth: 6,
          ),
        ],
      )
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('#,###,###');
    final soundManager = context.read<SettingsBloc>().soundManager;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
          backgroundColor: AppColors.primaryColorShade,
      ),
      backgroundColor: const Color(0xFF3887E1),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return SafeArea(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.patternTwoBg),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  ScreenAppBar(
                    height: 70.h,
                    widgets: [
                      Center(
                        child: StrokeText(
                          text: 'Store',
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w900,
                          ),
                          strokeColor: AppColors.titleDropShadowColor,
                          strokeWidth: 6,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  context
                      .read<AuthenticationBloc>()
                      .state
                      .user
                      .id !=
                      0
                      ?
            
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 60.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 160.w,
                                padding:
                                EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.h),
                                decoration: BoxDecoration(
                                    color: Color(0xFF7FB800),
                                    border: Border.all(
                                      width: 1.w,
                                      color: AppColors.streakBorder,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(26.r)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        offset: Offset(0, 5),
                                        blurRadius: 0,
                                        spreadRadius: -2,
                                      ),
                                    ]),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      IconImageRoutes.coinIcon,
                                      width: 22.w,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      formatter.format(state.user.coinWalletBalance),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Container(
                                width: 160.w,
                                padding:
                                EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.h),
                                decoration: BoxDecoration(
                                    color: Color(0xFFD1B1C8),
                                    border: Border.all(
                                      width: 1.w,
                                      color: AppColors.streakBorder,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(26.r)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFF9B400E).withOpacity(0.25),
                                        offset: Offset(0, 5),
                                        blurRadius: 0,
                                        spreadRadius: -2,
                                      ),
                                    ]),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      IconImageRoutes.gemIcon,
                                      width: 22.w,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      state.user.gems.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 40.h,
                            ),
                            Stack(
                              children: [
                                Container(
                                  width: 286.h,
                                  child: Image.asset(
                                    ProductImageRoutes.storeGemCard,
                                  ),
                                ),
                                Positioned(
                                  left: 10,
                                  right: 10,
                                  bottom: 10.h,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                                    child: BlocBuilder<UserBloc, UserState>(
                                      builder: (context, state) {
                                        final coinBalance = context.read<AuthenticationBloc>().state.user.coinWalletBalance;
                                        final gemPrice =  context
                                            .read<SettingsBloc>()
                                            .state
                                            .gamePlaySettings['gem_price'];
                                        return GestureDetector(
                                          onTap: (){
                                            if(coinBalance >= int.parse(gemPrice)){
                                              context.read<UserBloc>().add(PurchaseGem());
                                              Future.delayed(Duration(seconds: 2), (){
                                                context.read<AuthenticationBloc>().add(FetchUserDataRequested());
                                              });
                                              Future.delayed(Duration(seconds: 1), (){
                                                showSuccessfullyBoughtGemModal(context);
                                              });
                                              Future.delayed(Duration(seconds: 3), (){
                                                Navigator.pop(context);
                                              });
                                            }else{
                                              showCustomToast(context);
                                            }
                                          },
                                          child:
                    
                                          Container(
                                            width: 128.w,
                                            height: 36.h,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      ProductImageRoutes.blueButtonBg),
                                                  fit: BoxFit.cover,
                                                ),
                                                border: Border.all(color: Color(0xFFA6CAF6)),
                                                borderRadius: BorderRadius.circular(22.r)),
                                            child: state.isPurchasingGem
                                                ? Center(
                                                child: SizedBox(
                                                    height: 12.w,
                                                    width: 12.w,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.white,
                                                    )))
                                                : Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Buy',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w900),
                                                ),
                                                SizedBox(
                                                  width: 15.w,
                                                ),
                                                Image.asset(
                                                  IconImageRoutes.coinIcon,
                                                  width: 18.w,
                                                ),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                Text(
                                                  context
                                                      .read<SettingsBloc>()
                                                      .state
                                                      .gamePlaySettings['gem_price'],
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.sp,
                                                      fontWeight: FontWeight.w900),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 50.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 100.w,
                                  child: Divider(
                                    color: Color(0xFF10498D),
                                    thickness: 2,
                                    endIndent: 20,
                                  ),
                                ),
                                StrokeText(
                                  text: 'MORE ITEMS COMING',
                                  textStyle: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  strokeColor: Colors.black.withOpacity(0.25),
                                  strokeWidth: 1,
                                ),
                                SizedBox(
                                  width: 100.w,
                                  child: Divider(
                                    color: Color(0xFF10498D),
                                    thickness: 2,
                                    indent: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container()
                      ],
                    ),
                  ) :
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GreenButton(
                          onTap: () {
                            soundManager.playClickSound();
                            showLoginModal(context);
                          },
                          buttonIsLoading: false,
                          width: 638.w,
                          customWidget: Center(
                            child: StrokeText(
                              text: 'Log In',
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
                        SizedBox(height: 30.h,),
                        GestureDetector(
                          onTap: () {
                            soundManager.playClickSound();
                            showCreateProfileModal(context);
                          },
                          child: Container(
                            width: 638.w,
                            padding:
                            EdgeInsets.symmetric(vertical: 15.h),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      ProductImageRoutes.newBlueBtnBg),
                                  fit: BoxFit.fill,
                                )),
                            child: Center(
                              child: StrokeText(
                                text: 'Create Profile',
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
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
