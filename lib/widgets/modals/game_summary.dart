import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/controllers/quick_game_question_controller.dart';
import 'package:bible_game/screens/quick_game/step_one.dart';
import 'package:bible_game/screens/tab_main_screen.dart';
import 'package:bible_game/widgets/game_summary_action_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameSummaryModal extends StatelessWidget {
  const GameSummaryModal({Key? key, required this.pointsGained, required this.questionsGotten,  required this.onTap}) : super(key: key);

  final String pointsGained;
  final String questionsGotten;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(110, 91, 220, 1),
                    Color.fromRGBO(60, 46, 144, 1),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color:
                        const Color.fromRGBO(152, 152, 152, 1).withOpacity(0.2),
                    spreadRadius: 3,
                    blurRadius: 2,
                    offset: const Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(top: 50),
                        width: double.infinity,
                        color: Colors.white,
                        child: const AutoSizeText(
                          'Game Completed!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF6351CC)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const AutoSizeText(
                        'Your Score',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                       AutoSizeText(
                          pointsGained,
                          style: const TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                      ),

                      const SizedBox(
                        height: 5,
                      ),
                      const AutoSizeText(
                        'Bonus Point: 750',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 95.0),
                        child: Divider(
                          color: Colors.white,
                          thickness: 1,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children:  [
                                const Text(
                                  'Questions you got:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  questionsGotten,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            const VerticalDivider(
                              color: Colors.white,
                              thickness: 1,
                            ),
                            Column(
                              children: const [
                                Text(
                                  'Avg. time spent',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  ':45',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 220),
                    child: Image.asset(
                        'assets/images/quick_game/game_summary_cloud.png'),
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 45,
              ),
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 60,
              ),
              Icon(
                Icons.star,
                color: Colors.amber,
                size: 45,
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 375),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                GameSummaryActionButton(
                  icon: const Icon(
                    Icons.refresh_outlined,
                    color: Colors.white,
                  ),
                  size: 15,
                  shapeColor: const Color(0XFFFDC049),
                  onTap: onTap,
                ),
                GameSummaryActionButton(
                  icon: const Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  size: 25,
                  shapeColor: const Color(0XFF7663E5),
                  onTap: ()=>{
                    Get.delete<QuickGamesQuestionController>(),
                    Get.offAll(() => const TabMainScreen(), transition: Transition.fadeIn)
                  },
                ),
                GameSummaryActionButton(
                  icon: const Icon(
                    Icons.share,
                    color: Colors.white,
                  ),
                  size: 15,
                  shapeColor: const Color(0XFFFDC049),
                  onTap: ()=>{},
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
