import 'package:another_flushbar/flushbar.dart';
import 'package:bible_game/shared/widgets/modal/delete_account_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/features/home/widget/modals/log_out_modal.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:bible_game/shared/utils/formatter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/constants/colors.dart';
import '../../../shared/constants/image_routes.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../shared/utils/avatar_credentials.dart';
import '../../../shared/utils/user_badge.dart';
import '../../../shared/widgets/custom_toast.dart';
import '../../../shared/widgets/multi_avatar.dart';
import '../../../shared/widgets/screen_app_bar.dart';
import '../widget/modals/bg_streak_modal.dart';
import '../widget/modals/create_profile_modal.dart';
import '../widget/modals/edit_profile.dart';
import '../widget/modals/login_modal.dart';
import '../widget/modals/reset_password_modal.dart';
import '../widget/score_info.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: AppColors.primaryColorShade, // Status bar color
      ),
      backgroundColor: Color(0xFF2D6BB6),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                // decoration: const BoxDecoration(
                //   image: DecorationImage(
                //     image: AssetImage(ProductImageRoutes.patternTwoBg),
                //     fit: BoxFit.cover,
                //   ),
                // ),
                child: Column(
                  children: [
                    ScreenAppBar(
                      height: 85.h,
                      widgets: [
                        Row(
                          children: [
                            Spacer(),
                            SizedBox(
                              width: 50.w,
                            ),
                            Center(
                              child: StrokeText(
                                text: 'Profile',
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                                strokeColor: AppColors.titleDropShadowColor,
                                strokeWidth: 6,
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                                onTap: () {
                                  soundManager.playClickSound();
                                  Navigator.pop(context);
                                },
                                child: Image.asset(
                                  IconImageRoutes.redCircleClose,
                                  width: 50.w,
                                ))
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    state.user.id != 0
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF364865),
                                    offset: Offset(0, 5),
                                    blurRadius: 0,
                                    spreadRadius: -2,
                                  ),
                                ],
                                gradient: LinearGradient(
                                  begin: Alignment(-1.495, 0),
                                  // This is to match the -49.47% in CSS
                                  end: Alignment(1.2643, 0),
                                  // This is to match the 126.43% in CSS
                                  colors: [
                                    Color(0xFF92C1F8),
                                    Color(0xFF99C7FF),
                                  ],
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
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

                                    // SvgPicture.network(
                                    //   '${AvatarCredentials.BaseURL}/${state.user.id}.svg?apikey=${AvatarCredentials.APIKey}/',
                                    //   width: 70.w,
                                    //   semanticsLabel: 'Logo',
                                    //   placeholderBuilder:
                                    //       (BuildContext context) => Image.asset(
                                    //     ProductImageRoutes.defaultAvatar,
                                    //     width: 70.w,
                                    //   ),
                                    // ),
                                    AvatarWidget(seed: state.user.id.toString(), width: 70.w, height: 70.h,)
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          StrokeText(
                                            text: state.user.name,
                                            textStyle: TextStyle(
                                              color: Color(0xFF2A62A9),
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.w900,
                                            ),
                                            strokeColor: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                          SizedBox(
                                            width: 40.w,
                                          ),
                                          ScoreInfo(
                                            width: 70.w,
                                            backgroundColor:
                                                AppColors.streakBackground,
                                            borderColor: AppColors.streakBorder,
                                            shadowColor: AppColors.streakShade,
                                            score: state.user.streak.toString(),
                                            iconImage:
                                                IconImageRoutes.streakIcon,
                                            iconWidth: 14.w,
                                            textColor: AppColors.streakText,
                                            onTap: () =>
                                                showStreakModal(context),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/flags/${state.user.country.replaceAll('/', ' ').toLowerCase()}.svg',
                                            width: 21.w,
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          StrokeText(
                                            text: state.user.country,
                                            textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w900,
                                            ),
                                            strokeColor: Color(0xFF0662BA),
                                            strokeWidth: 2,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            getBadgeUrl(state.user.rank),
                                            width: 18.sp,
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          StrokeText(
                                            text:
                                                capitalizeText(state.user.rank),
                                            textStyle: TextStyle(
                                              color: Color(0xFF5047C4),
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w900,
                                            ),
                                            strokeColor: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 30.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        soundManager.playClickSound();
                        state.user.id != 0
                            ? showEditProfileModal(context)
                            : showLoginModal(context);
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
                            child: StrokeText(
                              text: state.user.id != 0
                                  ? 'Edit your profile'
                                  : 'Log In',
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
                    SizedBox(
                      height: 15.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        soundManager.playClickSound();
                        state.user.id != 0
                            ? showResetPasswordModal(context)
                            : showCreateProfileModal(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage(ProductImageRoutes.newBlueBtnBg),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Center(
                            child: StrokeText(
                              text: state.user.id != 0
                                  ? 'Change your password'
                                  : 'Create Profile',
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
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Color(0xFF6185BC), // Line color
                            thickness: 1.0, // Line thickness
                            indent: 10.w, // Spacing before the line
                            endIndent: 30.w, // Spacing after the line
                          ),
                        ),
                        StrokeText(
                          text: 'GAME SETTINGS',
                          textStyle: TextStyle(
                            color: Color(0xFFFFFAD3),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          strokeColor: const Color(0xFF272D39),
                          strokeWidth: 3,
                        ),
                        Expanded(
                          child: Divider(
                            color: Color(0xFF6185BC), // Line color
                            thickness: 1.0, // Line thickness
                            indent: 30.w, // Spacing before the line
                            endIndent: 10.w, // Spacing after the line
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    BlocBuilder<SettingsBloc, SettingsState>(
                      builder: (context, state) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Row(
                            mainAxisAlignment: context
                                        .read<AuthenticationBloc>()
                                        .state
                                        .user
                                        .id !=
                                    0
                                ? MainAxisAlignment.spaceBetween
                                : MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: GestureDetector(
                                        onTap: () {
                                          soundManager.playClickSound();
                                          context
                                              .read<SettingsBloc>()
                                              .add(ToggleMusic());
                                        },
                                        child: Image.asset(
                                          state.isMusicOn
                                              ? IconImageRoutes.musicOn
                                              : IconImageRoutes.musicOff,
                                          width: 64.w,
                                        )),
                                  ),
                                  Text(
                                    'Music',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.w),
                                    child: GestureDetector(
                                      onTap: () {
                                        soundManager.playClickSound();
                                        context
                                            .read<SettingsBloc>()
                                            .add(ToggleSound());
                                      },
                                      child: Image.asset(
                                        state.isSoundOn
                                            ? IconImageRoutes.soundOn
                                            : IconImageRoutes.soundOff,
                                        width: 64.w,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Sound',
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  )
                                ],
                              ),
                              context
                                          .read<AuthenticationBloc>()
                                          .state
                                          .user
                                          .id !=
                                      0
                                  ? Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.w),
                                          child: GestureDetector(
                                              onTap: () {
                                                soundManager.playClickSound();
                                                showLogoutModal(context);
                                              },
                                              child: Image.asset(
                                                IconImageRoutes.logOut,
                                                width: 64.w,
                                              )),
                                        ),
                                        Text(
                                          'Log out',
                                          style: TextStyle(
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white),
                                        )
                                      ],
                                    )
                                  : SizedBox(),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    state.user.id != 0 && state.user.role.toLowerCase() != 'collaborator'
                        ? BlocConsumer<UserBloc, UserState>(
                            listener: (context, state) {
                              if (state.hasSentCollaboratorMail) {
                                showCustomToast(context,
                                    'Thank you, a mail has \nbeen sent to you!');
                              }
                            },
                            builder: (context, state) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: GestureDetector(
                                  onTap: () {
                                    context
                                        .read<UserBloc>()
                                        .add(OnboardCollaborator());
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 15.h),
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            ProductImageRoutes.newBlueBtnBgTwo),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    child: Center(
                                      child: BlocProvider.of<UserBloc>(context)
                                              .state
                                              .isOnboardingCollaborator
                                          ? SizedBox(
                                              height: 13.h,
                                              width: 13.w,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 3,
                                              ))
                                          : StrokeText(
                                              text:
                                                'Be a Luke! Set Bible game questions.',
                                              textStyle: TextStyle(
                                                color: Color(0xFFFFFAD3),
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              strokeColor:
                                                  const Color(0xFF272D39),
                                              strokeWidth: 3,
                                            ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 10.h,
                    ),
                    GestureDetector(
                      onTap: () {
                        showDeleteAccountModal(context);
                      },
                      child: const Text(
                        'Delete Account',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Mikado',
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Color(0xFF6185BC), // Line color
                            thickness: 1.0, // Line thickness
                            indent: 10.w, // Spacing before the line
                            endIndent: 30.w, // Spacing after the line
                          ),
                        ),
                        StrokeText(
                          text: 'FOLLOW US ON',
                          textStyle: TextStyle(
                            color: Color(0xFFFFFAD3),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          strokeColor: const Color(0xFF272D39),
                          strokeWidth: 3,
                        ),
                        Expanded(
                          child: Divider(
                            color: Color(0xFF6185BC), // Line color
                            thickness: 1.0, // Line thickness
                            indent: 30.w, // Spacing before the line
                            endIndent: 10.w, // Spacing after the line
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Image.asset(
                            IconImageRoutes.instagram,
                            width: 26.w,
                          ),
                          onPressed: () {
                            _launchURL(
                                'https://www.instagram.com/ourbiblegame');
                          },
                        ),
                        SizedBox(
                          width: 50.w,
                        ),
                        IconButton(
                          icon: Image.asset(
                            IconImageRoutes.facebook,
                            width: 26.w,
                          ),
                          onPressed: () {
                            _launchURL(
                                'https://www.facebook.com/profile.php?id=61561426356965');
                          },
                        ),
                        SizedBox(
                          width: 50.w,
                        ),
                        IconButton(
                          icon: Image.asset(
                            IconImageRoutes.xIcon,
                            width: 26.w,
                          ),
                          onPressed: () {
                            _launchURL('https://x.com/OurBibleGame');
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
