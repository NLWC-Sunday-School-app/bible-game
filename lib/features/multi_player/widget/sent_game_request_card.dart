import 'package:bible_game/features/multi_player/bloc/multiplayer_bloc.dart';
import 'package:bible_game/features/multi_player/bloc/multiplayer_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../shared/constants/image_routes.dart';


class SentGameRequestCard extends StatelessWidget {
  const SentGameRequestCard({super.key, required this.userAvatar, required this.userName, required this.state, required this.inviteId});
  final String userAvatar;
  final String userName;
  final MultiplayerState state;
  final String inviteId;


  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        height: 60.h,
        margin: EdgeInsets.only(top: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Color(0xFFF4FFCE)),
          color: Color(0xFFF9EDBB),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFF8BA725),
              offset: Offset(1, 5),
              blurRadius: 0,
              spreadRadius: -2,
            ),
            BoxShadow(
              color: Colors.black26,
              offset: Offset(1, 5),
              blurRadius: 0,
              spreadRadius: -2,
            ),
          ],
        ),
        child:
        state.isLoadingAcceptInvite || state.isLoadingRejectInvite?
            Center(child: CircularProgressIndicator())
            :
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                  border:
                  Border.all(color: Color(0xFF366ABC)),
                  shape: BoxShape.circle),
            ),
            SizedBox(
              width: 5.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StrokeText(
                  text: userName,
                  textStyle: TextStyle(
                    color: Color(0xFF0D468A),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                  ),
                  strokeColor: Color(0xFFF4FFCE),
                  strokeWidth: 3,
                ),
                Text(
                  'sent you a game request.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                BlocProvider.of<MultiplayerBloc>(context).add(Reject(inviteId));
              },
              child: Image.asset(
                IconImageRoutes.redCircleClose,
                width: 65.w,
              ),
            ),
            GestureDetector(
              onTap: () {
                BlocProvider.of<MultiplayerBloc>(context).add(AcceptAndJoin(inviteId));
              },
              child: Image.asset(
                IconImageRoutes.greenCircleMark,
                width: 40.w,
              ),
            )
          ],
        ),

      ),
    );
  }
}
