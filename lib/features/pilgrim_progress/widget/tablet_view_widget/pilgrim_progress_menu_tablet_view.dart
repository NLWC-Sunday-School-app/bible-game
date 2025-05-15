import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:bible_game/shared/constants/image_routes.dart';

class PilgrimProgressLevelMenuTabletView extends StatelessWidget {
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

  const PilgrimProgressLevelMenuTabletView({
    Key? key,
    required this.menuImage,
    required this.menuNumber,
    required this.menuLabel,
    required this.isLocked,
    required this.menuProgressValue,
    required this.totalPointsGained,
    required this.boxShadowColor,
    required this.totalPointsAvailable,
    required this.onTap,
    required this.textSpan,
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
        mainAxisAlignment: MainAxisAlignment.center,
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
                          width: 120.w,
                        ),
                        SizedBox(
                          height: 120.w,
                          width: 120.w,
                          child: CircularProgressIndicator(
                            value: menuProgressValue,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF538AD4),
                            ),
                            strokeWidth: 8,
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
          SizedBox(width: 28.w,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                menuLabel,
                style:
                    TextStyle(color: const Color(0xFF548CD7), fontWeight: FontWeight.w900, fontSize: 30.sp),
              ),
              SizedBox(
                height: 5.sp,
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
                            image: AssetImage(!isLocked
                                ? ProductImageRoutes.ppActiveBlueBtn
                                : ProductImageRoutes.ppInactiveBlueBtn),
                            fit: BoxFit.fill,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4))),
                      child: Row(
                        children: [
                          isLocked
                              ? SvgPicture.asset(
                                 IconImageRoutes.whitePadlock,
                            width: 20.w,
                            height: 20.h,
                                )
                              : const SizedBox(),
                          isLocked
                              ? SizedBox(
                                  width: 5.w,
                                )
                              : const SizedBox(),
                          Text(
                            !isLocked
                                ? (totalPointsGained < totalPointsAvailable &&
                                        totalPointsGained != 0
                                    ? 'Resume Level'
                                    : (totalPointsGained >= totalPointsAvailable
                                        ? 'Keep Playing'
                                        : 'Start Level'))
                                : 'Locked',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp),
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
                          IconImageRoutes.star,
                          width: 32.w,
                        )
                      : const SizedBox(),
                  SizedBox(
                    width: 5.w,
                  ),
                  !isLocked
                      ? Text(
                          formatter.format(totalPointsGained),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
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
