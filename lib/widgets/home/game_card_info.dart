import 'package:auto_size_text/auto_size_text.dart';
import 'package:bible_game/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../utilities/image_format_filter.dart';

class GameCardInfo extends StatelessWidget {
  const GameCardInfo(
      {Key? key,
      required this.gameTitle,
      required this.gameText,
      required this.gameImageUrl,
      required this.gameImageWidth,
      required this.cardColor, required this.onTap})
      : super(key: key);

  final String gameTitle;
  final String gameText;
  final String gameImageUrl;
  final double gameImageWidth;
  final int cardColor;
  final VoidCallback onTap;


  @override
  Widget build(BuildContext context) {
   final UserController userController = Get.put(UserController());
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
              color: Color(cardColor),
              offset: const Offset(0, 15),
              blurRadius: 0,
              spreadRadius: -10),
          BoxShadow(
              color: Color(cardColor),
              offset: const Offset(0, -15),
              blurRadius: 0,
              spreadRadius: -10)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 23.0.w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 21.h,
                ),
                AutoSizeText(
                  gameTitle,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontFamily: 'Mikado',
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF3C78D1),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                Text(
                  gameText,
                  style: TextStyle(
                      fontSize: 10.sp,
                      fontFamily: 'Mikado',
                      fontWeight: FontWeight.w400,
                      height: 1.5),
                ),
                SizedBox(
                  height: 14.h,
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                      padding: EdgeInsets.only(
                        left: 21.w,
                        right: 21.w,
                        top: 10.h,
                        bottom: 10.h,
                      ),
                      decoration: BoxDecoration(
                        // image: const DecorationImage(
                        //   image: AssetImage('assets/images/home_button_bg.png'),
                        //   fit: BoxFit.fill,
                        // ),
                        color: const Color(0xFF3C78D1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        'PLAY',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: 'Mikado',
                          fontSize: 12.sp,
                          color: const Color(0xFFFFFFFF),
                        ),
                      )),
                ),
                SizedBox(
                  height: 16.h,
                ),
              ],
            ),
          ),
          Flexible(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15.r), bottom: Radius.circular(15.r)),
              child: ImageFormatFilter.filterImageUrl(gameImageUrl) == 'svg'
                  ? SvgPicture.asset(
                      gameImageUrl,
                      width: gameImageWidth,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      gameImageUrl,
                      width: gameImageWidth,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
