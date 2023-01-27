import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';

class BadgeInfo extends StatelessWidget {
  const BadgeInfo(
      {Key? key,
      required this.modalLayoutUrl,
      required this.badgeUrl,
      required this.badgeName,
      required this.badgeNameColor,
      required this.pointsBgColor,
      required this.badgeTotalPoint,
      required this.badgePointGained,
      required this.badgeSubText})
      : super(key: key);
  final String modalLayoutUrl;
  final String badgeUrl;
  final String badgeName;
  final int badgeNameColor;
  final int pointsBgColor;
  final int badgeTotalPoint;
  final int badgePointGained;
  final String badgeSubText;

  @override
  Widget build(BuildContext context) {
    final player = AudioPlayer();
    var formatter = NumberFormat('#,##,###');
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      backgroundColor: Colors.transparent,
      child: SizedBox(
        height: Get.width >= 500 ? 500.h : 450.h,
        width: Get.width >= 500 ? 600.h : 450,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(modalLayoutUrl), fit: BoxFit.fill),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 50.h,
              ),
              GestureDetector(
                onTap: () => {
                  player.setAsset('assets/audios/click.mp3'),
                  player.play(),
                  Get.back()
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 25.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/images/icons/close.png',
                        width: 40.w,
                      )
                    ],
                  ),
                ),
              ),
              Image.asset(
                badgeUrl,
                width: 40.w,
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                badgeName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Neuland',
                    fontSize: 20.sp,
                    color: Color(badgeNameColor)),
              ),
              SizedBox(
                height: 10.h,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 5.h),
                decoration: BoxDecoration(
                    color: Color(pointsBgColor),
                    borderRadius: BorderRadius.all(Radius.circular(10.r))),
                child: Text(
                  'Your Point: ${formatter.format(badgePointGained)} of ${formatter.format(badgeTotalPoint)}',
                  style: TextStyle(
                    letterSpacing: 1,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                badgeSubText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
