import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';
import 'package:the_bible_game/shared/features/user/bloc/user_bloc.dart';

import '../../features/quick_game/bloc/quick_game_bloc.dart';
import '../../features/quick_game/widget/modal/quick_tips_modal.dart';

class QuestionLoadingScreen extends StatefulWidget {
  const QuestionLoadingScreen({super.key});

  @override
  _QuestionLoadingScreenState createState() => _QuestionLoadingScreenState();
}

class _QuestionLoadingScreenState extends State<QuestionLoadingScreen> {
  bool _isModalShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments = (ModalRoute.of(context)?.settings.arguments ??
          <String, dynamic>{}) as Map;
      final gameType = arguments['gameType'];
      if (gameType == 'quick_game') {
        context.read<QuickGameBloc>().add(FetchQuickGameQuestions());
        context.read<QuickGameBloc>().stream.listen((state) {
          if (state.quickGameQuestionLoaded!) {
            Timer(Duration(seconds: 5), () {
              if (mounted && !_isModalShown) {
                showQuickGameTipsModal(context);
                _isModalShown = true;
              }
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: screenHeight,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ProductImageRoutes.questionLoadingBg),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocBuilder<UserBloc, UserState>(
  builder: (context, state) {
    return Align(
          alignment: Alignment.center,
          child: CarouselSlider.builder(
            itemCount: state.adContent!.length,
            itemBuilder: (BuildContext context, int index, int pageViewIndex) {
              return Container(
                width: 300.w,
                height: 300.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Colors.white, width: 2.w),
                  image: DecorationImage(
                    image: NetworkImage(state.adContent![index].imageUrl),
                    fit: BoxFit.fill,
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: 300.h,
              aspectRatio: 16/9,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              autoPlayCurve: Curves.easeIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              scrollDirection: Axis.horizontal,
            ),
          ),
        );
  },
),
      ),
    );
  }
}
