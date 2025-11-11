
import 'package:another_flushbar/flushbar.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/features/multi_player/widget/modal/players_waiting_modal.dart';
import 'package:bible_game/features/multi_player/widget/question_type_pill.dart';
import 'package:bible_game/features/multi_player/widget/toggle_card.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/widgets/blue_button.dart';

import '../../../../shared/features/multiplayer/cubit/websocket_cubit.dart';

void showGroupGamePlayModal(BuildContext context, {required selectedGroupGame, required inviteCode}) {
  showDialog(
      context: context,
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
  final textController = TextEditingController();
  String  errorMessage= '';

  @override
  void initState() {
    // TODO: implement initState
    context.read<WebsocketCubit>().subscribeToWaitingRoom();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
      backgroundColor: Colors.transparent,
      insetAnimationCurve: Curves.bounceInOut,
      insetAnimationDuration: const Duration(milliseconds: 500),
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: SizedBox(
          height: 550.h,
          child: SingleChildScrollView(
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
                    height: 460.h,
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
                      listener: (context, state) {
                        if(state.hasConfiguredGameRoom){
                          Navigator.pop(context);
                          showHostWaitingModal(
                              context,
                              selectedGroupGame: widget.selectedGroupGame,
                              inviteCode: widget.inviteCode,
                              questionType: selectedValue,
                              noOfQuestion: int.parse(textController.text),
                          );

                        }
                      },
                      builder: (context, state) {
                        if(state.isLoadingConfigureGameRoom){
                          return Center(child: CircularProgressIndicator(),);
                        }else{
                          return Column(
                            children: [
                              SizedBox(height: 24.h,),
                              Text(
                                'Game Code:',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 11.h,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.inviteCode,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 24.sp,
                                        color: Color(0xFF014CA3)
                                    ),
                                  ),
                                  SizedBox(width: 19.w,),
                                  GestureDetector(
                                    onTap: (){
                                      Clipboard.setData(ClipboardData(text: widget.inviteCode));
                                      Flushbar(
                                        message: 'Copied',
                                        flushbarPosition: FlushbarPosition.TOP,
                                        flushbarStyle: FlushbarStyle.GROUNDED,
                                        backgroundColor: Colors.green,
                                        duration: Duration(seconds: 3),
                                      ).show(context);
                                    },
                                    child: Container(
                                      height: 36.h,
                                      width: 36.w,
                                      decoration: BoxDecoration(
                                          color: Color(0xFF365B87),
                                          border: Border.all(
                                              width: 1,
                                              color: Color(0xFF002959)
                                          ),
                                          shape: BoxShape.circle
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          ProductImageRoutes.copyIcon,
                                          height: 15.h,
                                          width: 15.w,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10.h),
                                width: 270.w,
                                child: Divider(
                                  thickness: 1.w,
                                  color: Color(0xFFF7E1D7),
                                ),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                'Select question type',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              ToggleCard(
                                onTap:null,
                                onValueSelected: (value) {
                                  setState(() {
                                    selectedValue = value;
                                    print(selectedValue);//; update parent with selected
                                  });
                                },
                                selectedOption: false,
                                hasTwoOptions: false,
                                options: questionType,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10.h),
                                width: 270.w,
                                child: Divider(
                                  thickness: 1.w,
                                  color: Color(0xFFF7E1D7),
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              widget.selectedGroupGame == "Time-based Mode" || widget.selectedGroupGame == "Survival Mode" ?
                              Column(
                                children: [
                                  SizedBox(height: 20.h,),
                                  Text(
                                    'Duration of the game (minutes)',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 10.h,),
                                  ToggleCard(
                                    onTap:null,
                                    selectedOption: false,
                                    onValueSelected: (value) {
                                    },
                                    hasTwoOptions: false,
                                    options: ['1', '2', '3', '4'],
                                  )
                                ],
                              )
                                  :
                              SizedBox.shrink(),

                              widget.selectedGroupGame == "First to X"?
                              Column(
                                children: [
                                  Text(
                                    'Target Coins',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  SizedBox(height: 9.5.h,),
                                  SizedBox(
                                    width: 255.w,
                                    height: 50.h,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border:
                                        Border.all(color: Color(0xFFF8E7DE)),
                                        borderRadius: BorderRadius.circular(4.r),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                          ),
                                          BoxShadow(
                                            color: Color(0xFFFEEDE4),
                                            offset: Offset(0, 1),
                                            spreadRadius: 1.0,
                                            blurRadius: 2.0,
                                          ),
                                        ],
                                      ),
                                      child:
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        controller: textController,
                                        style: TextStyle(
                                            color: Color(0xFF014CA3),
                                            fontWeight: FontWeight.w500),
                                        decoration: InputDecoration(
                                          hintText: 'Target Coins',
                                          hintStyle:
                                          TextStyle(color: Color(0xFFF4E7E1)),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(10.r),
                                            borderSide: const BorderSide(
                                                color: Color(0xFFF8E7DE), width: 0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(10.r),
                                            borderSide: const BorderSide(
                                                color: Color(0xFFF8E7DE), width: 0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                                  :
                              SizedBox.shrink(),
                              SizedBox(
                                height: 10.h,
                              ),
                              widget.selectedGroupGame == "Lightning Mode"?
                              Column(
                                children: [
                                  Text(
                                    'No. of questions',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  SizedBox(height: 9.5.h,),
                                  SizedBox(
                                    width: 255.w,
                                    height: 50.h,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border:
                                        Border.all(color: Color(0xFFF8E7DE)),
                                        borderRadius: BorderRadius.circular(4.r),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                          ),
                                          BoxShadow(
                                            color: Color(0xFFFEEDE4),
                                            offset: Offset(0, 1),
                                            spreadRadius: 1.0,
                                            blurRadius: 2.0,
                                          ),
                                        ],
                                      ),
                                      child:
                                      TextField(
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                        controller: textController,
                                        style: TextStyle(
                                            color: Color(0xFF014CA3),
                                            fontWeight: FontWeight.w500),
                                        decoration: InputDecoration(
                                          hintText: 'Enter the Number of questions',
                                          hintStyle:
                                          TextStyle(
                                            color: Color(0xFF627F8F),
                                            fontSize: 12.sp,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(10.r),
                                            borderSide: const BorderSide(
                                                color: Color(0xFFF8E7DE), width: 0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(10.r),
                                            borderSide: const BorderSide(
                                                color: Color(0xFFF8E7DE), width: 0),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '(must be between 10 and 30)',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 10.sp,
                                        color: Color(0xFF7E7E7E)
                                    ),
                                  ),
                                  Text(
                                    errorMessage,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 13.w,
                                    ),
                                  ),
                                ],
                              )
                                  :
                              Container(
                                margin: EdgeInsets.only(top: 10.h),
                                width: 270.w,
                                child: Divider(
                                  thickness: 1.w,
                                  color: Color(0xFFF7E1D7),
                                ),
                              ),
                              Spacer(),
                              BlueButton(
                                onTap: () {
                                  if(widget.selectedGroupGame == "Lightning Mode"){
                                    lightningModeValidation();
                                  }else if(widget.selectedGroupGame == "First to X"){
                                    firstToXValidation();
                                  }
                                },
                                buttonText: 'Create a gameplay',
                                buttonIsLoading: false,
                                width: 267.w,
                              ),
                              SizedBox(height: 10,),
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
    if(textController.text.isEmpty){
      Flushbar(
        message: 'fill up field',
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ).show(context);
    }else if(int.parse(textController.text)<10 || int.parse(textController.text) > 30){
      Flushbar(
        message: 'Try keeping the number of questions between 10 and 30',
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ).show(context);
    }else{
      BlocProvider.of<MultiplayerBloc>(context).add(ConfigureGameRoom(
          "LIGHTNING",
          selectedValue == "Who is Who"?"WHO_IS_WHO":"SCRIPTURE_QUIZ",
          int.parse(textController.text),
          "BEST_OF_ROUNDS"));
    }
  }

  void firstToXValidation(){
    if(textController.text.isEmpty){
      Flushbar(
        message: 'fill up field',
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ).show(context);
    }else if(int.parse(textController.text)<1000 || int.parse(textController.text) > 5000){
      Flushbar(
        message: 'coins is between 1000-3000',
        flushbarPosition: FlushbarPosition.TOP,
        flushbarStyle: FlushbarStyle.GROUNDED,
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ).show(context);
    }else{
      BlocProvider.of<MultiplayerBloc>(context).add(ConfigureGameRoom(
          "FIRST_TO_X",
          selectedValue == "Who is Who"?"WHO_IS_WHO":"SCRIPTURE_QUIZ",
          int.parse(textController.text),
          "BEST_OF_ROUNDS"));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textController.dispose();
    super.dispose();
  }
}
