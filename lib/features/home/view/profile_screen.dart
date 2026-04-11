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
import '../widget/modals/edit_profile.dart';
import '../widget/modals/reset_password_modal.dart';
import '../widget/score_info.dart';
import '../../../shared/widgets/login_gate_widget.dart';

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
      backgroundColor: const Color(0xFF014AA0),
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
                    height: 55.h,
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
                              width: 40.w,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(height: 24.h),
                          if (state.user.id != 0) ...[
                            _ProfileCard(state: state),
                            SizedBox(height: 20.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _DarkActionButton(
                                      icon: Icons.edit_rounded,
                                      label: tr.t('profile_edit'),
                                      color: const Color(0xFFFFBB33),
                                      onTap: () {
                                        soundManager.playClickSound();
                                        showEditProfileModal(context);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: _DarkActionButton(
                                      icon: Icons.lock_outline_rounded,
                                      label: tr.t('profile_change_password'),
                                      color: const Color(0xFF5EB0FF),
                                      onTap: () {
                                        soundManager.playClickSound();
                                        showResetPasswordModal(context);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ] else ...[
                            const LoginGateWidget(
                              featureTitle: 'Profile',
                              subtitle: 'Log in or create a profile\nto manage your account!',
                              icon: Icons.person_rounded,
                            ),
                          ],
                          SizedBox(height: 28.h),
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
                          if (state.user.id != 0) ...[
                            SizedBox(height: 20.h),
                            GestureDetector(
                              onTap: () => showDeleteAccountModal(context),
                              child: Text(
                                tr.t('profile_delete_account'),
                                style: TextStyle(
                                  color: const Color(0xFFFF6B6B),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Mikado',
                                  fontSize: 13.sp,
                                  decoration: TextDecoration.underline,
                                  decorationColor: const Color(0xFFFF6B6B),
                                ),
                              ),
                            ),
                          ],
                          SizedBox(height: 10.h),
                          _SectionDivider(label: tr.t('profile_follow_us')),
                          SizedBox(height: 16.h),
                          _SocialMediaRow(onLaunch: _launchURL),
                          SizedBox(height: 20.h),
                        ],
                      ),
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

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.state});

  final AuthenticationState state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A3A6B), Color(0xFF0D2550)],
          ),
          border: Border.all(
            color: const Color(0xFF4A8AD4).withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(0, 6),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Avatar with glow ring
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFFE066),
                        Color(0xFFFFAA00),
                        Color(0xFFFF8800),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFAA00).withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF0D2550),
                    ),
                    child: AvatarWidget(
                      seed: state.user.id.toString(),
                      width: 64.w,
                      height: 64.w,
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                // Name + info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StrokeText(
                        text: state.user.name,
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w900,
                        ),
                        strokeColor: const Color(0xFF042A6B),
                        strokeWidth: 4,
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/images/flags/${state.user.country.replaceAll('/', ' ').toLowerCase()}.svg',
                            width: 18.w,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            state.user.country,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Image.asset(getBadgeUrl(state.user.rank), width: 16.sp),
                          SizedBox(width: 6.w),
                          Text(
                            capitalizeText(state.user.rank),
                            style: TextStyle(
                              color: const Color(0xFFFFBB33),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Streak badge
                GestureDetector(
                  onTap: () => showStreakModal(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.r),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFFF6B35).withOpacity(0.2),
                          const Color(0xFFFF4500).withOpacity(0.1),
                        ],
                      ),
                      border: Border.all(
                        color: const Color(0xFFFF6B35).withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Image.asset(IconImageRoutes.streakIcon, width: 20.w),
                        SizedBox(height: 2.h),
                        Text(
                          state.user.streak.toString(),
                          style: TextStyle(
                            color: const Color(0xFFFF8C42),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DarkActionButton extends StatelessWidget {
  const _DarkActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.15),
              color.withOpacity(0.05),
            ],
          ),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24.sp),
            SizedBox(height: 6.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    const Color(0xFFFFD700).withOpacity(0.4),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Text(
              label,
              style: TextStyle(
                color: const Color(0xFFFFD700).withOpacity(0.8),
                fontSize: 12.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 1.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFFD700).withOpacity(0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: GestureDetector(
            onTap: () => context.read<UserBloc>().add(OnboardCollaborator()),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF2E7FE8).withOpacity(0.3),
                    const Color(0xFF1565C0).withOpacity(0.2),
                  ],
                ),
                border: Border.all(
                  color: const Color(0xFF5AA0F0).withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: state.isOnboardingCollaborator
                    ? SizedBox(
                        height: 14.h,
                        width: 14.w,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit_note_rounded,
                            color: const Color(0xFFFFD700),
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Flexible(
                            child: Text(
                              AppLocalization.tr(context).t('profile_collaborator'),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
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
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          color: const Color(0xFF0D2550).withOpacity(0.6),
          border: Border.all(
            color: const Color(0xFF4A8AD4).withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.language_rounded, color: Colors.white.withOpacity(0.6), size: 20.sp),
                SizedBox(width: 10.w),
                Text(
                  tr.t('language_setting'),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFF1A3A6B),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: const Color(0xFF4A8AD4).withOpacity(0.3),
                ),
              ),
              child: DropdownButton<String>(
                value: currentLocale.languageCode,
                dropdownColor: const Color(0xFF1A3A6B),
                underline: const SizedBox(),
                isDense: true,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                icon: Icon(Icons.arrow_drop_down, color: Colors.white.withOpacity(0.6), size: 20.sp),
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
