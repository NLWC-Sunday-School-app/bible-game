
import 'package:bible_game/features/multi_player/question_timing.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/features/multi_player/widget/modal/players_waiting_modal.dart';
import 'package:bible_game/features/multi_player/widget/toggle_card.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/widgets/blue_button.dart';

import '../../../../shared/features/multiplayer/cubit/websocket_cubit.dart';
import '../../../../shared/utils/custom_toast.dart';

void showGroupGamePlayModal(BuildContext context, {required selectedGroupGame, required inviteCode}) {
  showDialog(
      context: context,
      // The game room is created on the server before this opens, so a stray
      // tap on the barrier abandoned a live room and its code. Closing is the
      // red button's job.
      barrierDismissible: false,
      builder: (BuildContext context) {
        return GroupGamePlayModal(selectedGroupGame: selectedGroupGame, inviteCode: inviteCode,);
      });
}

class GroupGamePlayModal extends StatefulWidget {
  final String selectedGroupGame;
  final String inviteCode;
  const GroupGamePlayModal({super.key, required this.selectedGroupGame, required this.inviteCode});

  @override
  State<GroupGamePlayModal> createState() => _GroupGamePlayModalState();
}

class _GroupGamePlayModalState extends State<GroupGamePlayModal> {
  List<String> questionType = ['Who is Who','Scripture Quiz'];
  String selectedValue = "Who is Who";

  /// Seconds per question for this round. Sent on configure so every player
  /// runs the same clock -- applying it locally would only change the host's.
  int secondsPerQuestion = kDefaultSecondsPerQuestion;
  String  errorMessage= '';

  /// Stepped rather than typed, so the value is always in range and the
  /// keyboard never covers the modal. Both start on their first option, which
  /// is what ToggleCard shows before anything is tapped -- it only reports a
  /// value on change, so the defaults have to match options.first.
  static const _questionCountOptions = ['10', '15', '20', '25', '30'];
  static const _targetCoinOptions = ['1,000', '1,500', '2,000', '2,500', '3,000'];

  int noOfQuestions = 10;
  int targetCoins = 1000;

  @override
  void initState() {
    // TODO: implement initState
    context.read<WebsocketCubit>().subscribeToWaitingRoom();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      // Vertical inset was 0, so with the keyboard up the dialog ran into the
      // screen edges with nothing to breathe against.
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 24.h),
      backgroundColor: Colors.transparent,
      // This animation runs on every inset change, not just on open. The
      // keyboard reports its inset frame by frame as it slides, so any non-zero
      // duration eases toward a target that has already moved and the modal
      // trails behind it. Zero tracks the keyboard's own curve exactly.
      insetAnimationDuration: Duration.zero,
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        // maxHeight, not a fixed height: Dialog already shrinks its available
        // space by the keyboard inset, but a fixed 550.h insisted on the full
        // height anyway, so the content was clipped instead of scrolling. Now
        // it takes 550.h when there is room and whatever is left when there is
        // not, and the focused field scrolls into view on its own.
        child: ConstrainedBox(
          // size.height is the whole screen and ignores the keyboard, so with
          // it up the cap stayed larger than the space actually left and the
          // form overflowed. Subtract the inset first, then clamp so a tall
          // keyboard on a short device cannot drive this to nothing.
          constraints: BoxConstraints(
            maxHeight: ((MediaQuery.of(context).size.height -
                        MediaQuery.of(context).viewInsets.bottom) *
                    0.88)
                .clamp(220.0, double.infinity),
          ),
          child: SingleChildScrollView(
            keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 12.h : 0),
            child: Column(
              children: [
                Container(
                  height: 64.h,
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(ProductImageRoutes.createModalTitleBg),
                        fit: BoxFit.fill),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.white, width: 2.w),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFF3C7B3),
                        offset: Offset(1, 7),
                        blurRadius: 0,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      Spacer(),
                      Image.asset(
                        ProductImageRoutes.createSword,
                        width: 34.w,
                      ),
                      SizedBox(width: 3.w,),
                      Column(
                        children: [
                          Text(
                            'Create a gameplay',
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF014CA3),
                                fontSize: 18.sp),
                          ),
                          Text(
                            '(${widget.selectedGroupGame})',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF014CA3),
                                fontSize: 13.sp),
                          ),
                        ],
                      ),
                      SizedBox(width: 10.w,),
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Image.asset(
                          IconImageRoutes.redCircleClose,
                          // width: 60.w,
                        ),
                      ),
                      Spacer()

                    ],
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: Container(
                    width: double.infinity,
                    // No fixed height: it was 460.h, and every control added to
                    // the form -- the seconds picker most recently -- pushed the
                    // column past it and overflowed. It wraps its content now,
                    // and the scroll view above handles anything taller than the
                    // screen.
                    decoration: BoxDecoration(
                        color: Color(0xFFFFF2EB),
                        border: Border(
                          left: BorderSide(width: 2.w, color: Color(0xFFF6C4AD)),
                          right: BorderSide(width: 2.w, color: Color(0xFFF6C4AD)),
                          bottom: BorderSide(width: 2.w, color: Color(0xFFF6C4AD)),
                        ),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(16.r),
                          bottomLeft: Radius.circular(16.r),
                        )),
                    child: 
                    BlocConsumer<MultiplayerBloc, MultiplayerState>(
                      // Only the moment configuring finishes. hasConfiguredGameRoom
                      // is never reset in the bloc, so without this the listener
                      // re-fired on every unrelated emission -- and now that invite
                      // polling runs for the whole session rather than only on the
                      // multiplayer screen, that is every ten seconds: popping the
                      // route again and parsing an empty field.
                      listenWhen: (previous, current) =>
                          (!previous.hasConfiguredGameRoom &&
                              current.hasConfiguredGameRoom) ||
                          (!previous.hasConfigureGameRoomFailed &&
                              current.hasConfigureGameRoomFailed),
                      listener: (context, state) {
                        if(state.hasConfiguredGameRoom){
                          Navigator.pop(context);
                          showHostWaitingModal(
                              context,
                              selectedGroupGame: widget.selectedGroupGame,
                              inviteCode: widget.inviteCode,
                              questionType: selectedValue,
                              noOfQuestion:
                                  widget.selectedGroupGame == "First to X"
                                      ? targetCoins
                                      : noOfQuestions,
                          );

                        }
                        if(state.hasConfigureGameRoomFailed){
                          CustomToast.show(context, "Failed to configure game room");
                        }
                      },
                      builder: (context, state) {
                        if(state.isLoadingConfigureGameRoom){
                          // Keeps the panel from collapsing to the spinner's
                          // size now that its height comes from its content.
                          return SizedBox(
                            height: 240.h,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }else{
                          final isTimed = widget.selectedGroupGame ==
                                  "Time-based Mode" ||
                              widget.selectedGroupGame == "Survival Mode";
                          final isFirstToX =
                              widget.selectedGroupGame == "First to X";
                          final isLightning =
                              widget.selectedGroupGame == "Lightning Mode";

                          return Column(
                            children: [
                              SizedBox(height: 24.h),
                              Text(
                                'Game Code:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 11.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.inviteCode,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 24.sp,
                                      color: const Color(0xFF014CA3),
                                    ),
                                  ),
                                  SizedBox(width: 19.w),
                                  GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(
                                          ClipboardData(text: widget.inviteCode));
                                      Flushbar(
                                        message: 'Copied',
                                        flushbarPosition: FlushbarPosition.TOP,
                                        flushbarStyle: FlushbarStyle.GROUNDED,
                                        backgroundColor: Colors.green,
                                        duration: const Duration(seconds: 3),
                                      ).show(context);
                                    },
                                    child: Container(
                                      height: 36.h,
                                      width: 36.w,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF365B87),
                                        border: Border.all(
                                            width: 1,
                                            color: const Color(0xFF002959)),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          ProductImageRoutes.copyIcon,
                                          height: 15.h,
                                          width: 15.w,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),
                              _PanelDivider(),
                              SizedBox(height: 15.h),

                              _FieldLabel('Select question type'),
                              SizedBox(height: 10.h),
                              ToggleCard(
                                onTap: null,
                                onValueSelected: (value) {
                                  setState(() => selectedValue = value);
                                },
                                selectedOption: false,
                                hasTwoOptions: false,
                                options: questionType,
                              ),

                              if (isTimed) ...[
                                SizedBox(height: 15.h),
                                _PanelDivider(),
                                SizedBox(height: 15.h),
                                _FieldLabel('Duration of the game (minutes)'),
                                SizedBox(height: 10.h),
                                ToggleCard(
                                  onTap: null,
                                  selectedOption: false,
                                  onValueSelected: (value) {},
                                  hasTwoOptions: false,
                                  options: const ['1', '2', '3', '4'],
                                ),
                              ],

                              // Both playable modes take the same timer, so
                              // the control sits outside their per-mode blocks.
                              if (isLightning || isFirstToX) ...[
                                SizedBox(height: 15.h),
                                _PanelDivider(),
                                SizedBox(height: 15.h),
                                _FieldLabel('Seconds per question'),
                                SizedBox(height: 10.h),
                                ToggleCard(
                                  onTap: null,
                                  selectedOption: false,
                                  hasTwoOptions: false,
                                  options: const ['8', '10', '12', '6'],
                                  onValueSelected: (value) {
                                    setState(() {
                                      secondsPerQuestion =
                                          resolveSecondsPerQuestion(value);
                                    });
                                  },
                                ),
                              ],

                              if (isLightning) ...[
                                SizedBox(height: 15.h),
                                _PanelDivider(),
                                SizedBox(height: 15.h),
                                _FieldLabel('No. of questions'),
                                SizedBox(height: 10.h),
                                ToggleCard(
                                  onTap: null,
                                  selectedOption: false,
                                  hasTwoOptions: false,
                                  options: _questionCountOptions,
                                  onValueSelected: (value) {
                                    setState(() =>
                                        noOfQuestions = int.parse(value));
                                  },
                                ),
                              ],

                              if (isFirstToX) ...[
                                SizedBox(height: 15.h),
                                _PanelDivider(),
                                SizedBox(height: 15.h),
                                _FieldLabel('Target coins'),
                                SizedBox(height: 10.h),
                                ToggleCard(
                                  onTap: null,
                                  selectedOption: false,
                                  hasTwoOptions: false,
                                  options: _targetCoinOptions,
                                  onValueSelected: (value) {
                                    setState(() => targetCoins =
                                        int.parse(value.replaceAll(',', '')));
                                  },
                                ),
                              ],

                              if (errorMessage.isNotEmpty) ...[
                                SizedBox(height: 8.h),
                                Text(
                                  errorMessage,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 13.sp),
                                ),
                              ],

                              SizedBox(height: 26.h),
                              BlueButton(
                                onTap: () {
                                  if (isLightning) {
                                    lightningModeValidation();
                                  } else if (isFirstToX) {
                                    firstToXValidation();
                                  }
                                },
                                buttonText: 'Create a gameplay',
                                buttonIsLoading: false,
                                width: 267.w,
                              ),
                              SizedBox(height: 10.h),
                            ],
                          );
                        }
                        },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void lightningModeValidation(){
    // No range check: the stepper only offers 10-30 in fives, so an invalid
    // value cannot be produced. This was a typed field guarded by
    // int.parse on a possibly-empty string.
    BlocProvider.of<MultiplayerBloc>(context).add(ConfigureGameRoom(
        "LIGHTNING",
        selectedValue == "Who is Who"?"WHO_IS_WHO":"SCRIPTURE_QUIZ",
        noOfQuestions,
        "BEST_OF_ROUNDS",
        secondsPerQuestion: secondsPerQuestion));
  }

  void firstToXValidation(){
    // Likewise 1,000-3,000 in five hundreds.
    BlocProvider.of<MultiplayerBloc>(context).add(ConfigureGameRoom(
        "FIRST_TO_X",
        selectedValue == "Who is Who"?"WHO_IS_WHO":"SCRIPTURE_QUIZ",
        targetCoins,
        "BEST_OF_ROUNDS",
        secondsPerQuestion: secondsPerQuestion));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}


/// The thin rule between sections of the panel.
class _PanelDivider extends StatelessWidget {
  const _PanelDivider();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 270.w,
      child: Divider(thickness: 1.w, color: const Color(0xFFF7E1D7)),
    );
  }
}

/// A section heading inside the panel.
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14.sp),
    );
  }
}
