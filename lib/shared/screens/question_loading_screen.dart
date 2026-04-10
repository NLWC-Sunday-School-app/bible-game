import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:bible_game/features/four_scriptures/widget/modal/quick_tips_modal.dart';
import 'package:bible_game/features/global_challenge/bloc/global_challenge_bloc.dart';
import 'package:bible_game/features/global_challenge/widget/modal/quick_tips_modal.dart';
import 'package:bible_game/features/pilgrim_progress/bloc/pilgrim_progress_bloc.dart';
import 'package:bible_game/features/pilgrim_progress/widget/modal/quick_tips_modal.dart';
import 'package:bible_game/features/who_is_who/bloc/who_is_who_bloc.dart';
import 'package:bible_game/features/who_is_who/widget/modal/quick_tips_modal.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';

import '../../features/four_scriptures/bloc/four_scriptures_one_word_bloc.dart';
import '../../features/quick_game/bloc/quick_game_bloc.dart';
import '../../features/quick_game/widget/modal/quick_tips_modal.dart';
import '../constants/app_routes.dart';

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
      final hasTimer = arguments['hasTimer'];
      final selectedLevel = arguments['selectedLevel'];
      if (gameType == 'quick_game') {
        context.read<QuickGameBloc>().add(FetchQuickGameQuestions());
        context.read<QuickGameBloc>().stream.listen((state) {
          if (state.quickGameQuestionLoaded!) {
            Timer(Duration(seconds: 5), () {
              if (mounted && !_isModalShown) {
                showQuickGameTipsModal(context, hasTimer);
                _isModalShown = true;
              }
            });
          }
        });
      } else if (gameType == 'pilgrim_progress') {
        context
            .read<PilgrimProgressBloc>()
            .add(FetchPilgrimProgressQuestions(selectedLevel));
        context.read<PilgrimProgressBloc>().stream.listen((state) {
          if (state.pilgrimProgressQuestionLoaded!) {
            Timer(Duration(seconds: 3), () {
              if (mounted && !_isModalShown) {
                showPilgrimProgressTipsModal(context);
                _isModalShown = true;
              }
            });
          }
        });} else if (gameType == 'wiw_game') {
        context.read<WhoIsWhoBloc>().add(FetchGameQuestions());
        context.read<WhoIsWhoBloc>().stream.listen((state) {
          if (state.wiwGameQuestionsLoaded) {
            Timer(Duration(seconds: 3), () {
              if (mounted && !_isModalShown) {
                showWhoIsWhoTipsModal(context);
                _isModalShown = true;
              }
            });
          }
        });
      } else if (gameType == 'four_scriptures_game') {
       context.read<FourScripturesOneWordBloc>().add(FetchQuestions());
       context.read<FourScripturesOneWordBloc>().add(FetchTotalNoOfQuestions());
       context.read<FourScripturesOneWordBloc>().stream.listen((state){
         if(state.gameQuestionsLoaded!){
           Timer(Duration(seconds: 3), () {
             if(mounted && !_isModalShown){
               showFourScripturesTipsModal(context);
               _isModalShown = true;
             }
           });
         }
       });

      }else {
        context.read<GlobalChallengeBloc>().add(FetchGlobalChallengeQuestions(gameType));
        context.read<GlobalChallengeBloc>().stream.listen((state){
          if(state.globalGameQuestionLoaded!){
             Timer(Duration(seconds: 3), (){
               if(mounted && !_isModalShown){
                 showGlobalChallengeTipsModal(context);
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
            fit: BoxFit.fill,
          ),
        ),
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return Align(
              alignment: Alignment.center,
              child: CarouselSlider.builder(
                itemCount: state.adContent!.length,
                itemBuilder:
                    (BuildContext context, int index, int pageViewIndex) {
                  return Container(
                    width: 300.w,
                    height: 300.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.white, width: 2.w),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(state.adContent![index].imageUrl),
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 300.h,
                  aspectRatio: 16 / 9,
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
