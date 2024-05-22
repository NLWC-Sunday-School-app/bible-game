import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';

import '../../features/quick_game/widget/modal/quick_tips_modal.dart';

class QuestionLoadingScreen extends StatelessWidget {
  const QuestionLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: screenHeight,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
            AssetImage(ProductImageRoutes.questionLoadingBg),
            fit: BoxFit.cover,
          ),
        ),
        child: InkWell(
          onTap: () => {
            showQuickGameTipsModal(context)
          },
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 230.w,
              height: 250.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.white, width: 2.w),
                image: DecorationImage(
                  image: NetworkImage('https://res.cloudinary.com/dd3hfa9ug/image/upload/v1709740413/IMG_8527_jkdg13.png'),
                  fit: BoxFit.fill
                )
              ),
            ),
          ),
        ),
      ),
    );
  }
}
