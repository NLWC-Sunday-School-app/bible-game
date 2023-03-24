import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:bible_game/controllers/tags_pill_controller.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:bible_game/screens/quick_game/step_two.dart';
import 'package:bible_game/widgets/game_button.dart';
import 'package:bible_game/widgets/modals/quick_game_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../widgets/TagPill.dart';

class QuickGameStepOneScreen extends StatefulWidget {
  const QuickGameStepOneScreen({Key? key}) : super(key: key);
  static String routeName = "/quick-game-step-one-screen";

  @override
  State<QuickGameStepOneScreen> createState() => _QuickGameStepOneScreenState();
}

class _QuickGameStepOneScreenState extends State<QuickGameStepOneScreen> {
  final player = AudioPlayer();
  TagsPillController tagsPillController = Get.put(TagsPillController());
  UserController userController = Get.put(UserController());
  showDialogModal() {
    Get.dialog(
      const QuickGameModal(),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
          children: [
            Container(
              padding: Get.width > 900 ? EdgeInsets.only(bottom: 120.h) : EdgeInsets.only(bottom: Get.height < 680 ? 60.h : 80.h),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF32B1F2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                      'assets/images/cloud.png',
                    ),
                ],
              ),

            ),
            Container(
              margin: EdgeInsets.only(top: 75.h),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => {
                          userController.soundIsOff.isFalse ? userController.playGameSound() : null,
                          Get.back()
                        },
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 24.w,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 20.h,
                      ),
                       Text(
                        'Start Quick Game in \n2 easy steps',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 22.sp,
                            letterSpacing: 1,
                            fontFamily: 'Neuland',
                            color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.h),
                    child: SvgPicture.asset(
                        'assets/images/quick_game_step_one.svg'),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.35),
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'You can select up to 4 topics of interest.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Center(
                    child: Obx (
                      () => tagsPillController.isLoading.value ? Container(
                          margin: EdgeInsets.only(top: 100.h),
                          child: Image.asset('assets/images/icons/loader.gif'),) :
                      SizedBox(
                        height: 380.h,
                        child : GridView.custom(
                                gridDelegate:  SliverQuiltedGridDelegate(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 4,
                                  crossAxisSpacing: 4,
                                  repeatPattern: QuiltedGridRepeatPattern.inverted,
                                  pattern: const[
                                    QuiltedGridTile(1, 2),
                                    QuiltedGridTile(1, 1),
                                    QuiltedGridTile(1, 1),
                                    QuiltedGridTile(1, 2),
                                  ],
                                ),
                                childrenDelegate: SliverChildBuilderDelegate(
                                      (context, index) => TagPill(
                                              tag: tagsPillController.tagList[index].tag,
                                              id: tagsPillController.tagList[index].id,

                                            ),childCount: tagsPillController.tagList.length
                                ),
                              ),
                      ),


                      // Wrap(
                      //   spacing: 10.0,
                      //   runSpacing: 15.0,
                      //   children: List.generate(
                      //     tagsPillController.tagList.length,
                      //     (index) => TagPill(
                      //       tag: tagsPillController.tagList[index].tag,
                      //       id: tagsPillController.tagList[index].id,
                      //
                      //     ),
                      //   ),
                      // ),


                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Obx(
                      () => tagsPillController.isLoading.value ? const SizedBox() : Center(
                      child: GestureDetector(
                        onTap: () => {
                          userController.soundIsOff.isFalse ? userController.playGameSound() : null,
                          if(tagsPillController.selectedPill.isNotEmpty){
                            tagsPillController.goToQuickGameStepTwoScreen()
                          }

                        },
                        child: const GameButton(
                          buttonText: 'CONTINUE',
                          buttonActive: true,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            )
          ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }
}
