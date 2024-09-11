import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:the_bible_game/features/fantasy_league/bloc/fantasy_league_bloc.dart';
import 'package:the_bible_game/features/fantasy_league/view/home_screen.dart';
import 'package:the_bible_game/features/fantasy_league/widget/league_card.dart';
import 'package:the_bible_game/features/fantasy_league/widget/modal/open_leagues.dart';
import 'package:the_bible_game/features/quick_game/widget/search_box.dart';
import 'package:the_bible_game/shared/constants/app_routes.dart';
import 'package:the_bible_game/shared/widgets/blue_button.dart';
import 'package:the_bible_game/shared/widgets/green_button.dart';

import '../../../shared/constants/image_routes.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';

class JoinLeague extends StatefulWidget {
  const JoinLeague({super.key, required this.screenHeight});

  final double screenHeight;

  @override
  State<JoinLeague> createState() => _JoinLeagueState();
}

class _JoinLeagueState extends State<JoinLeague> {
  String searchText = "";

  void handleSearchTextChanged(String text) {
    setState(() {
      searchText = text;
    });
    if (searchText.isEmpty) {
      BlocProvider.of<FantasyLeagueBloc>(context).add(FetchOpenLeagues());
    }
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FantasyLeagueBloc>(context).add(FetchOpenLeagues());
  }

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    return BlocBuilder<FantasyLeagueBloc, FantasyLeagueState>(
      builder: (context, state) {
        return Container(
          child: Column(
            children: [
              SearchBox(
                onTap: () {
                  soundManager.playClickSound();
                  if (searchText.isNotEmpty) {
                    context
                        .read<FantasyLeagueBloc>()
                        .add(FindLeague(searchText));
                  }
                },
                isActive: searchText.isNotEmpty,
                onTextChanged: handleSearchTextChanged,
                hintPlaceholder: 'Search with code/name',
              ),
              SizedBox(
                height: 40.h,
              ),
              Row(
                children: [
                  Expanded(
                      child: Divider(
                    color: Color(0xFF3E5C7F),
                    thickness: 2,
                    endIndent: 15,
                  )),
                  StrokeText(
                    text: 'OPEN FANTASY BIBLE LEAGUES',
                    textStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    strokeColor: const Color(0xFF272D39),
                    strokeWidth: 1,
                  ),
                  Expanded(
                      child: Divider(
                    indent: 15,
                    color: Color(0xFF3E5C7F),
                    thickness: 2,
                  )),
                ],
              ),
              state.isFetchingOpenLeagues
                  ? Container(
                      margin: EdgeInsets.only(top: 40.h),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : state.openLeagues.isNotEmpty
                      ? SizedBox(
                          height: widget.screenHeight -
                              (150.h + 20.h + 72.h + 60.h + 60.h + 140.h),
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: state.openLeagues.length,
                              itemBuilder: (BuildContext context, int index) {
                                return LeagueCard(
                                  onTap: () {
                                    soundManager.playClickSound();
                                    showOpenLeagueModal(
                                        context, state.openLeagues[index].id);
                                  },
                                  id: state.openLeagues[index].id,
                                  name: state.openLeagues[index].name,
                                  playerCount:
                                      state.openLeagues[index].playerCount,
                                  icon: state.openLeagues[index].icon,
                                );
                              }),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Container(
                            width: double.infinity,
                            height: widget.screenHeight -
                                (150.h + 20.h + 72.h + 60.h + 60.h + 170.h),
                            margin: EdgeInsets.only(top: 20.h, bottom: 10.h),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(color: Color(0xFF032956)),
                              color: Color(0xFF093D7B),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 30.h,
                                ),
                                Image.asset(
                                  ProductImageRoutes.broLukeInfo,
                                  width: 65.w,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  'There’s no open league; \nStart one, play with your friends!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18.sp,
                                      color: Colors.white),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                GreenButton(
                                  buttonIsLoading: false,
                                  width: 260.w,
                                  onTap: () {
                                    soundManager.playClickSound();
                                    Navigator.pushNamed(context, AppRoutes.fantasyBibleLeagueHomeScreen);
                                    // Navigator.pushNamed(context,
                                    //     AppRoutes.fantasyBibleLeagueHomeScreen);
                                  },
                                  customWidget: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      StrokeText(
                                        text: 'Create a league',
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                        strokeColor: const Color(0xFF272D39),
                                        strokeWidth: 1,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
            ],
          ),
        );
      },
    );
  }
}
