import 'package:bible_game/widgets/modals/badge_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controllers/user_controller.dart';
import '../../utilities/string_converter.dart';
import '../modals/settings_modal.dart';

class UserProfileInfo extends StatelessWidget {
  const UserProfileInfo(
      {Key? key,
      required this.username,
      required this.gameLevel,
      required this.badgeSrc,
      required this.avatarUrl,
        required this.displayBadgeInfo})
      : super(key: key);
  final String username;
  final String gameLevel;
  final String badgeSrc;
  final String avatarUrl;
  final VoidCallback displayBadgeInfo;

  @override
  Widget build(BuildContext context) {
    UserController userController = Get.put(UserController());
    return GestureDetector(
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
                      username,
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: 'Mikado',
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                InkWell(
                  onTap: (){
                    displayBadgeInfo();
                  },
                  child: Container(
                      padding: EdgeInsets.only(
                          left: 30.w, right: 10.w, top: 5.h, bottom: 5.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(4.r),
                            bottomRight: Radius.circular(10.r),
                            bottomLeft: Radius.circular(10.r)),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0xFF366ABC),
                              offset: Offset(0, 5),
                              blurRadius: 0,
                              spreadRadius: -2)
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
                              capitalize(gameLevel),
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  fontFamily: 'Mikado',
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF5047C4)),
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
              onTap: (){
                if (userController.soundIsOff.isFalse) {
                  userController.playGameSound();
                }
                Get.dialog(const SettingsModal(),
                    barrierDismissible: false,
                    transitionCurve: Curves.fastOutSlowIn,
                    transitionDuration: const Duration(milliseconds: 1000));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(width: 3.w, color: const Color(0xFF366ABC)),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border:
                        Border.all(width: 2.w, color: const Color(0xFF4A91FF)),
                  ),
                  child: FadeInImage.assetNetwork(
                     placeholder: 'assets/images/aesthetics/default_avatar.png',
                     image: avatarUrl,
                     width: 50.w,
                  ),
                  padding: EdgeInsets.all(5.w),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
