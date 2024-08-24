import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:screenshot/screenshot.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:the_bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:the_bible_game/shared/features/user/bloc/user_bloc.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/constants/image_routes.dart';
import '../../../shared/widgets/green_button.dart';
import '../../../shared/widgets/screen_app_bar.dart';
import '../../home/widget/modals/create_profile_modal.dart';
import '../../home/widget/modals/login_modal.dart';
import '../../home/widget/score_info.dart';
import 'package:intl/intl.dart';

class StoreHomeScreen extends StatefulWidget {
  const StoreHomeScreen({super.key});

  @override
  State<StoreHomeScreen> createState() => _StoreHomeScreenState();
}

class _StoreHomeScreenState extends State<StoreHomeScreen> {


  void showCustomToast(BuildContext context) {
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
      backgroundColor: const Color(0xFF3887E1),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ProductImageRoutes.patternTwoBg),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                ScreenAppBar(
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
                context
                    .read<AuthenticationBloc>()
                    .state
                    .user
                    .id !=
                    0
                    ?

                Column(
                  children: [
                    SizedBox(
                      height: 40.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                    SizedBox(
                      height: 40.h,
                    ),
                    Stack(
                      children: [
                        Image.asset(
                          ProductImageRoutes.storeGemCard,
                          width: 168.w,
                          height: 184.h,
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
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
                                      context.read<AuthenticationBloc>().add(FetchUserDataRequested());
                                    }else{
                                      showCustomToast(context);
                                    }
                                  },
                                  child: Container(
                                    width: 148.w,
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
                      children: [
                        Expanded(
                            child: Divider(
                              color: Color(0xFF10498D),
                              thickness: 2,
                              endIndent: 20,
                            )),
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
                        Expanded(
                            child: Divider(
                              color: Color(0xFF10498D),
                              thickness: 2,
                              indent: 20,
                            )),
                      ],
                    )
                  ],
                ) :
                Column(

                  children: [
                    SizedBox(
                      height: 100.h,
                    ),
                    GreenButton(
                      onTap: () {
                        soundManager.playClickSound();
                        showLoginModal(context);
                      },
                      buttonIsLoading: false,
                      width: 350.w,
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
                        width: 350.w,
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


              ],
            ),
          );
        },
      ),
    );
  }
}
