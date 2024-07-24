import 'package:flutter/material.dart';
import 'package:the_bible_game/features/multi_player/widget/multi_player_coin_box.dart';
import 'package:the_bible_game/features/multi_player/widget/question_timer.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';
import 'package:the_bible_game/shared/widgets/option_button.dart';
import 'package:the_bible_game/shared/widgets/question_box.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MultiplayerQuestionScreen extends StatelessWidget {
  const MultiplayerQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(ProductImageRoutes.questionScreenBg),
          fit: BoxFit.cover,
        )),
        child: Column(
          children: [
            SizedBox(
              height: 45.h,
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MultiplayerCoinBox(
                        createdChallenge: true,
                        userName: 'jesulademi',
                        pointsGained: '4000',
                        userAvatar: 'https://api.multiavatar.com/tobilove.png',
                      ),
                      Image.asset(
                        ProductImageRoutes.vs,
                        width: 70.w,
                      ),
                      MultiplayerCoinBox(
                        createdChallenge: false,
                        userName: 'toblinkz',
                        pointsGained: '3000',
                        userAvatar: 'https://api.multiavatar.com/Binx Bond.png',
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h,),
                  QuestionTimer()
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            QuestionBox(instruction: '', question: '',),
            SizedBox(
              height: 15.h,
            ),
            // OptionButton(),
            // OptionButton(),
            // OptionButton(),
            // OptionButton(),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  IconImageRoutes.redCircleClose,
                  width: 64.w,
                ),
                Image.asset(
                  IconImageRoutes.skip,
                  width: 64.w,
                ),
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
          ],
        ),
      ),
    );
  }
}
