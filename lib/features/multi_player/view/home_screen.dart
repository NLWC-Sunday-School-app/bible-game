import 'dart:async';

import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_event.dart';
import 'package:flutter/material.dart';
import 'package:bible_game/features/multi_player/widget/game_play_card.dart';
import 'package:bible_game/features/multi_player/widget/game_request_card.dart';
import 'package:bible_game/features/multi_player/widget/modal/game_request_modal.dart';
import 'package:bible_game/features/multi_player/widget/modal/join_gameplay_modal.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../shared/constants/app_routes.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../shared/widgets/screen_app_bar.dart';

class MultiplayerHomeScreen extends StatefulWidget {
  const MultiplayerHomeScreen({super.key});

  @override
  State<MultiplayerHomeScreen> createState() => _MultiplayerHomeScreenState();
}

class _MultiplayerHomeScreenState extends State<MultiplayerHomeScreen> with WidgetsBindingObserver{
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    _startPeriodicCall();
    super.initState();
  }

  void _startPeriodicCall() {
    BlocProvider.of<MultiplayerBloc>(context).add(CountInvite());

    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      print("called");
      BlocProvider.of<MultiplayerBloc>(context).add(CountInvite());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    print("TIMER DISPOSED");// Cancel when widget is disposed
    super.dispose();
  }

  void cancelTimer() {
    _timer?.cancel();
  }


  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    final selectedCategory = arguments['selectedCategory'];
    final soundManager = context.read<SettingsBloc>().soundManager;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: AppColors.primaryColorShade, // Status bar color
      ),
      backgroundColor: Color(0xFF2D6BB6),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ProductImageRoutes.patternTwoBg),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            ScreenAppBar(
              height: 70.h,
              widgets: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        soundManager.playClickSound();
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            AppRoutes.home,
                            (Route)=>false
                        );
                      },
                      child: Image.asset(
                        IconImageRoutes.arrowCircleBack,
                        width: 40.w,
                      ),
                    ),
                    Spacer(),
                    StrokeText(
                      text: 'Multiplayer',
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w900,
                      ),
                      strokeColor: AppColors.titleDropShadowColor,
                      strokeWidth: 6,
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                )
              ],
            ),
            SizedBox(
              height: 16.h,
            ),
            Text(
             selectedCategory,
              style: TextStyle(
                color: Color(0xFFFFFAD3),
                fontSize: 20.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            GamePlayCard(
              onTap: (){
                cancelTimer();
                BlocProvider.of<MultiplayerBloc>(context).add(CreateGameRoom());
                Navigator.pushNamed(context,
                    AppRoutes.groupGameCategory,
                    arguments: {
                      'selectedCategory': selectedCategory
                    }
                );
              },
              title: 'Create a gameplay',
              text: 'Be the host and invite your friends',
              backgroundImage: ProductImageRoutes.createGameCardBg,
              swordImage: ProductImageRoutes.createSword,
            ),
            GamePlayCard(
              onTap: () => showJoinGamePlayModal(context),
              title: 'Join gameplay',
              text: 'Enjoy the thrills with your  friends',
              backgroundImage: ProductImageRoutes.joinGameCardBg,
              swordImage: ProductImageRoutes.joinSword,
            ),
            Spacer(),
            BlocBuilder<MultiplayerBloc, MultiplayerState>(
              builder: (context, state) {
                return GameRequestCard(
                  onTap: (){
                    BlocProvider.of<MultiplayerBloc>(context).add(FetchGameInvites());
                    showGameRequestModal(context);
                    },
                  count: state.inviteCount,
            );
                },
            ),
            SizedBox(
              height: 100.h,
            )
          ],
        ),
      )
    );
  }
}
