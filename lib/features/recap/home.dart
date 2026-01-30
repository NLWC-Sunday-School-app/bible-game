//
// import 'package:bible_game/features/recap/recap_eight.dart';
// import 'package:bible_game/features/recap/recap_five.dart';
// import 'package:bible_game/features/recap/recap_four.dart';
// import 'package:bible_game/features/recap/recap_one.dart';
// import 'package:bible_game/features/recap/recap_seven.dart';
// import 'package:bible_game/features/recap/recap_six.dart';
// import 'package:bible_game/features/recap/recap_three.dart';
// import 'package:bible_game/features/recap/recap_two.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
//
// void showRecapModal (BuildContext context){
//    showModalBottomSheet(
//      context: context,
//      isScrollControlled: true,
//      isDismissible: false,
//      builder: (BuildContext context){
//        return RecapHomeScreen();
//      }
//    );
// }
//
// class RecapHomeScreen extends StatefulWidget {
//   const RecapHomeScreen({Key? key}) : super(key: key);
//
//   @override
//   State<RecapHomeScreen> createState() => _RecapHomeScreenState();
// }
//
// class _RecapHomeScreenState extends State<RecapHomeScreen> with SingleTickerProviderStateMixin{
//   late PageController _pageController;
//   late AnimationController _animationController;
//
//   int _currentIndex = 0;
//   List<Widget> storyList = [const RecapOneScreen(), const RecapTwoScreen(), const RecapThreeScreen(), const RecapFourScreen(), const RecapFiveScreen(), const RecapSixScreen(), const RecapSevenScreen(), const RecapEightScreen() ];
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//     _animationController = AnimationController(vsync: this);
//
//     _loadStory(animateToPage: false);
//     _animationController.addStatusListener((status){
//         if(status == AnimationStatus.completed){
//           _animationController.stop();
//           _animationController.reset();
//           setState(() {
//             if(_currentIndex + 1 < storyList.length){
//               _currentIndex += 1;
//               _loadStory();
//             }else{
//               _currentIndex = 0;
//               _loadStory();
//             }
//           });
//
//         }
//     });
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final dynamic story = storyList[_currentIndex];
//     return Scaffold(
//       body: GestureDetector(
//            onTapDown: (details) => _onTapDown(details, story),
//           child: Stack(
//             children: [
//               PageView.builder(
//                 controller: _pageController,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: storyList.length,
//                 itemBuilder: (context, int index) {
//                   switch(index){
//                     case 0:
//                       return const RecapOneScreen();
//                     case 1:
//                       return const RecapTwoScreen();
//                     case 2:
//                       return const RecapThreeScreen();
//                     case 3:
//                       return const RecapFourScreen();
//                     case 4:
//                       return const RecapFiveScreen();
//                     case 5:
//                       return const RecapSixScreen();
//                     case 6:
//                       return const RecapSevenScreen();
//                     case 7:
//                       return const RecapEightScreen();
//                   }
//                   return const SizedBox.shrink();
//                 },
//               ),
//
//               Positioned(
//                 top: 60.h,
//                 left: 10.w,
//                 right: 10.w,
//                 child: Column(
//                   children: [
//                     Row(
//                       children: storyList.asMap().map((i, e){
//                         return MapEntry(
//                           i, AnimatedBar(
//                           animationController: _animationController,
//                           position: i,
//                           currentIndex: _currentIndex,
//                         ),
//                         );
//                       }).values.toList(),
//                     ),
//
//                     InkWell(
//                       onTap: (){
//                         Navigator.pop(context);
//                         },
//                       child: Align(
//                         alignment: Alignment.topRight,
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(vertical: 10.h),
//                           child: Image.asset('assets/images/product/recap/recap_close.png', width: 35.w,),
//                         ),
//                       ),
//                     )
//
//                   ],
//                 ),
//               )
//             ],
//           ),
//       ),
//     );
//   }
//
//
//   void _onTapDown(TapDownDetails details, story) {
//      final double screenWidth = Get.width;
//      final dx = details.globalPosition.dx;
//      if (dx < screenWidth / 3){
//        setState(() {
//          if(_currentIndex - 1 >= 0){
//            _currentIndex  = _currentIndex -  1;
//            _loadStory();
//          }
//        });
//      }else if(dx > 2 * screenWidth / 3) {
//         setState(() {
//           if(_currentIndex + 1 < storyList.length){
//             _currentIndex = _currentIndex + 1;
//             _loadStory();
//           }else{
//             _currentIndex = 0;
//             _loadStory();
//           }
//         });
//      }else{
//        if(_currentIndex == 7){
//          _animationController.stop();
//        }
//      }
//   }
//
//   void _loadStory({bool animateToPage = true}){
//     _animationController.stop();
//     _animationController.reset();
//     _animationController.duration = const Duration(seconds: 10);
//     _animationController.forward();
//
//     if(animateToPage){
//       _pageController.animateToPage(
//          _currentIndex,
//         duration: const Duration(milliseconds: 1),
//         curve: Curves.easeInOut
//       );
//     }
//   }
// }
//
// class AnimatedBar extends StatelessWidget {
//   final AnimationController animationController;
//   final int position;
//   final int currentIndex;
//
//   const AnimatedBar({Key? key, required this.animationController, required this.position, required this.currentIndex}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Flexible(
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 1.5.w),
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return Stack(
//               children: <Widget>[
//                 _buildContainer(
//                   double.infinity,
//                   position < currentIndex
//                       ? Colors.white
//                       : Colors.white.withOpacity(0.5),
//                 ),
//                 position == currentIndex
//                     ? AnimatedBuilder(
//                   animation: animationController,
//                   builder: (context, child) {
//                     return _buildContainer(
//                       constraints.maxWidth * animationController.value,
//                       Colors.white,
//                     );
//                   },
//                 )
//                     : const SizedBox.shrink(),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
// Container _buildContainer(double width, Color color) {
//   return Container(
//     height: 8.h,
//     width: width,
//     decoration: BoxDecoration(
//       color: color,
//       border: Border.all(
//         color: Colors.black26,
//         width: 0.8.w,
//       ),
//       borderRadius: BorderRadius.circular(24.r),
//     ),
//   );
// }



import 'dart:io';

import 'package:bible_game/features/recap/2025_recap/recap_nineteen.dart';
import 'package:bible_game/features/recap/2025_recap/recap_one.dart';
import 'package:bible_game/features/recap/2025_recap/recap_seventeen.dart';
import 'package:bible_game/features/recap/2025_recap/recap_six.dart';
import 'package:bible_game/features/recap/2025_recap/recap_ten.dart';
import 'package:bible_game/features/recap/2025_recap/recap_thirteen.dart';
import 'package:bible_game/features/recap/2025_recap/recap_twelve.dart';
import 'package:bible_game/features/recap/2025_recap/recap_twenty.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '2025_recap/recap_eight.dart';
import '2025_recap/recap_eighteen.dart';
import '2025_recap/recap_eleven.dart';
import '2025_recap/recap_fifteen.dart';
import '2025_recap/recap_five.dart';
import '2025_recap/recap_four.dart';
import '2025_recap/recap_fourteen.dart';
import '2025_recap/recap_nine.dart';
import '2025_recap/recap_seven.dart';
import '2025_recap/recap_sixteen.dart';
import '2025_recap/recap_three.dart';
import '2025_recap/recap_two.dart';


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
  bool _isPaused = false;
  List<Widget> storyList = [const RecapOneScreen(), const RecapTwoScreen(), const RecapThreeScreen(), const RecapFourScreen(), const RecapFiveScreen(), const RecapSixScreen(), const RecapSevenScreen(), const RecapEightScreen(), RecapNineScreen(),RecapTenScreen(), RecapElevenScreen(),RecapTwelveScreen(), RecapThirteenScreen(), RecapFourteenScreen(), RecapFifteenScreen(),RecapSixteenScreen(), RecapSeventeenScreen(), RecapEighteenScreen(), RecapNineteenScreen(), RecapTwentyScreen()];

  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isSharing = false;

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
        // onTapDown: (details) => _onTapDown(details, story),
        onTapDown: (details) => _onTapDown(details),
        onLongPressStart: (_) => _pauseStory(),
        onLongPressEnd: (_) => _resumeStory(),
        child: BlocBuilder<UserBloc,UserState>(
          builder: (context, state) {
            return Stack(
              children: [
                Screenshot(
                  controller: _screenshotController,
                  child: PageView.builder(
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
                          return RecapFiveScreen();
                        case 5:
                          return const RecapSixScreen();
                        // case 6:
                        //   return const RecapSevenScreen();
                        case 6:
                          return const RecapEightScreen();
                        case 7:
                          return const RecapNineScreen();
                        case 8:
                          return const RecapTenScreen();
                        case 9:
                          return const RecapElevenScreen();
                        case 10:
                          return const RecapTwelveScreen();
                        case 11:
                          return const RecapThirteenScreen();
                        case 12:
                          return const RecapFourteenScreen();
                        case 13:
                          return const RecapFifteenScreen();
                        case 14:
                          return const RecapSixteenScreen();
                        case 15:
                          return const RecapSeventeenScreen();
                        case 16:
                          return const RecapEighteenScreen();
                        case 17:
                          return const RecapNineteenScreen();
                        case 18:
                          return const RecapTwentyScreen();
                      }
                      return const SizedBox.shrink();
                    },
                  ),
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
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child:
                  Column(
                    children: [
                      Spacer(),
                      InkWell(
                        onTap: _isSharing ? null : _captureAndShare,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
                          child: _isSharing
                              ? SizedBox(
                            width: 30.w,
                            height: 30.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                              :
                          Container(
                            width: 98.h,
                            height: 36.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(32)),
                              border: Border.all(
                                color: Colors.white,
                                width: 1
                              ),
                              color: Color(0xFF6E6E6E).withOpacity(0.5)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Spacer(),
                                Image.asset(
                                  ProductImageRoutes.recapShare,
                                  width: 13.w,
                                  height: 16.h,
                                ),
                                SizedBox(width: 8.w,),
                                Text(
                                  'Share',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontFamily: 'Mikado',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Spacer(),

                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h,),
                    ],
                  )
                )
              ],
            );
          }
        ),
      ),
    );
  }


  // void _onTapDown(TapDownDetails details, story) {
  //   final double screenWidth = Get.width;
  //   final dx = details.globalPosition.dx;
  //   if (dx < screenWidth / 3){
  //     setState(() {
  //       if(_currentIndex - 1 >= 0){
  //         _currentIndex  = _currentIndex -  1;
  //         _loadStory();
  //       }
  //     });
  //   }else if(dx > 2 * screenWidth / 3) {
  //     setState(() {
  //       if(_currentIndex + 1 < storyList.length){
  //         _currentIndex = _currentIndex + 1;
  //         _loadStory();
  //       }else{
  //         _currentIndex = 0;
  //         _loadStory();
  //       }
  //     });
  //   }else{
  //     if(_currentIndex == 7){
  //       _animationController.stop();
  //     }
  //   }
  // }

  ///Screenshot and Share Method
  Future<void> _captureAndShare() async {
    setState(() {
      _isSharing = true;
    });

    try {
      final wasAnimating = _animationController.isAnimating;
      if (wasAnimating) {
        _animationController.stop();
      }

      final Uint8List? imageBytes = await _screenshotController.capture(
        pixelRatio: 3.0,
      );
      print(imageBytes);
      if (imageBytes != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = '${directory.path}/recap_${DateTime.now().millisecondsSinceEpoch}.png';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(imageBytes);

        await Share.shareXFiles(
          [XFile(imagePath)],
          text: 'Check out my 2025 Bible Game Recap! 📖✨',
          subject: 'My 2025 Recap',
        );

        await imageFile.delete();
      }

      if (wasAnimating) {
        _animationController.forward();
      }
    } catch (e) {
      debugPrint('Error sharing screenshot: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to share. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  void _loadStory({bool animateToPage = true}){
    _animationController.stop();
    _animationController.reset();
    _animationController.duration = const Duration(seconds: 5);
    _animationController.forward();

    if(animateToPage){
      _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 1),
          curve: Curves.easeInOut
      );
    }
  }

  void _pauseStory() {
    setState(() {
      _isPaused = true;
      _animationController.stop();
    });
  }

  void _resumeStory() {
    setState(() {
      _isPaused = false;
      _animationController.forward();
    });
  }

  void _onTapDown(TapDownDetails details) {
    if (_isPaused) return; // Ignore taps when long-pressing

    final double screenWidth = MediaQuery.of(context).size.width;
    final dx = details.globalPosition.dx;

    if (dx < screenWidth / 3) {
      // Previous
      _goToPrevious();
    } else if (dx > 2 * screenWidth / 3) {
      // Next
      _goToNext();
    } else {
      // Toggle pause
      _togglePause();
    }
  }

  void _goToPrevious() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
        _loadStory();
      }
    });
  }

  void _goToNext() {
    setState(() {
      if (_currentIndex < storyList.length - 1) {
        _currentIndex++;
        _loadStory();
      } else {
        Navigator.pop(context); // Close when reaching the end
      }
    });
  }

  void _togglePause() {
    setState(() {
      if (_animationController.isAnimating) {
        _animationController.stop();
      } else {
        _animationController.forward();
      }
    });
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



