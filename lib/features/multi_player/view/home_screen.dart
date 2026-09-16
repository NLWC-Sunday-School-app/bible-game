import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/navigation/cubit/navigation_cubit.dart';
import 'package:bible_game/features/arcade/cubit/arcade_tab_cubit.dart';
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

/// Route-level multiplayer screen: app bar + back button around
/// [MultiplayerHomeBody].
///
/// The arcade's Multiplayer tab renders [MultiplayerHomeBody] directly, so the
/// chrome lives here rather than in the body itself.
class MultiplayerHomeScreen extends StatelessWidget {
  const MultiplayerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                        context.read<ArcadeTabCubit>().showMultiplayer();
                        context.read<NavigationCubit>().selectTab(3);
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
            const Expanded(child: MultiplayerHomeBody()),
          ],
        ),
      )
    );
  }
}

/// The multiplayer landing content: create, join, and pending game requests.
///
/// Carries no app bar or background of its own so it can be embedded in the
/// arcade's Multiplayer tab, which supplies both.
class MultiplayerHomeBody extends StatefulWidget {
  const MultiplayerHomeBody({super.key, this.bottomSpacing, this.maxContentWidth});

  /// Trailing space under the game-requests card. The full-screen route needs
  /// room to clear the home indicator; inside the arcade tab the bottom nav
  /// already provides it, so that caller passes a smaller value.
  final double? bottomSpacing;

  /// Caps the content width. Left null on phones, where full width is right;
  /// tablets pass a value so the cards do not stretch into wide banners with
  /// the text stranded on the left edge.
  final double? maxContentWidth;

  @override
  State<MultiplayerHomeBody> createState() => _MultiplayerHomeBodyState();
}

class _MultiplayerHomeBodyState extends State<MultiplayerHomeBody> {
  late MultiplayerBloc _multiplayerBloc;

  @override
  void initState() {
    super.initState();
    _multiplayerBloc = context.read<MultiplayerBloc>();
    _multiplayerBloc.add(const StartPolling());
  }

  @override
  void dispose() {
    // Polling is session-scoped now -- stopping it here would switch off invite
    // banners everywhere else in the app the moment this tab was left.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isConstrained = widget.maxContentWidth != null;
    final column = Column(
      mainAxisSize: isConstrained ? MainAxisSize.min : MainAxisSize.max,
      children: [
        SizedBox(
          height: 16.h,
        ),
        GamePlayCard(
          onTap: (){
            BlocProvider.of<MultiplayerBloc>(context).add(CreateGameRoom());
            Navigator.pushNamed(context,
                AppRoutes.groupGameCategory,
                arguments: {
                  'selectedCategory': 'Group Game'
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
        isConstrained ? SizedBox(height: 48.h) : const Spacer(),
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
          height: widget.bottomSpacing ?? 100.h,
        )
      ],
    );

    if (!isConstrained) return column;
    return Center(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: widget.maxContentWidth!),
          child: column,
        ),
      ),
    );
  }
}
