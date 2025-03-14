import 'package:bible_game/shared/utils/device_info.dart';
import 'package:bible_game_api/model/leaderboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bible_game/features/leader_board/widget/leaderboard_card.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import 'package:bible_game/shared/utils/country_iso_3.dart';
import 'package:bible_game/shared/widgets/green_button.dart';
import 'package:bible_game/shared/widgets/screen_app_bar.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/widgets/tab_button.dart';
import '../../../shared/constants/colors.dart';
import 'package:countries_world_map/countries_world_map.dart';
import 'package:intl/intl.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../home/widget/modals/create_profile_modal.dart';
import '../../home/widget/modals/login_modal.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({super.key});

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  bool _selectedGlobal = true;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollControllerTwo = ScrollController();
  late int userPosition = 0;
  final DeviceInfoService _deviceInfoService = DeviceInfoService();
  Map<String, String> _deviceInfo = {};


  Future<void> _loadDeviceInfo() async {
    final info = await _deviceInfoService.getDeviceInfo();
    setState(() {
      _deviceInfo = info;
    });
    print('device info, ${_deviceInfo}');
  }

  @override
  void initState() {
    super.initState();
    getBasicOsInfo();
    _loadDeviceInfo();
    final userState = BlocProvider.of<AuthenticationBloc>(context).state;
    if (userState.user.id != 0) {
      BlocProvider.of<UserBloc>(context).add(FetchGlobalLeaderBoard(true));
      // BlocProvider.of<UserBloc>(context).add(FetchCountryLeaderBoard());
    } else {
      BlocProvider.of<UserBloc>(context).add(FetchGlobalLeaderBoard(false));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollControllerTwo.dispose();
    super.dispose();
  }

  void scrollToTop() {
    _scrollController.jumpTo(0.0);
  }

  String getCurrentMonthFormatted() {
    return DateFormat.MMMM().format(DateTime.now());
  }

  void scrollToCountryTop() {
    _scrollControllerTwo.jumpTo(0.0);
  }

  void scrollToUserCountryPosition() {
    final double maxScrollExtent =
        _scrollControllerTwo.position.maxScrollExtent;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double userOffset = (userPosition - 1) * 80.h;

    double targetOffset = userOffset;
    if (userOffset + screenHeight > maxScrollExtent) {
      targetOffset = maxScrollExtent;
    }

    _scrollControllerTwo.jumpTo(targetOffset);
  }

  scrollToUserPosition() {
    final double maxScrollExtent = _scrollController.position.maxScrollExtent;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double userOffset = (userPosition - 1) * 80.h;

    double targetOffset = userOffset;
    if (userOffset + screenHeight > maxScrollExtent) {
      targetOffset = maxScrollExtent;
    }

    _scrollController.jumpTo(targetOffset);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final double usableHeight = screenHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
    final soundManager = context.read<SettingsBloc>().soundManager;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: AppColors.primaryColorShade, // Status bar color
      ),
      backgroundColor: AppColors.primaryColor,
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (_selectedGlobal) {
            final board = state.globalLeaderboard;
            final userId =
                BlocProvider.of<AuthenticationBloc>(context).state.user.id;
            final index = board?.indexWhere((board) => board.userId == userId);
            userPosition = index!;
          } else {
            final board = state.countryLeaderboard;
            final userId =
                BlocProvider.of<AuthenticationBloc>(context).state.user.id;
            final index = board?.indexWhere((board) => board.userId == userId);
            userPosition = index!;
          }

          return SafeArea(
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ProductImageRoutes.patternTwoBg),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    ScreenAppBar(
                      widgets: [
                        Center(
                          child: StrokeText(
                            text: 'Leaderboard',
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w900,
                            ),
                            strokeColor: AppColors.titleDropShadowColor,
                            strokeWidth: 6,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Center(
                          child: StrokeText(
                            text: '( ${getCurrentMonthFormatted()} )',
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w900,
                            ),
                            strokeColor: AppColors.titleDropShadowColor,
                            strokeWidth: 6,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Container(
                        height: 72.h,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        decoration: BoxDecoration(
                          color: Color(0xFF898C6FE),
                          borderRadius: BorderRadius.circular(4.r),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF364865),
                              offset: Offset(0, 5),
                              blurRadius: 0,
                              spreadRadius: -2,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TabButton(
                              width: 164,
                              buttonText: 'Global',
                              buttonSelected: _selectedGlobal,
                              onTap: () {
                                if (context
                                    .read<AuthenticationBloc>()
                                    .state
                                    .user
                                    .id !=
                                    0) {
                                  BlocProvider.of<UserBloc>(context).add(FetchGlobalLeaderBoard(true));

                                }
                                setState(() {
                                  _selectedGlobal = true;
                                });
                              },
                            ),
                            TabButton(
                              width: 164,
                              buttonText: context
                                          .read<AuthenticationBloc>()
                                          .state
                                          .user
                                          .id !=
                                      0
                                  ? context
                                      .read<AuthenticationBloc>()
                                      .state
                                      .user
                                      .country
                                  : 'Your country',
                              buttonSelected: !_selectedGlobal,
                              onTap: () {
                                if (context
                                        .read<AuthenticationBloc>()
                                        .state
                                        .user
                                        .id !=
                                    0) {
                                  BlocProvider.of<UserBloc>(context)
                                      .add(FetchCountryLeaderBoard());
                                }
                                setState(() {
                                  _selectedGlobal = false;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    _selectedGlobal
                        ? state.isFetchingGlobalLeaderboard
                            ? Container(
                                margin: EdgeInsets.only(top: 40.h),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : SizedBox(
                                height: usableHeight -
                                    (100.h + 20.h + 72.h + 5.h + 120.h),
                                child: Stack(
                                  children: [
                                    ListView.builder(
                                      controller: _scrollController,
                                      padding: EdgeInsets.zero,
                                      itemCount:
                                          state.globalLeaderboard!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return LeaderboardCard(
                                          userId: state
                                              .globalLeaderboard![index].userId,
                                          position: state
                                              .globalLeaderboard![index]
                                              .position,
                                          userName: state
                                              .globalLeaderboard![index].name,
                                          userBadge:
                                              ProductImageRoutes.defaultBadge,
                                          userLevel: state
                                              .globalLeaderboard![index].status,
                                          noOfCoins: state
                                              .globalLeaderboard![index]
                                              .walletBalance,
                                          countryName: state
                                              .globalLeaderboard![index]
                                              .country,
                                        );
                                      },
                                    ),
                                    context
                                                .read<AuthenticationBloc>()
                                                .state
                                                .user
                                                .id !=
                                            0
                                        ? Align(
                                            alignment: Alignment.topCenter,
                                            child: buildLeaderboardNavigator(
                                                scrollToTop, 'Top'),
                                          )
                                        : SizedBox(),
                                    context
                                                .read<AuthenticationBloc>()
                                                .state
                                                .user
                                                .id !=
                                            0
                                        ? Positioned(
                                            bottom: 60,
                                            left: 155,
                                            right: 155,
                                            child: buildLeaderboardNavigator(
                                                scrollToUserPosition, 'You'),
                                          )
                                        : SizedBox(),
                                  ],
                                ),
                              )
                        : state.isFetchingCountryLeaderboard
                            ? Container(
                                margin: EdgeInsets.only(top: 40.h),
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              )
                            : SizedBox(
                                height: usableHeight -
                                    (100.h + 20.h + 72.h + 5.h + 120.h),
                                child: context
                                            .read<AuthenticationBloc>()
                                            .state
                                            .user
                                            .id !=
                                        0
                                    ? Stack(
                                        children: [
                                          ListView.builder(
                                            controller: _scrollControllerTwo,
                                            padding: EdgeInsets.zero,
                                            itemCount: state
                                                .countryLeaderboard!.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return LeaderboardCard(
                                                userId: state
                                                    .countryLeaderboard![index]
                                                    .userId,
                                                position: state
                                                    .countryLeaderboard![index]
                                                    .position,
                                                userName: state
                                                    .countryLeaderboard![index]
                                                    .name,
                                                userBadge: ProductImageRoutes
                                                    .defaultBadge,
                                                userLevel: state
                                                    .countryLeaderboard![index]
                                                    .status,
                                                noOfCoins: state
                                                    .countryLeaderboard![index]
                                                    .walletBalance,
                                                countryName: context
                                                    .read<AuthenticationBloc>()
                                                    .state
                                                    .user
                                                    .country,
                                              );
                                            },
                                          ),
                                          Align(
                                            alignment: Alignment.topCenter,
                                            child: buildLeaderboardNavigator(
                                                scrollToCountryTop, 'Top'),
                                          ),
                                          Positioned(
                                            bottom: 60,
                                            left: 155,
                                            right: 155,
                                            child: buildLeaderboardNavigator(
                                                scrollToUserCountryPosition,
                                                'You'),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          SizedBox(
                                            height: 40.h,
                                          ),
                                          GreenButton(
                                            onTap: () {
                                              soundManager.playClickSound();
                                              showLoginModal(context);
                                            },
                                            buttonIsLoading: false,
                                            width: 350.w,
                                            customWidget: Center(
                                              child: StrokeText(
                                                text: 'Log In',
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                strokeColor:
                                                    const Color(0xFF272D39),
                                                strokeWidth: 3,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 30.h,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              soundManager.playClickSound();
                                              showCreateProfileModal(context);
                                            },
                                            child: Container(
                                              width: 350.w,
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 15.h),
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                image: AssetImage(
                                                    ProductImageRoutes
                                                        .newBlueBtnBg),
                                                fit: BoxFit.fill,
                                              )),
                                              child: Center(
                                                child: StrokeText(
                                                  text: 'Create Profile',
                                                  textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  strokeColor:
                                                      const Color(0xFF272D39),
                                                  strokeWidth: 3,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                              ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  GestureDetector buildLeaderboardNavigator(VoidCallback onTap, text) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: 28.h,
          width: 73.w,
          decoration: BoxDecoration(
              color: Color(0xFF363636CC),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Color(0xFF949494))),
          child: Center(
            child: Text(
              text,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          )),
    );
  }
}
