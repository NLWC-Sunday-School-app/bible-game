import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class SuccessModal extends StatelessWidget {
  const SuccessModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final assetsAudioPlayer = AssetsAudioPlayer();
    return Dialog(
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: SizedBox(
          height: 350,
          width: 350,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/modal_layout_2.png'),
                  fit: BoxFit.fill
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 45.0),
                    child: GestureDetector(
                        onTap: () => {
                          assetsAudioPlayer.open(Audio("assets/audios/click.mp3")),
                          Get.back()
                        },
                        child: Image.asset(
                          'assets/images/icons/cancel.png',
                          width: 25,
                        )),
                  ),
                ),
                const SizedBox(height: 20,),
                 Image.asset('assets/images/icons/success_mark.png', width: 80,),
                const SizedBox(height: 50,),
                const AutoSizeText(
                  'Your profile has been\n created successfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Neuland',
                    fontSize: 16,
                    color: Color(0xFF4075BB)
                ),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
