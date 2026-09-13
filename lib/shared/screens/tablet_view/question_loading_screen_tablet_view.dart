import 'package:bible_game/features/multi_player/widget/modal/multiplayer_tip_modal.dart';
import 'dart:async';
import 'package:bible_game/features/four_scriptures/widget/tablet_view_modal/quick_tips_modal_tablet_view.dart';
import 'package:bible_game/features/global_challenge/widget/tablet_view_modal/quick_tips_modal_tablet_view.dart';
import 'package:bible_game/features/pilgrim_progress/widget/tablet_view_modal/quick_tips_modal_tablet_view.dart';
import 'package:bible_game/features/quick_game/bloc/quick_game_bloc.dart';
import 'package:bible_game/features/quick_game/widget/tablet_view_modal/quick_tips_modal_tablet_view.dart';
import 'package:bible_game/features/who_is_who/widget/tablet_view_modal/quick_tips_modal_tablet_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/features/global_challenge/bloc/global_challenge_bloc.dart';
import 'package:bible_game/features/pilgrim_progress/bloc/pilgrim_progress_bloc.dart';
import 'package:bible_game/features/who_is_who/bloc/who_is_who_bloc.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/features/connectivity/bloc/connectivity_bloc.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:stroke_text/stroke_text.dart';
import '../../../features/four_scriptures/bloc/four_scriptures_one_word_bloc.dart';

class QuestionLoadingScreenTabletView extends StatefulWidget {
  const QuestionLoadingScreenTabletView({super.key});

  @override
  _QuestionLoadingScreenTabletViewState createState() => _QuestionLoadingScreenTabletViewState();
}

class _QuestionLoadingScreenTabletViewState extends State<QuestionLoadingScreenTabletView> {
  bool _isModalShown = false;
  bool _isOfflineDialogShown = false;

  void _showOfflineDialog() {
    if (_isOfflineDialogShown || !mounted) return;
    _isOfflineDialogShown = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: const Color(0xFFFFD400), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off_rounded, color: const Color(0xFFFFD400), size: 56.w),
              SizedBox(height: 16.h),
              StrokeText(
                text: 'You are offline',
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                ),
                strokeColor: const Color(0xFF673125),
                strokeWidth: 4,
              ),
              SizedBox(height: 12.h),
              Text(
                'Please check your internet connection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD400),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Center(
                    child: Text(
                      'Go Back',
                      style: TextStyle(
                        color: const Color(0xFF1A1A2E),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((_) => _isOfflineDialogShown = false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isOnline = context.read<ConnectivityBloc>().state.isOnline;
      if (!isOnline) {
        _showOfflineDialog();
        return;
      }

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
                showQuickGameTipsModalTabletView(context, hasTimer);
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
                showPilgrimProgressTipsModalTabletView(context);
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
                showWhoIsWhoTipsModalTabletView(context);
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
               showFourScripturesTipsModalTabletView(context);
               _isModalShown = true;
             }
           });
         }
       });

      }else if(gameType == "Lightning Mode" || gameType == "First to X" ||
          gameType == "Time-based Mode" || gameType == "Survival Mode"){
        // Multiplayer questions arrive over the websocket with the
        // GAME_STARTED frame, so there is nothing to fetch here -- only the
        // Quick Tips to show, which then routes to the mode's own screen.
        // Without this branch these game modes fell through to the Global
        // Challenge fetch below and the player was stranded.
        Timer(Duration(seconds: 3), () {
          if(mounted && !_isModalShown){
            showMultiplayerTipsModal(context, gameMode: gameType);
            _isModalShown = true;
          }
        });
      }else {
        context.read<GlobalChallengeBloc>().add(FetchGlobalChallengeQuestions(gameType));
        context.read<GlobalChallengeBloc>().stream.listen((state){
          if(state.globalGameQuestionLoaded!){
             Timer(Duration(seconds: 3), (){
               if(mounted && !_isModalShown){
                 showGlobalChallengeTipsModalTabletView(context);
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
      body: BlocListener<ConnectivityBloc, ConnectivityState>(
        listenWhen: (prev, curr) => prev.isOnline && !curr.isOnline,
        listener: (context, state) {
          _showOfflineDialog();
        },
        child: Container(
        height: screenHeight,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ProductImageRoutes.questionLoadingBgTabletView),
            fit: BoxFit.fill,
          ),
        ),
        child: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            return Align(
              alignment: Alignment.center,
              child: CarouselSlider.builder(
                itemCount: state.adContent?.length ?? 0,
                itemBuilder:
                    (BuildContext context, int index, int pageViewIndex) {
                  return Container(
                    width: 300.w,
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
                  height: 400.h,
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
      ),
    );
  }
}
