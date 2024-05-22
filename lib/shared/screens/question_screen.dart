import 'package:flutter/material.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';
import 'package:the_bible_game/shared/widgets/option_button.dart';
import 'package:the_bible_game/shared/widgets/question_box.dart';
import 'package:the_bible_game/shared/widgets/question_clock.dart';
import 'package:the_bible_game/shared/widgets/question_number_box.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/widgets/coins_number_box.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              height: 50.h,
            ),
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CoinsNumberBox(),
                QuestionClock(),
                QuestionNumberBox()
              ],
            )),
            SizedBox(
              height: 15.h,
            ),
            QuestionBox(),
            SizedBox(
              height: 15.h,
            ),
            OptionButton(),
            OptionButton(),
            OptionButton(),
            OptionButton(),
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
    );
  }
}
