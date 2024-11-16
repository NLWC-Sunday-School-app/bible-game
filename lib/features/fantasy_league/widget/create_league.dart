import 'dart:ui';

import 'package:bible_game_api/utils/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/features/fantasy_league/bloc/fantasy_league_bloc.dart';
import 'package:bible_game/features/fantasy_league/widget/modal/successfully_created_league_modal.dart';
import 'package:intl/intl.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import '../../../shared/constants/image_routes.dart';
import '../../../shared/utils/validation.dart';
import '../../../shared/widgets/green_button.dart';

class CreateLeague extends StatefulWidget {
  final double screenHeight;

  const CreateLeague({super.key, required this.screenHeight});

  @override
  State<CreateLeague> createState() => _CreateLeagueState();
}

class _CreateLeagueState extends State<CreateLeague> {
  final GlobalKey<FormState> _createLeagueFormKey = GlobalKey<FormState>();
  bool isOpenToEveryone = false;
  int currentIndex = 0;
  List<String> duration = ['1 Week', '2 Week', '3 Week', '4 Week'];
  final leagueNameController = TextEditingController();
  final leagueCoinsGoal = TextEditingController();
  String _leagueNameErrorMessage = '';
  String _coinsGoalErrorMessage = '';
  String createLeaguePrice = '';

  String _formatNumber(String s) {
    if (s.isEmpty) return '';
    final number = int.parse(s.replaceAll(',', ''));
    return NumberFormat.decimalPattern().format(number);
  }

  String calculateExpectedDate(int weeks) {
    DateTime currentDate = DateTime.now();
    DateTime expectedDate = currentDate.add(Duration(days: weeks * 7));
    return DateFormat('yyyy-MM-dd').format(expectedDate);
  }

  @override
  void initState() {
    super.initState();

    createLeaguePrice = BlocProvider.of<SettingsBloc>(context)
        .state
        .gamePlaySettings['create_league_price'];
    leagueCoinsGoal.addListener(() {
      final text = leagueCoinsGoal.text.replaceAll(',', '');
      final formattedText = _formatNumber(text);
      if (formattedText != leagueCoinsGoal.text) {
        leagueCoinsGoal.value = leagueCoinsGoal.value.copyWith(
          text: formattedText,
          selection: TextSelection.collapsed(
            offset: formattedText.length,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    return BlocConsumer<FantasyLeagueBloc, FantasyLeagueState>(
      listener: (context, state) {

        if( state.failedToCreate){
          ApiException.showSnackBar(context);
        }

        if (state.hasCreatedLeague) {
          showSuccessfullyCreatedModal(context);
          leagueNameController.text = '';
          leagueCoinsGoal.text = '';
          BlocProvider.of<AuthenticationBloc>(context).add(FetchUserDataRequested());
        }


      },
      builder: (context, state) {
        return SizedBox(
          height: widget.screenHeight - (80.h + 15.h + 72.h + 5.h + 120.h),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Color(0xFF032956)),
                  color: Color(0xFF093D7B),
                ),
                child: Form(
                  key: _createLeagueFormKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'Give your league a name',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFFFAD3),
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      SizedBox(
                        width: 320.w,
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
                            child: TextFormField(
                              controller: leagueNameController,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF0C70DB),
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Enter name',
                                contentPadding: EdgeInsets.symmetric(vertical: 10.h) ,
                                hintStyle: TextStyle(
                                    color: Color(0xFF627F8F),
                                    fontWeight: FontWeight.w700),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFFFFFAD3), width: 0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                  borderSide: BorderSide(color: Colors.transparent),  // Hide error border
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                  borderSide: BorderSide(color: Colors.transparent),
                                ),
                                errorStyle: TextStyle(height: 0),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFFFFAD3), width: 0),
                                ),
                              ),
                              validator: (text) {
                                String? validationMessage =
                                    Validator.validateLeagueName(text!);
                                setState(() {
                                  _leagueNameErrorMessage =
                                      validationMessage ?? '';
                                });
                                return validationMessage != null ? '' : null;
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        _leagueNameErrorMessage,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 13.w,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        'Who is your league open to?',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFFFAD3),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isOpenToEveryone = !isOpenToEveryone;
                                });
                              },
                              child: Image.asset(
                                IconImageRoutes.greenLeftCircleArrow,
                                width: 33.w,
                              ),
                            ),
                            SizedBox(
                              width: 230.w,
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
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      isOpenToEveryone
                                          ? 'Everyone'
                                          : 'People with invite code',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF0C70DB),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  )),
                            ),
                            InkWell(
                              onTap: () {
                                soundManager.playClickSound();
                                setState(() {
                                  isOpenToEveryone = !isOpenToEveryone;
                                });
                              },
                              child: Image.asset(
                                IconImageRoutes.greenRightCircleArrow,
                                width: 33.w,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        isOpenToEveryone
                            ? 'The league would be visible to all'
                            : 'The league won’t be visible to all',
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        'Coins target to win',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFFFAD3),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      SizedBox(
                        width: 320.w,
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
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: leagueCoinsGoal,
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: true, decimal: true),
                              style: TextStyle(
                                  color: Color(0xFF0C70DB),
                                  fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'e.g. 100',
                                contentPadding: EdgeInsets.symmetric(vertical: 10.h) ,
                                hintStyle: TextStyle(
                                    color: Color(0xFF627F8F),
                                    fontWeight: FontWeight.w700),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFFFFFAD3), width: 0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                  borderSide: BorderSide(color: Colors.transparent),  // Hide error border
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                  borderSide: BorderSide(color: Colors.transparent),
                                ),
                                errorStyle: TextStyle(height: 0),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFFFFAD3), width: 0),
                                ),
                              ),
                              validator: (text) {
                                String? validationMessage =
                                    Validator.validateCoinsGoal(text!);
                                setState(() {
                                  _coinsGoalErrorMessage =
                                      validationMessage ?? '';
                                });
                                return validationMessage != null ? '' : null;
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        _coinsGoalErrorMessage,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 13.w,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        'How long is the league for?',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFFFAD3),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                soundManager.playClickSound();
                                setState(() {
                                  currentIndex =
                                      (currentIndex - 1) % duration.length;
                                });
                              },
                              child: Image.asset(
                                IconImageRoutes.greenLeftCircleArrow,
                                width: 33.w,
                              ),
                            ),
                            SizedBox(
                              width: 230.w,
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
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      duration[currentIndex],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Color(0xFF0C70DB),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  )),
                            ),
                            InkWell(
                              onTap: () {
                                soundManager.playClickSound();
                                setState(() {
                                  currentIndex =
                                      (currentIndex + 1) % duration.length;
                                });
                              },
                              child: Image.asset(
                                IconImageRoutes.greenRightCircleArrow,
                                width: 33.w,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      GreenButton(
                        onTap: () {
                          soundManager.playClickSound();
                          if (_createLeagueFormKey.currentState!.validate()) {
                            context.read<FantasyLeagueBloc>().add(
                                CreateFantasyLeague(
                                    leagueNameController.text.trim(),
                                    int.parse(leagueCoinsGoal.text
                                        .replaceAll(',', '')),
                                    isOpenToEveryone,
                                    calculateExpectedDate(currentIndex + 1)));
                          }
                        },
                        customWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StrokeText(
                              text: 'Create league',
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              strokeColor: const Color(0xFF272D39),
                              strokeWidth: 3,
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            Image.asset(
                              IconImageRoutes.coinIcon,
                              width: 27.w,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            StrokeText(
                              text: createLeaguePrice,
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              strokeColor: const Color(0xFF272D39),
                              strokeWidth: 3,
                            ),
                          ],
                        ),
                        buttonIsLoading: state.isCreatingLeague,
                        width: 320.w,
                      ),
                      SizedBox(
                        height: 20.h,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
