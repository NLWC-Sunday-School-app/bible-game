import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/screens/tabs/leaderboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class LeaderBoardMenuCard extends StatelessWidget {
  final String levelImage;
  final String levelLabel;
  final String levelNumber;
  const LeaderBoardMenuCard({Key? key, required this.levelImage, required this.levelLabel, required this.levelNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: (){
        Get.to(const LeaderBoardScreen(),
          duration: const Duration(milliseconds: 1000),
          transition: Transition.fadeIn
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          child: Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFE4D5FF),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: AutoSizeText(
                        levelNumber,
                        style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E1F85)),
                      ),
                    )),
                AutoSizeText(
                  levelLabel,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all( 2.0),
                  margin:  const EdgeInsets.only(right: 10.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFA0B560), width: 4)
                  ),

                  child: Image.asset(
                    levelImage,
                    width: 60,
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
