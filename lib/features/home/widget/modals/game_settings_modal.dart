import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game_api/bible_game_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';
import 'package:the_bible_game/shared/features/authentication/bloc/authentication_bloc.dart';

import '../../../../shared/features/user/bloc/user_bloc.dart';
import '../../../../shared/utils/avatar_credentials.dart';

void showGameSettingsModal(BuildContext context, User user) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          backgroundColor: Colors.transparent,
          insetAnimationCurve: Curves.easeIn,
          insetAnimationDuration: const Duration(milliseconds: 500),
          child: GameSettingsModal(
            user: user,
          ),
        );
      });
}

class GameSettingsModal extends StatefulWidget {
  const GameSettingsModal({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<GameSettingsModal> createState() => _GameSettingsModalState();
}

class _GameSettingsModalState extends State<GameSettingsModal> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 600.h,
        width: 500.h,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ProductImageRoutes.modalBg),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 50.h,
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
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
              StrokeText(
                text: 'Your Profile',
                textStyle: TextStyle(
                  color: const Color(0xFF1768B9),
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w900,
                ),
                strokeColor: Colors.white,
                strokeWidth: 5,
              ),
              const SizedBox(
                height: 30,
              ),
              Image.network(
                '${AvatarCredentials.BaseURL}/${widget.user.id}.png?apikey=${AvatarCredentials.APIKey}/',
                width: 60.w,
              ),
              const SizedBox(
                height: 20,
              ),
              AutoSizeText(
                widget.user.name,
                style: TextStyle(
                  fontSize: 20.sp,
                  color: const Color(0xFF323B63),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      IconImageRoutes.edit,
                      width: 15.w,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      'Edit your Profile',
                      style: TextStyle(
                        color: const Color(0xFF4075BB),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              GestureDetector(
                onTap: () {},
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        IconImageRoutes.bluePadlock,
                        width: 15.w,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        'Reset Password',
                        style: TextStyle(
                            color: const Color(0xFF4075BB),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              BlocBuilder<UserBloc, UserState>(
                builder: (context, userState) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            iconSize: 50,
                            onPressed: () => {
                               context.read<UserBloc>().add(ToggleSound())
                            },
                            icon: Image.asset(
                              userState is SoundOn
                                  ? IconImageRoutes.soundOn
                                  : IconImageRoutes.soundOff,
                              width: 50.w,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                              iconSize: 50,
                              onPressed: () => {
                                context.read<UserBloc>().add(ToggleMusic())
                              },
                              icon: Image.asset(
                                userState is MusicOn
                                    ? IconImageRoutes.musicOn
                                    : IconImageRoutes.musicOff,
                                width: 50.w,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                              iconSize: 50,
                              onPressed: () => {
                                context.read<UserBloc>().add(ToggleNotification())
                              },
                              icon: Image.asset(
                                userState is NotificationOn
                                    ? IconImageRoutes.notificationOn
                                    : IconImageRoutes.notificationOff,
                                width: 50.w,
                              )),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () => {},
                child: Container(
                  width: 200.w,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: const Color(0xFF548BD5),
                      border: Border.all(color: const Color(0xFF548CD7)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(40))),
                  child: Text(
                    'LOG OUT',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        color: const Color(0xFFFFFFFF),
                        fontSize: 14.sp),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'Delete Account',
                  style: TextStyle(
                    color: Colors.red,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
