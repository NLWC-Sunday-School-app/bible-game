import 'package:bible_game/features/fantasy_league/widget/modal/edit_league_modal.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/widgets/custom_toast.dart';
import 'package:bible_game_api/utils/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/features/fantasy_league/widget/modal/fantasy_bible_league_guide.dart';
import 'package:intl/intl.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/constants/image_routes.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../shared/widgets/screen_app_bar.dart';
import '../bloc/fantasy_league_bloc.dart';
import '../widget/league_player_card.dart';

class MyLeagueScreen extends StatefulWidget {
  const MyLeagueScreen({super.key});

  @override
  State<MyLeagueScreen> createState() => _MyLeagueScreenState();
}

class _MyLeagueScreenState extends State<MyLeagueScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    BlocProvider.of<FantasyLeagueBloc>(context)
        .add(ViewLeagueData(arguments['leagueId']));
  }

  void _copyText(BuildContext context, String leagueGoal, String leagueName,
      String leagueDuration, String leagueCode) {
    showCustomToast(context, 'Copied');
    final weeks = int.parse(leagueDuration) > 1 ? 'weeks' : 'week';
    final goal = NumberFormat('#,##0').format(int.parse(leagueGoal));
    Clipboard.setData(ClipboardData(
      text:
          'Can you get $goal coins before me in $leagueDuration $weeks? Join my League ($leagueName) on the Bible game app using this code $leagueCode \n\nhttps://linktr.ee/biblegame_',
    ));
  }

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    final userId =
        BlocProvider.of<AuthenticationBloc>(context).state.user.id;
    final screenHeight = MediaQuery.of(context).size.height;
    final usableHeight = screenHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: AppColors.primaryColorShade,
      ),
      backgroundColor: AppColors.deepBlueAlt,
      body: BlocConsumer<FantasyLeagueBloc, FantasyLeagueState>(
        listener: (context, state) {
          if (state.hasLeftLeague) {
            Navigator.pop(context);
            showCustomToast(
              context,
              userId == state.leagueData.league.adminId
                  ? 'Ended successfully'
                  : 'Left successfully',
            );
          }
          if (state.failedToLeave) {
            ApiException.showSnackBar(context);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: screenHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ProductImageRoutes.patternTwoBg),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    _LeagueAppBar(soundManager: soundManager),
                    SizedBox(height: 20.h),
                    if (state.isFetchingLeagueData)
                      Container(
                        margin: EdgeInsets.only(top: 80.h),
                        child: const CircularProgressIndicator(
                            color: Colors.white),
                      )
                    else ...[
                      _LeagueInfoCard(
                        state: state,
                        userId: userId,
                        soundManager: soundManager,
                        onCopyCode: _copyText,
                      ),
                      SizedBox(height: 10.h),
                      _LeagueLeaderboard(
                        state: state,
                        usableHeight: usableHeight,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _LeagueAppBar extends StatelessWidget {
  const _LeagueAppBar({required this.soundManager});

  final dynamic soundManager;

  @override
  Widget build(BuildContext context) {
    return ScreenAppBar(
      height: 80.h,
      widgets: [
        Row(
          children: [
            InkWell(
              onTap: () {
                soundManager.playClickSound();
                Navigator.pop(context);
              },
              child: Image.asset(IconImageRoutes.arrowCircleBack, width: 44.w),
            ),
            Expanded(
              child: Center(
                child: StrokeText(
                  text: 'My leagues',
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
              onTap: () {
                soundManager.playClickSound();
                showFantasyBibleLeagueGuide(context);
              },
              child: Image.asset(IconImageRoutes.infoCircle, width: 44.w),
            ),
          ],
        ),
        SizedBox(height: 20.h),
      ],
    );
  }
}

class _LeagueInfoCard extends StatelessWidget {
  const _LeagueInfoCard({
    required this.state,
    required this.userId,
    required this.soundManager,
    required this.onCopyCode,
  });

  final FantasyLeagueState state;
  final int userId;
  final dynamic soundManager;
  final void Function(BuildContext, String, String, String, String) onCopyCode;

  bool get _isEnded => state.leagueData.league.status == 'ENDED';
  bool get _isAdmin => userId == state.leagueData.league.adminId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: 222.h,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          gradient: LinearGradient(
            colors: [const Color(0xFFF0FFFE), AppColors.mintBackground],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            _LeagueHeaderControls(
              state: state,
              userId: userId,
              isEnded: _isEnded,
              isAdmin: _isAdmin,
              soundManager: soundManager,
            ),
            SizedBox(height: 10.h),
            StrokeText(
              text: state.leagueData.league.name,
              textStyle: TextStyle(
                color: AppColors.deepBlue,
                fontSize: 22.sp,
                fontWeight: FontWeight.w900,
              ),
              strokeColor: Colors.black.withValues(alpha: 0.25),
              strokeWidth: 1,
            ),
            SizedBox(height: 10.h),
            _isEnded
                ? _LeagueEndedStatus(state: state)
                : _LeagueActiveStatus(
                    state: state,
                    soundManager: soundManager,
                    onCopyCode: onCopyCode,
                  ),
          ],
        ),
      ),
    );
  }
}

class _LeagueHeaderControls extends StatelessWidget {
  const _LeagueHeaderControls({
    required this.state,
    required this.userId,
    required this.isEnded,
    required this.isAdmin,
    required this.soundManager,
  });

  final FantasyLeagueState state;
  final int userId;
  final bool isEnded;
  final bool isAdmin;
  final dynamic soundManager;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isEnded)
          GestureDetector(
            onTap: () {
              soundManager.playClickSound();
              if (isAdmin) {
                context.read<FantasyLeagueBloc>().add(EndFantasyLeague(
                      state.leagueData.league.name,
                      state.leagueData.league.isOpen,
                      state.leagueData.league.id,
                    ));
              } else {
                context
                    .read<FantasyLeagueBloc>()
                    .add(LeaveLeague(state.leagueData.league.id));
              }
            },
            child: Container(
              width: 70.w,
              padding:
                  EdgeInsets.symmetric(horizontal: 5.w, vertical: 8.h),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.leaveBtnBg),
                  fit: BoxFit.fill,
                ),
              ),
              child: Center(
                child: state.isLeavingLeague
                    ? SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: const CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        isAdmin ? 'End' : 'Leave',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 14.sp,
                        ),
                      ),
              ),
            ),
          ),
        const Spacer(),
        FadeInImage.assetNetwork(
          placeholder: ProductImageRoutes.defaultAvatar,
          image: state.leagueData.league.icon,
          width: 65.w,
          height: 65.h,
        ),
        const Spacer(),
        if (!isEnded && isAdmin)
          GestureDetector(
            onTap: () {
              soundManager.playClickSound();
              showEditLeagueModal(context, state.leagueData);
            },
            child: Container(
              width: 38.w,
              height: 32.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.inviteBtnBg),
                  fit: BoxFit.fill,
                ),
              ),
              child: Center(
                child: Icon(Icons.settings, size: 20.w, color: Colors.white),
              ),
            ),
          )
        else if (!isEnded)
          const Spacer(),
      ],
    );
  }
}

class _LeagueEndedStatus extends StatelessWidget {
  const _LeagueEndedStatus({required this.state});

  final FantasyLeagueState state;

  @override
  Widget build(BuildContext context) {
    final membersLimit = context
        .read<SettingsBloc>()
        .state
        .gamePlaySettings['league_members_limit'];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Container(
        height: 58.h,
        padding:
            EdgeInsets.symmetric(horizontal: 25.w, vertical: 19.5.h),
        decoration: _infoBoxDecoration,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _StatRow(
              label: 'Members:',
              value:
                  ' ${state.leagueData.metrics.membersCount}/$membersLimit',
            ),
            _StatRow(label: 'Weeks left: ', value: 'ENDED'),
          ],
        ),
      ),
    );
  }
}

class _LeagueActiveStatus extends StatelessWidget {
  const _LeagueActiveStatus({
    required this.state,
    required this.soundManager,
    required this.onCopyCode,
  });

  final FantasyLeagueState state;
  final dynamic soundManager;
  final void Function(BuildContext, String, String, String, String) onCopyCode;

  @override
  Widget build(BuildContext context) {
    final membersLimit = context
        .read<SettingsBloc>()
        .state
        .gamePlaySettings['league_members_limit'];
    final league = state.leagueData.league;
    final metrics = state.leagueData.metrics;
    final typeColor = league.status.toLowerCase() == 'active' && league.isOpen
        ? const Color(0xFF1A7E1C)
        : Colors.red;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: _infoBoxDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatRow(
                  label: 'Members:',
                  value: ' ${metrics.membersCount}/$membersLimit',
                ),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: () {
                    soundManager.playClickSound();
                    onCopyCode(
                      context,
                      metrics.coinTrack.split('/').last,
                      league.name,
                      metrics.weeksLeft.split('/').last,
                      league.code,
                    );
                  },
                  child: Row(
                    children: [
                      _StatRow(
                          label: 'League code:',
                          value: ' ${league.code}'),
                      SizedBox(width: 4.w),
                      Image.asset(IconImageRoutes.blueCopyIcon,
                          width: 16.w),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatRow(
                    label: 'Weeks left: ', value: metrics.weeksLeft),
                SizedBox(height: 10.h),
                _StatRow(
                  label: 'Type:',
                  value: league.isOpen ? ' ● Open' : ' ● Closed',
                  valueColor: typeColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LeagueLeaderboard extends StatelessWidget {
  const _LeagueLeaderboard({
    required this.state,
    required this.usableHeight,
  });

  final FantasyLeagueState state;
  final double usableHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: usableHeight - (80.h + 230.h + 20.h),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        itemCount: state.leagueData.leaderBoard.length,
        itemBuilder: (context, index) {
          final entry = state.leagueData.leaderBoard[index];
          return LeaguePlayerCard(
            username: entry.username,
            userId: entry.userId,
            points: entry.points,
            position: entry.position.toString(),
            goal: state.leagueData.league.goal.toString(),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared helpers
// ---------------------------------------------------------------------------

/// Reusable label + value RichText used throughout the league info card.
class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: label,
        style: TextStyle(
          fontFamily: 'Mikado',
          color: const Color(0xFF4A5240),
          fontWeight: FontWeight.w700,
          fontSize: 14.sp,
        ),
        children: [
          TextSpan(
            text: value,
            style: TextStyle(
              fontFamily: 'Mikado',
              fontWeight: FontWeight.w900,
              color: valueColor ?? const Color(0xFF01200F),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}

const _infoBoxDecoration = BoxDecoration(
  color: Color(0xFFD7EEED),
  border: Border.fromBorderSide(BorderSide(color: Color(0xFFB9BDBD))),
  borderRadius: BorderRadius.all(Radius.circular(5)),
  boxShadow: [
    BoxShadow(
      color: Color(0x4D9E9E9E),
      spreadRadius: 1,
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ],
);
