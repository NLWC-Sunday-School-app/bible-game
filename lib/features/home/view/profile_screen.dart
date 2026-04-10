import 'package:another_flushbar/flushbar.dart';
import 'package:bible_game/shared/widgets/modal/delete_account_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/features/home/widget/modals/log_out_modal.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:bible_game/shared/utils/formatter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bible_game/shared/features/localization/app_localization.dart';
import 'package:bible_game/app.dart';

import '../../../shared/constants/colors.dart';
import '../../../shared/constants/image_routes.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
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
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    final tr = AppLocalization.tr(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: AppColors.primaryColorShade,
      ),
      backgroundColor: const Color(0xFF2D6BB6),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ScreenAppBar(
                    height: 85.h,
                    widgets: [
                      Row(
                        children: [
                          const Spacer(),
                          SizedBox(width: 50.w),
                          Center(
                            child: StrokeText(
                              text: tr.t('profile_title'),
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 26.sp,
                                fontWeight: FontWeight.w900,
                              ),
                              strokeColor: AppColors.titleDropShadowColor,
                              strokeWidth: 6,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              soundManager.playClickSound();
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              IconImageRoutes.redCircleClose,
                              width: 50.w,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  if (state.user.id != 0)
                    _ProfileCard(state: state),
                  SizedBox(height: 30.h),
                  _ProfileActionButton(
                    backgroundImage: ProductImageRoutes.streakRestoreButtonBg,
                    label: state.user.id != 0 ? tr.t('profile_edit') : tr.t('profile_log_in'),
                    onTap: () {
                      soundManager.playClickSound();
                      state.user.id != 0
                          ? showEditProfileModal(context)
                          : showLoginModal(context);
                    },
                  ),
                  SizedBox(height: 15.h),
                  _ProfileActionButton(
                    backgroundImage: ProductImageRoutes.newBlueBtnBg,
                    label: state.user.id != 0
                        ? tr.t('profile_change_password')
                        : tr.t('auth_create_profile'),
                    onTap: () {
                      soundManager.playClickSound();
                      state.user.id != 0
                          ? showResetPasswordModal(context)
                          : showCreateProfileModal(context);
                    },
                  ),
                  SizedBox(height: 30.h),
                  _SectionDivider(label: tr.t('profile_game_settings')),
                  SizedBox(height: 20.h),
                  _SettingsTogglesRow(
                    soundManager: soundManager,
                    isLoggedIn: state.user.id != 0,
                  ),
                  SizedBox(height: 20.h),
                  if (state.user.id != 0 &&
                      state.user.role.toLowerCase() != 'collaborator')
                    _CollaboratorButton(),
                  SizedBox(height: 10.h),
                  _LanguageSetting(),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () => showDeleteAccountModal(context),
                    child: Text(
                      tr.t('profile_delete_account'),
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Mikado',
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  _SectionDivider(label: tr.t('profile_follow_us')),
                  SizedBox(height: 20.h),
                  _SocialMediaRow(onLaunch: _launchURL),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.state});

  final AuthenticationState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.slateBlue,
              offset: const Offset(0, 5),
              blurRadius: 0,
              spreadRadius: -2,
            ),
          ],
          gradient: const LinearGradient(
            begin: Alignment(-1.495, 0),
            end: Alignment(1.2643, 0),
            colors: [Color(0xFF92C1F8), Color(0xFF99C7FF)],
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
                border: Border.all(width: 4.w, color: AppColors.lightBlue),
              ),
              child: AvatarWidget(
                seed: state.user.id.toString(),
                width: 70.w,
                height: 70.h,
              ),
            ),
            SizedBox(width: 10.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    StrokeText(
                      text: state.user.name,
                      textStyle: TextStyle(
                        color: const Color(0xFF2A62A9),
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w900,
                      ),
                      strokeColor: Colors.white,
                      strokeWidth: 2,
                    ),
                    SizedBox(width: 40.w),
                    ScoreInfo(
                      width: 70.w,
                      backgroundColor: AppColors.streakBackground,
                      borderColor: AppColors.streakBorder,
                      shadowColor: AppColors.streakShade,
                      score: state.user.streak.toString(),
                      iconImage: IconImageRoutes.streakIcon,
                      iconWidth: 14.w,
                      textColor: AppColors.streakText,
                      onTap: () => showStreakModal(context),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/flags/${state.user.country.replaceAll('/', ' ').toLowerCase()}.svg',
                      width: 21.w,
                    ),
                    SizedBox(width: 5.w),
                    StrokeText(
                      text: state.user.country,
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w900,
                      ),
                      strokeColor: const Color(0xFF0662BA),
                      strokeWidth: 2,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Image.asset(getBadgeUrl(state.user.rank), width: 18.sp),
                    SizedBox(width: 5.w),
                    StrokeText(
                      text: capitalizeText(state.user.rank),
                      textStyle: TextStyle(
                        color: const Color(0xFF5047C4),
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
    );
  }
}

class _ProfileActionButton extends StatelessWidget {
  const _ProfileActionButton({
    required this.backgroundImage,
    required this.label,
    required this.onTap,
  });

  final String backgroundImage;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 15.h),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(backgroundImage),
              fit: BoxFit.fill,
            ),
          ),
          child: Center(
            child: StrokeText(
              text: label,
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
              strokeColor: AppColors.deepInk,
              strokeWidth: 3,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColors.lightBlue,
            thickness: 1.0,
            indent: 10.w,
            endIndent: 30.w,
          ),
        ),
        StrokeText(
          text: label,
          textStyle: TextStyle(
            color: AppColors.lightYellowSurface,
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
          strokeColor: AppColors.deepInk,
          strokeWidth: 3,
        ),
        Expanded(
          child: Divider(
            color: AppColors.lightBlue,
            thickness: 1.0,
            indent: 30.w,
            endIndent: 10.w,
          ),
        ),
      ],
    );
  }
}

class _SettingsTogglesRow extends StatelessWidget {
  const _SettingsTogglesRow({
    required this.soundManager,
    required this.isLoggedIn,
  });

  final dynamic soundManager;
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalization.tr(context);
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            mainAxisAlignment: isLoggedIn
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.center,
            children: [
              _ToggleItem(
                label: tr.t('profile_music'),
                iconPath: state.isMusicOn
                    ? IconImageRoutes.musicOn
                    : IconImageRoutes.musicOff,
                onTap: () {
                  soundManager.playClickSound();
                  context.read<SettingsBloc>().add(ToggleMusic());
                },
              ),
              _ToggleItem(
                label: tr.t('profile_sound'),
                iconPath: state.isSoundOn
                    ? IconImageRoutes.soundOn
                    : IconImageRoutes.soundOff,
                onTap: () {
                  soundManager.playClickSound();
                  context.read<SettingsBloc>().add(ToggleSound());
                },
              ),
              if (isLoggedIn)
                _ToggleItem(
                  label: tr.t('auth_logout'),
                  iconPath: IconImageRoutes.logOut,
                  onTap: () {
                    soundManager.playClickSound();
                    showLogoutModal(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ToggleItem extends StatelessWidget {
  const _ToggleItem({
    required this.label,
    required this.iconPath,
    required this.onTap,
  });

  final String label;
  final String iconPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.w),
          child: GestureDetector(
            onTap: onTap,
            child: Image.asset(iconPath, width: 64.w),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _CollaboratorButton extends StatelessWidget {
  const _CollaboratorButton();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state.hasSentCollaboratorMail) {
          final tr = AppLocalization.tr(context);
          showCustomToast(context, tr.t('profile_collaborator_thanks'));
        }
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: GestureDetector(
            onTap: () => context.read<UserBloc>().add(OnboardCollaborator()),
            child: Container(
              width: double.infinity,
              padding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.newBlueBtnBgTwo),
                  fit: BoxFit.fill,
                ),
              ),
              child: Center(
                child: state.isOnboardingCollaborator
                    ? SizedBox(
                        height: 13.h,
                        width: 13.w,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : StrokeText(
                        text: AppLocalization.tr(context).t('profile_collaborator'),
                        textStyle: TextStyle(
                          color: AppColors.lightYellowSurface,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                        strokeColor: AppColors.deepInk,
                        strokeWidth: 3,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LanguageSetting extends StatelessWidget {
  const _LanguageSetting();

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalization.tr(context);
    final currentLocale = Localizations.localeOf(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            tr.t('language_setting'),
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
              ),
            ),
            child: DropdownButton<String>(
              value: currentLocale.languageCode,
              dropdownColor: const Color(0xFF1A3A6B),
              underline: const SizedBox(),
              isDense: true,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              icon: Icon(Icons.arrow_drop_down, color: Colors.white, size: 20.sp),
              items: [
                DropdownMenuItem(
                  value: 'en',
                  child: Text(tr.t('language_english')),
                ),
                DropdownMenuItem(
                  value: 'fr',
                  child: Text(tr.t('language_french')),
                ),
              ],
              onChanged: (value) {
                if (value != null && value != currentLocale.languageCode) {
                  changeAppLocale(context, Locale(value));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialMediaRow extends StatelessWidget {
  const _SocialMediaRow({required this.onLaunch});

  final void Function(String url) onLaunch;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Image.asset(IconImageRoutes.instagram, width: 26.w),
          onPressed: () => onLaunch('https://www.instagram.com/ourbiblegame'),
        ),
        SizedBox(width: 50.w),
        IconButton(
          icon: Image.asset(IconImageRoutes.facebook, width: 26.w),
          onPressed: () => onLaunch(
              'https://www.facebook.com/profile.php?id=61561426356965'),
        ),
        SizedBox(width: 50.w),
        IconButton(
          icon: Image.asset(IconImageRoutes.xIcon, width: 26.w),
          onPressed: () => onLaunch('https://x.com/OurBibleGame'),
        ),
      ],
    );
  }
}
