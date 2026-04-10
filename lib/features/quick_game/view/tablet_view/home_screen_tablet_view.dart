import 'package:another_flushbar/flushbar.dart';
import 'package:bible_game/features/quick_game/widget/tablet_view_modal/use_timer_modal_tablet_view.dart';
import 'package:bible_game/features/quick_game/widget/tablet_view_widget/search_box_tablet_view.dart';
import 'package:bible_game/features/quick_game/widget/tablet_view_widget/selected_topic_pill_tablet_view.dart';
import 'package:bible_game/features/quick_game/widget/tablet_view_widget/topic_tag_tablet_view.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/widgets/green_button.dart';
import 'package:bible_game/shared/widgets/tablet_view_widget/blue_button_tablet_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bible_game/features/quick_game/bloc/quick_game_bloc.dart';
import 'package:bible_game/features/quick_game/widget/modal/use_timer_modal.dart';
import 'package:bible_game/features/quick_game/widget/search_box.dart';
import 'package:bible_game/features/quick_game/widget/selected_topic_pill.dart';
import 'package:bible_game/features/quick_game/widget/topic_tag.dart';
import 'package:bible_game/shared/constants/app_routes.dart';
import 'package:bible_game/shared/constants/colors.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/shared/widgets/blue_button.dart';
import 'package:bible_game/shared/widgets/screen_app_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/features/settings/bloc/settings_bloc.dart';

class QuickGameHomeScreenTabletView extends StatefulWidget {
  const QuickGameHomeScreenTabletView({super.key});

  @override
  State<QuickGameHomeScreenTabletView> createState() => _QuickGameHomeScreenTabletViewState();
}

class _QuickGameHomeScreenTabletViewState extends State<QuickGameHomeScreenTabletView> {
  final GlobalKey _key = GlobalKey();
  double? searchBoxHeight;
  QuickGameBloc? quickGameBloc;
  String searchText = "";

  void handleSearchTextChanged(String text) {
    setState(() {
      searchText = text;
    });
    if (searchText.isEmpty) {
      BlocProvider.of<QuickGameBloc>(context).add(FetchQuickGameTopics());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    quickGameBloc = BlocProvider.of<QuickGameBloc>(context);
    quickGameBloc?.add(FetchQuickGameTopics());
  }

  @override
  void dispose() {
    quickGameBloc?.add(ClearQuickGameData());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final double usableHeight = screenHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    // final QuickGameBloc bloc = BlocProvider.of<QuickGameBloc>(context);
    // bloc.add(FetchQuickGameTopics());

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 0,
          backgroundColor: AppColors.primaryColorShade, // Status bar color
        ),
        backgroundColor: Color(0xFF014AA0),
        body: BlocConsumer<QuickGameBloc, QuickGameState>(
          listener: (context, state) {
            if (state.hasReachedMaximumTopicSelection != null &&
                state.hasReachedMaximumTopicSelection!) {
              Flushbar(
                message: 'You cannot select more than 4 topics',
                flushbarPosition: FlushbarPosition.TOP,
                flushbarStyle: FlushbarStyle.GROUNDED,
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ).show(context);
            }
          },
          builder: (context, state) {
            final soundManager = context.read<SettingsBloc>().soundManager;
            return SafeArea(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.patternTwoBg),
                  fit: BoxFit.cover,
                )),
                child: Column(
                  children: [
                    ScreenAppBar(
                      height: null,
                      widgets: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                soundManager.playClickSound();
                                Navigator.pop(context);
                              },
                              child: Image.asset(
                                IconImageRoutes.arrowCircleBack,
                                width: 44.w,
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: StrokeText(
                                  text: 'Quick Game',
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
                              },
                              child: Image.asset(
                                IconImageRoutes.infoCircle,
                                width: 44.w,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          'Select up to 4 topics of interest!',
                          style: TextStyle(
                            fontFamily: 'Mikado',
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      key: _key,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: SearchBoxTabletView(
                        onTap: () {
                          soundManager.playClickSound();
                          if (searchText.isNotEmpty) {
                            context
                                .read<QuickGameBloc>()
                                .add(FindQuickGameTopics(searchText));
                          }
                        },
                        onTextChanged: handleSearchTextChanged,
                        isActive: searchText.isNotEmpty,
                        hintPlaceholder: 'Search tags',
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    state.selectedGameTopics!.length >= 1
                        ? Container(
                            // color: Colors.red,
                            padding: EdgeInsets.symmetric(
                                horizontal: 5.w, vertical: 5.h),
                            constraints: BoxConstraints(
                                maxHeight:
                                    screenHeight >= 700 ? 135.h : 160.h),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 20.w),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Wrap(
                                      spacing: 8.w,
                                      runSpacing: 4.w,
                                      children: List.generate(
                                          state.selectedGameTopics!.length,
                                          (index) {
                                        return SelectedTopicPillTabletView(
                                          id: state
                                              .selectedGameTopics![index].id,
                                          topic: state
                                              .selectedGameTopics![index].tag,
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 20.w),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      '(${state.selectedGameTopics!.length}/4)',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                    state.isLoadingGameTopics!
                        ? Center(
                            child: CircularProgressIndicator(
                            color: Colors.white,
                          ))
                        : Expanded(
                          child: Stack(
                              children: [
                                state.quickGameTopics!.isNotEmpty
                                    ? GridView.builder(
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 100),
                                        shrinkWrap: true,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          // crossAxisSpacing: 20,
                                          mainAxisSpacing: 20,
                                        ),
                                        itemCount:
                                            state.quickGameTopics?.length,
                                        itemBuilder: (BuildContext context,
                                            int index) {
                                          return TopicTagTabletView(
                                            topic: state
                                                .quickGameTopics![index].tag,
                                            id: state
                                                .quickGameTopics![index].id,
                                          );
                                        },
                                      )
                                    : Center(
                                        child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            ProductImageRoutes.broLukeInfo,
                                            width: 84.w,
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          Text(
                                            'No search result for this topic.\nYou can add it to Bible Game!',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white),
                                          ),
                                          SizedBox(height: 28.h,),
                                          GreenButton(
                                            onTap: (){
                                              soundManager.playClickSound();
                                              Navigator.pushNamed(context, AppRoutes.profileScreen);
                                            },
                                            buttonIsLoading: false,
                                            width: 300.w,
                                            customWidget:  Center(
                                              child: StrokeText(
                                                text: 'Add to Bible game questions.',
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                strokeColor: const Color(0xFF272D39),
                                                strokeWidth: 3,
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                state.selectedGameTopics!.length >= 1
                                    ? Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 20.h),
                                        child: BlueButtonTabletView(
                                          buttonText: 'Play now',
                                          buttonIsLoading: false,
                                          width: 638.w,
                                          height: 64.h,
                                          onTap: () {
                                            soundManager.playClickSound();
                                            if (state.selectedGameTopics!
                                                        .length >=
                                                    1 &&
                                                state.selectedGameTopics!
                                                        .length <
                                                    5) {
                                              showUseTimerModalTabletView(context);
                                            }
                                            // Navigator.pushNamed(context, AppRoutes.questionLoadingScreen, arguments:{ 'gameType': 'quick_game'});
                                          },
                                        ),
                                      ),
                                    )
                                    : SizedBox()
                              ],
                            ),
                        ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
