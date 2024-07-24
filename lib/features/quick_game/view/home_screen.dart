import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_bible_game/features/quick_game/bloc/quick_game_bloc.dart';
import 'package:the_bible_game/features/quick_game/widget/search_box.dart';
import 'package:the_bible_game/features/quick_game/widget/selected_topic_pill.dart';
import 'package:the_bible_game/features/quick_game/widget/topic_tag.dart';
import 'package:the_bible_game/shared/constants/app_routes.dart';
import 'package:the_bible_game/shared/constants/colors.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:the_bible_game/shared/widgets/blue_button.dart';
import 'package:the_bible_game/shared/widgets/screen_app_bar.dart';
import '../../../shared/constants/image_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:badges/badges.dart' as badges;

class QuickGameHomeScreen extends StatefulWidget {
  const QuickGameHomeScreen({super.key});

  @override
  State<QuickGameHomeScreen> createState() => _QuickGameHomeScreenState();
}

class _QuickGameHomeScreenState extends State<QuickGameHomeScreen> {
  final GlobalKey _key = GlobalKey();
  double? searchBoxHeight;
  QuickGameBloc? quickGameBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    quickGameBloc = BlocProvider.of<QuickGameBloc>(context);
    quickGameBloc?.add(FetchQuickGameTopics());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        searchBoxHeight = getHeightOfWidget(_key);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   setState(() {
    //     searchBoxHeight = getHeightOfWidget(_key);
    //   });
    // });
  }

  @override
  void dispose() {
    quickGameBloc?.add(ClearQuickGameData());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final QuickGameBloc bloc = BlocProvider.of<QuickGameBloc>(context);
    bloc.add(FetchQuickGameTopics());

    return Scaffold(
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
            return Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(ProductImageRoutes.patternTwoBg),
                fit: BoxFit.cover,
              )),
              child: Column(
                children: [
                  ScreenAppBar(
                    widgets: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
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
                            onTap: () {},
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
                  Container(
                    key: _key,
                    child: SearchBox(),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                 state.selectedGameTopics!.length >= 1 ? Container(
                    // color: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                    constraints: BoxConstraints(maxHeight: 102.h),
                    child: Column(
                      children: [
                        Wrap(
                          spacing: 2.w,
                          runSpacing: 8.w,
                          children: List.generate(
                              state.selectedGameTopics!.length, (index) {
                            return SelectedTopicPill(
                              id: state.selectedGameTopics![index].id,
                              topic: state.selectedGameTopics![index].tag,
                            );
                          }),
                        ),
                        InkWell(
                          onTap: () {
                            double height = getHeightOfWidget(_key);
                            print('Height of the widget: $height');
                          },
                          child: Padding(
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
                        ),
                      ],
                    ),
                  ): SizedBox(),
                  state.isLoadingGameTopics!
                      ? Center(
                          child: CircularProgressIndicator(
                          color: Colors.white,
                        ))
                      : Stack(
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxHeight:
                                    screenHeight - (160.h + 97.h + 30.h + (state.selectedGameTopics!.length >= 1 ? 102.h : 0) ),
                              ),
                              child: GridView.builder(
                                padding: EdgeInsets.only(bottom: 100.h),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  // crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                ),
                                itemCount: state.quickGameTopics?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return TopicTag(
                                    topic: state.quickGameTopics![index].tag,
                                    id: state.quickGameTopics![index].id,
                                  );
                                },
                              ),
                            ),
                            state.selectedGameTopics!.length >= 1 ? Positioned(
                              top:  320.h ,
                              right: 35.w,
                              left: 35.w,
                              child: BlueButton(
                                buttonText: 'Play now',
                                buttonIsLoading: false,
                                width: 250.w,
                                onTap: () {
                                  if (state.selectedGameTopics!.length >= 1 && state.selectedGameTopics!.length < 5)
                                    Navigator.pushNamed(context, AppRoutes.questionLoadingScreen, arguments:{ 'gameType': 'quick_game'});
                                },
                              ),
                            ) : SizedBox()
                          ],
                        ),
                  SizedBox(
                    height: 20.h,
                  )
                ],
              ),
            );
          },
        ));
  }

  double getHeightOfWidget(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    return renderBox.size.height;
  }
}
