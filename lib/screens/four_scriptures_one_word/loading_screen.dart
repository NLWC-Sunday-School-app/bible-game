import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../controllers/four_Scriptures_one_word_controller.dart';

class FourScriptureLoadingScreen extends StatefulWidget {
  const FourScriptureLoadingScreen({Key? key}) : super(key: key);

  @override
  State<FourScriptureLoadingScreen> createState() => _FourScriptureLoadingScreenState();
}

class _FourScriptureLoadingScreenState extends State<FourScriptureLoadingScreen> {
  FourScripturesOneWordController fourScripturesOneWordController = Get.put(FourScripturesOneWordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/four_scripture_one_word/prep_questions_bg.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
              SizedBox(height: 80.h,),
              Image.asset('assets/images/four_scripture_one_word/bible_game_text.png', width: 100.w),
              SizedBox(height: 160.h,),
              Image.asset('assets/images/four_scripture_one_word/test.png', width: 150.w,),
             SizedBox(height: 10.h,),
             Text('Preparing your questions...', style: TextStyle(
               fontSize: 16.sp,
               fontWeight: FontWeight.w600,
               color: Colors.white
             ),),
            SizedBox(height: 40.h,),
           Container(
             padding: EdgeInsets.symmetric(vertical: 10.h),
             width: double.infinity,
             decoration: const BoxDecoration(
               gradient:  LinearGradient(
                 begin: Alignment.topLeft,
                 end: Alignment.bottomRight,
                 colors:  [
                   Color.fromRGBO(84, 140, 215, 1),
                   Color.fromRGBO(18, 88, 182, 1),
                 ],
               ),
             ),
             child: const Text('Study to shew thyself approved \nunto God, a workman that \nneedeth not to be ashamed, \nrightly dividing the word \nof truth',
               textAlign: TextAlign.center,
               style: TextStyle(
                 fontWeight: FontWeight.w400,
                 color: Colors.white,
                 fontFamily: 'neuland'
              ),
             ),
           )

          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
   fourScripturesOneWordController.getFourScripturesOneWordQuestions();
  }
}

