import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

class PilgrimProgressLevelMenu extends StatelessWidget {
  final String menuImage;
  final String menuNumber;
  final String menuLabel;
  final bool isLocked;
  final double menuProgressValue;
  final int totalPointsGained;
  final int boxShadowColor;
  final int totalPointsAvailable;
  final VoidCallback onTap;
  final Widget textSpan;

  const PilgrimProgressLevelMenu({
    Key? key,
    required this.menuImage,
    required this.menuNumber,
    required this.menuLabel,
    required this.isLocked,
    required this.menuProgressValue,
    required this.totalPointsGained,
    required this.boxShadowColor,
    required this.totalPointsAvailable, required this.onTap, required this.textSpan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('#,##,###');
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
              color: Color(boxShadowColor),
              offset: const Offset(0, 15),
              blurRadius: 0,
              spreadRadius: -10
              // blurStyle: BlurStyle.values
              )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 0.w,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          menuImage,
                          width: 60.w,
                        ),
                        SizedBox(
                          height: 80.w,
                          width: 80.w,
                          child: CircularProgressIndicator(
                            value: menuProgressValue,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF538AD4),
                            ),
                            strokeWidth: 5,
                            backgroundColor: const Color(0xFF97D3FF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                menuLabel,
                style: TextStyle(
                    fontFamily: 'Neuland',
                    color: const Color(0xFF548CD7),
                    fontSize: 20.sp),
              ),

              SizedBox(
                height: 10.sp,
              ),
              textSpan,
              SizedBox(
                height: 10.sp,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: onTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 15),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                !isLocked
                                ? 'assets/images/pilgrim_levels/pg_progress_bg.png'
                                : 'assets/images/pilgrim_levels/pg_button_inactive_bg.png'),
                            fit: BoxFit.fill,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4))),
                      child: Row(
                        children: [
                          isLocked
                              ? SvgPicture.asset(
                                  'assets/images/icons/padlock.svg')
                              : const SizedBox(),
                          isLocked
                              ? SizedBox(
                                  width: 5.w,
                                )
                              : const SizedBox(),
                          Text(
                            !isLocked ? (totalPointsGained < totalPointsAvailable && totalPointsGained != 0 ? 'Resume Level' : (totalPointsGained >= totalPointsAvailable ? 'Keep Playing' : 'Start Level'))
                                : 'Locked',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 12.sp),
                          ),
                          // Text('$isLocked')
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  !isLocked
                      ? Image.asset(
                          'assets/images/icons/star.png',
                          width: 20.w,
                        )
                      : const SizedBox(),
                  SizedBox(
                    width: 5.w,
                  ),
                  !isLocked
                      ? Text(
                          formatter.format(totalPointsGained),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontFamily: 'neuland',
                            color: const Color(0xFF548CD7),
                          ),
                        )
                      : const SizedBox(),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
