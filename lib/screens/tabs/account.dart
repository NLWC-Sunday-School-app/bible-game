import 'package:bible_game/controllers/auth_controller.dart';
import 'package:bible_game/controllers/pilgrim_progress_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/widgets/bottomSheetModal/AboutBottomModalSheet.dart';
import 'package:bible_game/widgets/bottomSheetModal/AccountBottomModalSheet.dart';
import 'package:bible_game/widgets/bottomSheetModal/BadgesBottomModalSheet.dart';
import 'package:bible_game/widgets/bottomSheetModal/PreferenceBottomModalSheet.dart';
import 'package:bible_game/widgets/onboarding/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';

class TabAccountScreen extends StatelessWidget {
  const TabAccountScreen({Key? key}) : super(key: key);

  void showBadgesBottomModalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return const BadgesBottomModalSheet();
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0.r),
              topRight: Radius.circular(20.0.r))),
    );
  }

  void showAboutBottomModalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return const AboutBottomModalSheet();
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0.r),
              topRight: Radius.circular(20.0.r))),
    );
  }

  void showAccountBottomModalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return const AccountBottomModalSheet();
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0.r),
              topRight: Radius.circular(20.0.r))),
    );
  }

  void showPreferencesBottomModalSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return const PreferenceBottomModalSheet();
      },
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0.r),
              topRight: Radius.circular(20.0.r))),
    );
  }



  @override
  Widget build(BuildContext context) {
    UserController userController = Get.put(UserController());
    AuthController authController = Get.put(AuthController());
    PilgrimProgressController pilgrimProgressController = Get.put(PilgrimProgressController());
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Stack(
          children: [
            Container(
              // padding: EdgeInsets.only(bottom: 200.h),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(110, 91, 220, 1),
                    Color.fromRGBO(60, 46, 144, 1),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/cloud_three.png',
                    width: 260.w,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: 22.w),
              margin: EdgeInsets.only(top: 80.h),
              child: Text(
                'Account',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 25.sp,
                    color: Colors.white),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 130.h),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(152, 152, 152, 1)
                              .withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 4,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    right: 15.0.w, left: 10.0.w),
                                child: userController.myUser['profileUrl'].toString() != 'null' ? Obx(
                                  () => Image.network(
                                    userController.myUser['profileUrl'].toString(),
                                    width: 45.w,
                                  ),
                                ) : Image.network(
                                  'https://res.cloudinary.com/dj5ud4y41/image/upload/v1670062222/403017_avatar_default_head_person_unknown_icon_zvhkjx.png',
                                  width: 45.w,
                                ) ,
                              ),
                              Obx(
                                () => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                userController.myUser['name'].toString() != 'null' ? userController.myUser['name'].toString() : 'Beloved',
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                        userController.myUser['rank'].toString() != 'null' ? userController.myUser['rank'].toString().capitalizeFirst! : 'Babe',
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Icon(Icons.arrow_forward_ios_outlined,
                                  size: 15.w,
                                  color: const Color.fromRGBO(154, 154, 154, 1))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(152, 152, 152, 1)
                              .withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 4,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () => showBadgesBottomModalSheet(context),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 8.0.w),
                                  child: const Icon(
                                    Icons.insert_chart,
                                    color: Color.fromRGBO(118, 99, 229, 1),
                                  ),
                                ),
                                Text(
                                  'Badges',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 15.w,
                                  color: const Color.fromRGBO(154, 154, 154, 1),
                                )
                              ],
                            ),
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8.0.w),
                                child: const Icon(
                                  Icons.group_add_outlined,
                                  color: Color.fromRGBO(118, 99, 229, 1),
                                ),
                              ),
                              Text(
                                'Invite a friend',
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 15.w,
                                color: const Color.fromRGBO(154, 154, 154, 1),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(152, 152, 152, 1)
                              .withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 4,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () => showAccountBottomModalSheet(context),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 8.0.w),
                                  child: const Icon(
                                    Icons.bar_chart_rounded,
                                    color: Color.fromRGBO(118, 99, 229, 1),
                                  ),
                                ),
                                Text(
                                  'Accounts',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 15.w,
                                  color: const Color.fromRGBO(154, 154, 154, 1),
                                )
                              ],
                            ),
                          ),
                          const Divider(),
                          InkWell(
                            onTap: () => showPreferencesBottomModalSheet(context),
                            child: Row(
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(right: 8.0.w),
                                    child: const Icon(
                                      Icons.settings,
                                      color: Color.fromRGBO(118, 99, 229, 1),
                                    ),
                                  ),
                                Text(
                                  'Preferences',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 15.w,
                                  color: const Color.fromRGBO(154, 154, 154, 1),
                                )
                              ],
                            ),
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8.0.w),
                                child: const Icon(
                                  Icons.notifications_active,
                                  color: Color.fromRGBO(118, 99, 229, 1),
                                ),
                              ),
                              Text(
                                'Notifications',
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 15.w,
                                color: const Color.fromRGBO(154, 154, 154, 1),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Help',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(152, 152, 152, 1)
                              .withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 4,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () => showAboutBottomModalSheet(context),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 8.0.w),
                                  child: const Icon(
                                    Icons.info,
                                    color: Color.fromRGBO(118, 99, 229, 1),
                                  ),
                                ),
                                Text(
                                  'About',
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  size: 15.w,
                                  color: const Color.fromRGBO(154, 154, 154, 1),
                                )
                              ],
                            ),
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8.0.w),
                                child: const Icon(
                                  Icons.call,
                                  color: Color.fromRGBO(118, 99, 229, 1),
                                ),
                              ),
                              Text(
                                'Support',
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 15.w,
                                color: const Color.fromRGBO(154, 154, 154, 1),
                              )
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8.0.w),
                                child: const Icon(
                                  Icons.help,
                                  color: Color.fromRGBO(118, 99, 229, 1),
                                ),
                              ),
                              Text(
                                'FAQS',
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 15.w,
                                color: const Color.fromRGBO(154, 154, 154, 1),
                              )
                            ],
                          ),
                          const Divider(),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: 8.0.w),
                                child: const Icon(
                                  Icons.people,
                                  color: Color.fromRGBO(118, 99, 229, 1),
                                ),
                              ),
                              Text(
                                'Community',
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 15.w,
                                color: const Color.fromRGBO(154, 154, 154, 1),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Obx(
                      () => AuthButton(buttonText: 'LOG OUT', goToNextScreen: ()=>{
                      authController.logoutUser(),
                      Get.delete<PilgrimProgressController>(),
                        GetStorage().erase(),
                    }, isLoading: authController.isLoadingLogout.value),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

