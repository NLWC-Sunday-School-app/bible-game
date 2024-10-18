
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/features/multi_player/widget/modal/players_waiting_modal.dart';
import 'package:bible_game/features/multi_player/widget/question_type_pill.dart';
import 'package:bible_game/features/multi_player/widget/toggle_card.dart';
import 'package:bible_game/shared/constants/image_routes.dart';
import 'package:bible_game/shared/widgets/blue_button.dart';

void showCreateGamePlayModal(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateGamePlayModal();
      });
}

class CreateGamePlayModal extends StatefulWidget {
  const CreateGamePlayModal({super.key});

  @override
  State<CreateGamePlayModal> createState() => _CreateGamePlayModalState();
}

class _CreateGamePlayModalState extends State<CreateGamePlayModal> {
  bool randomiseQuestionTypeSelected = false;
  bool singlePlayerSelected = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 10.w),
      backgroundColor: Colors.transparent,
      insetAnimationCurve: Curves.bounceInOut,
      insetAnimationDuration: const Duration(milliseconds: 500),
      child: SizedBox(
        height: 550.h,
        child: Column(
          children: [
            Container(
              height: 64.h,
              width: double.infinity,
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    ProductImageRoutes.createSword,
                    width: 50.w,
                  ),
                  Text(
                    'Create a gameplay',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF014CA3),
                        fontSize: 18.sp),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(
                      IconImageRoutes.redCircleClose,
                      width: 60.w,
                    ),
                  ),
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
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      'How do you want to play',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    ToggleCard(
                      onTap: () {
                        setState(() {
                          singlePlayerSelected = !singlePlayerSelected;
                        });
                      },
                      selectedOption: singlePlayerSelected,
                      hasTwoOptions: true,
                      options: [],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(singlePlayerSelected
                        ? 'Play against a Bible Gamer'
                        : 'Play with more individual friends'),
                    Container(
                      margin: EdgeInsets.only(top: 10.h),
                      width: 270.w,
                      child: Divider(
                        thickness: 1.w,
                        color: Color(0xFFF7E1D7),
                      ),
                    ),
                    singlePlayerSelected
                        ? Column(
                            children: [
                              Text(
                                'Invite via username',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
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
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Color(0xFF014CA3),
                                        fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                      hintText: '@username',
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
                              Container(
                                margin: EdgeInsets.only(top: 10.h),
                                width: 270.w,
                                child: Divider(
                                  thickness: 1.w,
                                  color: Color(0xFFF7E1D7),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                    SizedBox(
                      height: 10.h,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        QuestionTypePill(
                          text: 'Who is Who',
                          pillSelected: !randomiseQuestionTypeSelected,
                          onTap: () {
                            setState(() {
                              randomiseQuestionTypeSelected = false;
                            });
                          },
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        QuestionTypePill(
                          text: 'Randomise',
                          pillSelected: randomiseQuestionTypeSelected,
                          onTap: () {
                            setState(() {
                              randomiseQuestionTypeSelected = true;
                            });
                          },
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.h),
                      width: 270.w,
                      child: Divider(
                        thickness: 1.w,
                        color: Color(0xFFF7E1D7),
                      ),
                    ),
                    !singlePlayerSelected ?  Column(
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
                          onTap: () {},
                          selectedOption: false,
                          hasTwoOptions: false,
                          options: ['1', '2', '3', '4'],
                        )
                      ],
                    ): SizedBox(),
                    SizedBox(
                      height: 30.h,
                    ),
                    BlueButton(
                      onTap: () {
                        Navigator.pop(context);
                        showHostWaitingModal(context);
                      },
                      buttonText: 'Create a gameplay',
                      buttonIsLoading: false,
                      width: 200.w,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
    ;
  }
}
