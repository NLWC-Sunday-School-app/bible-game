import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:the_bible_game/features/fantasy_league/bloc/fantasy_league_bloc.dart';
import 'package:the_bible_game/shared/widgets/blue_button.dart';

import '../../../../shared/constants/image_routes.dart';

void showSuccessfullyCreatedModal(BuildContext context) {
  showDialog(
      context: context,
      // barrierDismissible: false,
      barrierColor: const Color.fromRGBO(40, 40, 40, 0.95),
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          backgroundColor: Colors.transparent,
          insetAnimationCurve: Curves.easeIn,
          insetAnimationDuration: const Duration(milliseconds: 500),
          child: SuccessfullyCreatedLeague(),
        );
      });
}

class SuccessfullyCreatedLeague extends StatelessWidget {
  const SuccessfullyCreatedLeague({super.key});

  void _copyText(BuildContext context, text) {
    Clipboard.setData(ClipboardData(text: text));
    Flushbar(
      message: 'Copied to clipboard',
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.GROUNDED,
      backgroundColor: Colors.green,
      duration: Duration(seconds: 3),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FantasyLeagueBloc, FantasyLeagueState>(
      builder: (context, state) {
        return SizedBox(
          height: 450.h,
          width: 350.w,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ProductImageRoutes.leagueSuccessModalBg),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 15.h,),
                StrokeText(
                  text: state.createdLeagueData!['name'],
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  strokeColor: Colors.black.withOpacity(0.25),
                  strokeWidth: 1,
                ),
                SizedBox(
                  height: 70.h,
                ),
                Image.asset(
                  ProductImageRoutes.multiplayerGembox,
                  width: 85.w,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  'Get your friends to join your league! \nShare your league code!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  width: 260.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                      border:
                      Border.all(color: Color(0xFFD8B98C)),
                      borderRadius: BorderRadius.circular(4.r)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Text(
                        state.createdLeagueData!['code'],
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF014CA3),
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () => _copyText(context, state.createdLeagueData!['code']),
                        child: Icon(
                          Icons.copy,
                          color: Color(0xFF014CA3),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 40.h,),
                BlueButton(buttonText: 'Open my fantasy league',
                  buttonIsLoading: false,
                  width: 280.w,
                  onTap: () => Navigator.pop(context),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
