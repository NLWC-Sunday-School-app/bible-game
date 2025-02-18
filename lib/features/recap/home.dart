
import 'package:bible_game/features/recap/recap_eight.dart';
import 'package:bible_game/features/recap/recap_five.dart';
import 'package:bible_game/features/recap/recap_four.dart';
import 'package:bible_game/features/recap/recap_one.dart';
import 'package:bible_game/features/recap/recap_seven.dart';
import 'package:bible_game/features/recap/recap_six.dart';
import 'package:bible_game/features/recap/recap_three.dart';
import 'package:bible_game/features/recap/recap_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';


void showRecapModal (BuildContext context){
   showModalBottomSheet(
     context: context,
     isScrollControlled: true,
     isDismissible: false,
     builder: (BuildContext context){
       return RecapHomeScreen();
     }
   );
}

class RecapHomeScreen extends StatefulWidget {
  const RecapHomeScreen({Key? key}) : super(key: key);

  @override
  State<RecapHomeScreen> createState() => _RecapHomeScreenState();
}

class _RecapHomeScreenState extends State<RecapHomeScreen> with SingleTickerProviderStateMixin{
  late PageController _pageController;
  late AnimationController _animationController;

  int _currentIndex = 0;
  List<Widget> storyList = [const RecapOneScreen(), const RecapTwoScreen(), const RecapThreeScreen(), const RecapFourScreen(), const RecapFiveScreen(), const RecapSixScreen(), const RecapSevenScreen(), const RecapEightScreen() ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(vsync: this);

    _loadStory(animateToPage: false);
    _animationController.addStatusListener((status){
        if(status == AnimationStatus.completed){
          _animationController.stop();
          _animationController.reset();
          setState(() {
            if(_currentIndex + 1 < storyList.length){
              _currentIndex += 1;
              _loadStory();
            }else{
              _currentIndex = 0;
              _loadStory();
            }
          });

        }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dynamic story = storyList[_currentIndex];
    return Scaffold(
      body: GestureDetector(
           onTapDown: (details) => _onTapDown(details, story),
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: storyList.length,
                itemBuilder: (context, int index) {
                  switch(index){
                    case 0:
                      return const RecapOneScreen();
                    case 1:
                      return const RecapTwoScreen();
                    case 2:
                      return const RecapThreeScreen();
                    case 3:
                      return const RecapFourScreen();
                    case 4:
                      return const RecapFiveScreen();
                    case 5:
                      return const RecapSixScreen();
                    case 6:
                      return const RecapSevenScreen();
                    case 7:
                      return const RecapEightScreen();
                  }
                  return const SizedBox.shrink();
                },
              ),

              Positioned(
                top: 60.h,
                left: 10.w,
                right: 10.w,
                child: Column(
                  children: [
                    Row(
                      children: storyList.asMap().map((i, e){
                        return MapEntry(
                          i, AnimatedBar(
                          animationController: _animationController,
                          position: i,
                          currentIndex: _currentIndex,
                        ),
                        );
                      }).values.toList(),
                    ),

                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                        },
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Image.asset('assets/images/product/recap/recap_close.png', width: 35.w,),
                        ),
                      ),
                    )

                  ],
                ),
              )
            ],
          ),
      ),
    );
  }


  void _onTapDown(TapDownDetails details, story) {
     final double screenWidth = Get.width;
     final dx = details.globalPosition.dx;
     if (dx < screenWidth / 3){
       setState(() {
         if(_currentIndex - 1 >= 0){
           _currentIndex  = _currentIndex -  1;
           _loadStory();
         }
       });
     }else if(dx > 2 * screenWidth / 3) {
        setState(() {
          if(_currentIndex + 1 < storyList.length){
            _currentIndex = _currentIndex + 1;
            _loadStory();
          }else{
            _currentIndex = 0;
            _loadStory();
          }
        });
     }else{
       if(_currentIndex == 7){
         _animationController.stop();
       }
     }
  }

  void _loadStory({bool animateToPage = true}){
    _animationController.stop();
    _animationController.reset();
    _animationController.duration = const Duration(seconds: 10);
    _animationController.forward();

    if(animateToPage){
      _pageController.animateToPage(
         _currentIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut
      );
    }
  }
}

class AnimatedBar extends StatelessWidget {
  final AnimationController animationController;
  final int position;
  final int currentIndex;

  const AnimatedBar({Key? key, required this.animationController, required this.position, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.5.w),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: <Widget>[
                _buildContainer(
                  double.infinity,
                  position < currentIndex
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
                position == currentIndex
                    ? AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return _buildContainer(
                      constraints.maxWidth * animationController.value,
                      Colors.white,
                    );
                  },
                )
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }
}
Container _buildContainer(double width, Color color) {
  return Container(
    height: 8.h,
    width: width,
    decoration: BoxDecoration(
      color: color,
      border: Border.all(
        color: Colors.black26,
        width: 0.8.w,
      ),
      borderRadius: BorderRadius.circular(24.r),
    ),
  );
}




