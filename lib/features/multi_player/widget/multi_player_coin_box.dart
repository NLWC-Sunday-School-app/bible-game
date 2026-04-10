import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/shared/constants/image_routes.dart';

class MultiplayerCoinBox extends StatelessWidget {
  const MultiplayerCoinBox({super.key, required this.createdChallenge, required this.userName, required this.pointsGained, required this.userAvatar});
  final bool createdChallenge;
  final String userName;
  final String pointsGained;
  final String userAvatar;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 140.w,
          height: 48.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 115.w,
                height: 21.h,
                padding: createdChallenge ? EdgeInsets.only(right: 20.w) : EdgeInsets.only(left: 20.w),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1.2.w),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(16.r),
                    bottomLeft: Radius.circular(4.r),
                    bottomRight: Radius.circular(4.r),
                  ),
                  color: createdChallenge ? Color(0xFF08B2E3) : Color(0xFFEE6352),
                ),
                child: Center(
                  child: Text(
                    userName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 11.sp
                    ),
                  ),
                ),
              ),
              Container(
                width: 100.w,
                height: 21.h,
                padding: createdChallenge ? EdgeInsets.only(right: 20.w) : EdgeInsets.only(left: 20.w),
                decoration: BoxDecoration(
                  border: Border.all(color: createdChallenge ? Color(0xFF08B2E3) : Color(0xFFEE6352), width: 1.2.w),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.r),
                    topRight: Radius.circular(4.r),
                    bottomLeft: Radius.circular(16.r),
                    bottomRight: Radius.circular(16.r),
                  ),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      IconImageRoutes.coinIcon,
                      width: 15.w,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      pointsGained,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFE56205),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Positioned(
          right: createdChallenge ? 0 : 105,
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: createdChallenge ? Color(0xFF08B2E3) : Color(0xFFEE6352), width: 2.w),
                shape: BoxShape.circle),
            child: Container(
                padding: EdgeInsets.all(3.w),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                child: Image.network(
                  userAvatar,
                  width: 40.w,
                )),
          ),
        )
      ],
    );
  }
}
