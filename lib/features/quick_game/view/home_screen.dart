import 'package:flutter/material.dart';
import 'package:the_bible_game/features/quick_game/widget/search_box.dart';
import 'package:the_bible_game/features/quick_game/widget/topic_tag.dart';
import 'package:the_bible_game/shared/constants/app_routes.dart';
import 'package:the_bible_game/shared/constants/colors.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:the_bible_game/shared/widgets/blue_button.dart';
import 'package:the_bible_game/shared/widgets/screen_app_bar.dart';
import '../../../shared/constants/image_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuickGameHomeScreen extends StatefulWidget {
  const QuickGameHomeScreen({super.key});

  @override
  State<QuickGameHomeScreen> createState() => _QuickGameHomeScreenState();
}

class _QuickGameHomeScreenState extends State<QuickGameHomeScreen> {
  final GlobalKey _key = GlobalKey();
  double? searchBoxHeight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        searchBoxHeight = getHeightOfWidget(_key);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xFF014AA0),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(ProductImageRoutes.patternTwoBg),
          fit: BoxFit.cover,
        )),
        child: Column(
          children: [
            ScreenAppBar(
              widgets: [
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Image.asset(
                        IconImageRoutes.arrowCircleBack,
                        width: 44.w,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: StrokeText(
                          text: 'Quick Game',
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w900,
                          ),
                          strokeColor: AppColors.titleDropShadowColor,
                          strokeWidth: 6,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Image.asset(
                        IconImageRoutes.infoCircle,
                        width: 44.w,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  'Select up to 4 topics of interest!',
                  style: TextStyle(
                    fontFamily: 'Mikado',
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
            Container(
              key: _key,
              child: SearchBox(),
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
              constraints: BoxConstraints(maxHeight: 50.h),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      double height = getHeightOfWidget(_key);
                      print('Height of the widget: $height');
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 20.w),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          '(0/4)',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxHeight: screenHeight - (160.h + 97.h + 30.h + 50.h),
                  ),
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: 25,
                    itemBuilder: (BuildContext context, int index) {
                      return TopicTag();
                    },
                  ),
                ),
                Positioned(
                  top: 400.h,
                  right: 35.w,
                  left: 35.w,
                  child: BlueButton(
                    buttonText: 'Play now',
                    buttonIsLoading: false,
                    width: 250.w,
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.questionLoadingScreen),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  double getHeightOfWidget(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }
}
