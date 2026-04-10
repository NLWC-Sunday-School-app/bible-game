import 'package:bible_game_api/model/league_data.dart';
import 'package:bible_game_api/utils/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../../shared/utils/validation.dart';
import '../../../../shared/widgets/custom_toast.dart';
import '../../../../shared/widgets/green_button.dart';
import '../../bloc/fantasy_league_bloc.dart';

void showEditLeagueModal(BuildContext context, LeagueData leagueData) {
  showDialog(
      context: context,
      barrierColor: const Color.fromRGBO(40, 40, 40, 0.95),
      builder: (BuildContext context) {
        return EditLeagueModal(
          leagueData: leagueData,
        );
      });
}

class EditLeagueModal extends StatefulWidget {
  const EditLeagueModal({super.key, required this.leagueData});

  final LeagueData leagueData;

  @override
  State<EditLeagueModal> createState() => _EditLeagueModalState();
}

class _EditLeagueModalState extends State<EditLeagueModal> {
  final GlobalKey<FormState> _editLeagueFormKey = GlobalKey<FormState>();
  final leagueNameController = TextEditingController();
  bool isOpenToEveryone = false;
  String _leagueNameErrorMessage = '';

  @override
  void initState() {
    super.initState();
    setState(() {
      leagueNameController.text = widget.leagueData.league.name;
      isOpenToEveryone = widget.leagueData.league.isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    return BlocConsumer<FantasyLeagueBloc, FantasyLeagueState>(
      listener: (context, state) {
        if (state.failedToEdit) {
          ApiException.showSnackBar(context);
        }

        if (state.hasEditedLeague) {
          Navigator.pop(context);
          showCustomToast(context, 'Updated Successfully');
        }
      },
      builder: (context, state) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          backgroundColor: Colors.transparent,
          child: SizedBox(
            height: 450.h,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.streakModalBg),
                  fit: BoxFit.fill,
                ),
              ),
              child: Form(
                key: _editLeagueFormKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      children: [
                        Spacer(),
                        StrokeText(
                          text: 'Edit League details',
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          strokeColor: const Color(0xFF272D39),
                          strokeWidth: 3,
                        ),
                        SizedBox(
                          width: 36.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            soundManager.playClickSound();
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            IconImageRoutes.blueCircleCancel,
                            width: 35.w,
                          ),
                        ),
                        SizedBox(
                          width: 13.w,
                        ),
                      ],
                    ),
                    SizedBox(height: 23.h),
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
                      width: 300.w,
                      height: 48.h,
                      child: Container(
                        padding: EdgeInsets.zero,
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
                              alignLabelWithHint: true,
                              hintText: 'Enter name',
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10.h),
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
                                borderSide: BorderSide(
                                    color: Colors
                                        .transparent), // Hide error border
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.r),
                                borderSide:
                                    BorderSide(color: Colors.transparent),
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
                            height: 60.h,
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
                      height: 30.h,
                    ),
                    GreenButton(
                      width: 300.w,
                      onTap: () {
                        soundManager.playClickSound();
                        if (_editLeagueFormKey.currentState!.validate()) {
                          context
                              .read<FantasyLeagueBloc>()
                              .add(EditFantasyLeague(
                                leagueNameController.text.trim(),
                                isOpenToEveryone,
                                widget.leagueData.league.id,
                              ));
                        }
                      },
                      customWidget: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          state.isEditingLeague
                              ? SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ))
                              : StrokeText(
                                  text: 'Save changes',
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
                        ],
                      ),
                      buttonIsLoading: state.isEditingLeague,
                    ),
                    SizedBox(
                      height: 20.h,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
