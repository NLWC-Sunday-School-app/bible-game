import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:screenshot/screenshot.dart';
import '../../utilities/string_converter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:get/get.dart';
import 'package:bible_game/controllers/user_controller.dart';
class RecapEightScreen extends StatefulWidget {
  const RecapEightScreen({Key? key}) : super(key: key);

  @override
  State<RecapEightScreen> createState() => _RecapEightScreenState();
}

class _RecapEightScreenState extends State<RecapEightScreen> {
  ScreenshotController screenshotController = ScreenshotController();
  UserController userController = Get.put(UserController());
  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  const Color(0xFF1896FD).withOpacity(0.9),
                  const Color.fromRGBO(5, 54, 130, 0.6),
                ],
              ),
              image: DecorationImage(
                image: AssetImage(formatBiblePersonalityBackgroundImage(GetStorage().read('game_recap')['user_percentile'])),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 300.h,
            left: 0.w,
            right: 0.w,
            child: Column(
              children: [
                Image.asset(
                  formatBiblePersonalityImage(GetStorage().read('game_recap')['user_percentile']),
                  width: 200.w,
                ).animate().slide(duration: 800.ms),
                Text(
                  formatBiblePersonality(GetStorage().read('game_recap')['user_percentile']),
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 36.sp,
                    color: Colors.white,
                  ),
                ).animate().fadeIn(delay: 800.ms, duration: 800.ms),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  formatBiblePersonalityPhrase(GetStorage().read('game_recap')['user_percentile']),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontFamily: 'Gochi Hand',
                      color: Color(formatBiblePersonalityPhraseColor(GetStorage().read('game_recap')['user_percentile']))),
                ).animate().shake(delay: 800.ms, duration: 800.ms),
                SizedBox(
                  height: 80.h,
                ),
                InkWell(
                  onTap: () async{
                    userController.soundIsOff.isFalse ? userController.playGameSound() : null;
                    await screenshotController
                        .capture(delay: const Duration(milliseconds: 10))
                        .then((Uint8List? image) async {
                      if (image != null) {
                        final directory = await getApplicationDocumentsDirectory();
                        print(directory);
                        String fileName = DateTime.fromMicrosecondsSinceEpoch.toString();
                        print(fileName);
                        final imagePath = File('${directory.path}/image.png');
                        print(imagePath);
                        await imagePath.writeAsBytes(image);

                        final box = context.findRenderObject() as RenderBox?;
                        await Share.shareFiles(
                          [imagePath.path],
                          subject: 'Check out my #2023BibleGameRecap! Go see yours on your #BibleGameApp via https://onelink.to/rr9q7d',
                          sharePositionOrigin:
                          box!.localToGlobal(Offset.zero) & box.size,
                        );
                      }
                    });
                  },
                  child: Image.asset(
                    'assets/images/icons/recap_share.png',
                    width: 90.w,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
