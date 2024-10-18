import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bible_game/features/home/widget/modals/game_settings_modal.dart';
import 'package:bible_game/shared/constants/app_routes.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/utils/formatter.dart';
import 'package:bible_game_api/bible_game_api.dart';

import '../../../shared/features/settings/bloc/settings_bloc.dart';

class UserProfileInfo extends StatelessWidget {
  const UserProfileInfo(
      {Key? key,
      required this.badgeSrc,
      required this.avatarUrl,
      required this.displayBadgeInfo,
      required this.user})
      : super(key: key);

  final String badgeSrc;
  final String avatarUrl;
  final User? user;
  final VoidCallback displayBadgeInfo;

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    return GestureDetector(
      onTap: () {
        soundManager.playClickSound();
        // showGameSettingsModal(context, user!);
        Navigator.pushNamed(context, AppRoutes.profileScreen);
      },
      child: SizedBox(
        width: 185.w,
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 6.w),
                    decoration: BoxDecoration(
                      color: const Color(0XFF366ABC),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(4.r),
                        topLeft: Radius.circular(4.r),
                        bottomRight: Radius.circular(10.r),
                      ),
                      boxShadow: const [
                        BoxShadow(
                            color: Color(0xFF04255A),
                            offset: Offset(0, 5),
                            blurRadius: 0,
                            spreadRadius: -2)
                      ],
                    ),
                    child: Container(
                      padding: EdgeInsets.only(left: 30.w),
                      width: 110.w,
                      child: Text(
                        user!.name,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  InkWell(
                    child: Container(
                        padding: EdgeInsets.only(
                            left: 30.w, right: 5.w, top: 5.h, bottom: 5.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(4.r),
                            bottomRight: Radius.circular(10.r),
                            bottomLeft: Radius.circular(10.r),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFF366ABC),
                              offset: Offset(0, 5),
                              blurRadius: 0,
                              spreadRadius: -2,
                            )
                          ],
                        ),
                        child: Container(
                          padding: EdgeInsets.only(left: 25.w),
                          width: 95.w,
                          child: Row(
                            children: [
                              Image.asset(
                                badgeSrc,
                                width: 15.w,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                capitalizeText(user!.rank == 'young believer' ? 'YB' : user!.rank),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF5047C4),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0.w,
              top: 8.h,
              child: InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border:
                        Border.all(width: 3.w, color: const Color(0xFF366ABC)),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2.w,
                        color: const Color(0xFF4A91FF),
                      ),
                    ),
                    child:
                    SvgPicture.network(
                     avatarUrl,
                      width: 50.w,
                      semanticsLabel: 'Logo',
                      placeholderBuilder: (BuildContext context) => Image.asset(ProductImageRoutes.defaultAvatar, width: 50.w,),
                    ),

                    // FadeInImage.assetNetwork(
                    //   placeholder: ProductImageRoutes.defaultAvatar,
                    //   image: avatarUrl,
                    //   width: 50.w,
                    // ),
                    padding: EdgeInsets.all(5.w),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
