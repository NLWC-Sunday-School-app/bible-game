import 'package:another_flushbar/flushbar.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:bible_game_api/utils/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/features/fantasy_league/bloc/fantasy_league_bloc.dart';
import 'package:bible_game/features/fantasy_league/view/home_screen.dart';
import 'package:bible_game/features/fantasy_league/widget/league_card.dart';
import 'package:bible_game/features/fantasy_league/widget/modal/open_leagues.dart';
import 'package:bible_game/features/fantasy_league/widget/modal/successfully_joined_league_modal.dart';
import 'package:bible_game/features/quick_game/widget/search_box.dart';
import 'package:bible_game/shared/constants/app_routes.dart';
import 'package:bible_game/shared/widgets/blue_button.dart';
import 'package:bible_game/shared/widgets/green_button.dart';

import '../../../../shared/constants/image_routes.dart';


class JoinLeagueTabletView extends StatefulWidget {
  const JoinLeagueTabletView({super.key, required this.screenHeight, required this.showCreateLeague});

  final double screenHeight;
  final VoidCallback showCreateLeague;

  @override
  State<JoinLeagueTabletView> createState() => _JoinLeagueTabletViewState();
}

class _JoinLeagueTabletViewState extends State<JoinLeagueTabletView> {
  String searchText = "";
  final textController = TextEditingController();

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
    return BlocConsumer<FantasyLeagueBloc, FantasyLeagueState>(
      listener: (context, state) {
        if( state.failedToJoin){
          ApiException.showSnackBar(context);
        }
        if(state.hasJoinedLeague){
          textController.text = '';
          showSuccessfullyJoinedLeagueModal(context);
          Future.delayed(Duration(seconds: 4), (){
            Navigator.pop(context);
          });
        }
      },
      builder: (context, state) {
        return Column(
          children: [
            Text(
              'Input league code',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: Color(0xFFFFFAD3),
              ),
            ),
            SizedBox(
              height: 32.h,
            ),
            SizedBox(
              width: 638.w,
              height: 56.h,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(4.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                    ),
                    BoxShadow(
                      color: Color(0xFFFFFAD3),
                      offset: Offset(0, 1),
                      // spreadRadius: 1.0,
                      blurRadius: 1.0,
                    ),
                  ],
                ),
                child: Center(
                  child: TextField(
                    controller: textController,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0C70DB),
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter league code here',
                      contentPadding: EdgeInsets.symmetric(vertical: 10.h) ,
                      hintStyle: TextStyle(
                          color: Color(0xFF627F8F),
                          fontWeight: FontWeight.w700),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.r),
                        borderSide: const BorderSide(
                            color: Color(0xFFFFFFAD3), width: 0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.r),
                        borderSide: const BorderSide(
                            color: Color(0xFFFFFAD3), width: 0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 24.h,
            ),
            GreenButton(
              buttonIsLoading: state.isLeavingLeague,
              width: 638.w,
              onTap: () {
                soundManager.playClickSound();
                if (textController.text.isNotEmpty) {
                  context
                      .read<FantasyLeagueBloc>()
                      .add(JoinLeagueWithCode(textController.text));
                }
              },
              customWidget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 state.isJoiningLeague ? SizedBox(
                     height: 20.h,
                     width: 20.w,
                     child:
                     CircularProgressIndicator(
                       color: Colors.white,
                       strokeWidth: 2,
                     )) : StrokeText(
                    text: 'Join league',
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
            ),
            SizedBox(
              height: 60.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 61.w,
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
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  strokeColor: const Color(0xFF272D39),
                  strokeWidth: 1,
                ),
                SizedBox(
                  width: 61.w,
                    child: Divider(
                  indent: 15,
                  color: Color(0xFF3E5C7F),
                  thickness: 2,
                )),
              ],
            ),
            SizedBox(
              height: 28.h,
            ),
            state.isFetchingOpenLeagues
                ? Container(
                    margin: EdgeInsets.only(top: 40.h),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                : state.openLeagues.isNotEmpty
                    ? Flexible(
                      child: ListView.builder(
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
                          height: 200.h,
                          margin: EdgeInsets.only(top: 20.h, bottom: 10.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: Color(0xFF032956)),
                            color: Color(0xFF093D7B),
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10.h,
                              ),
                              Image.asset(
                                ProductImageRoutes.broLukeInfo,
                                width: 45.w,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                'There’s no open league; \nStart one, play with your friends!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.sp,
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
                                  widget.showCreateLeague();
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
        );
      },
    );
  }
}
