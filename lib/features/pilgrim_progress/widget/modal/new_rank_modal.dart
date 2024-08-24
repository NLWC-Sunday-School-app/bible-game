import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';

import '../../../../shared/features/settings/bloc/settings_bloc.dart';


void showNewRankModal(BuildContext context, String newLevel, String newRankBadge){
   showModalBottomSheet(
       context: context,
       isScrollControlled: true,
       isDismissible: false,
       builder: (BuildContext context){
         return NewRankModal(newLevel: newLevel, newRankBadge: newRankBadge);
       }
   );
}


class NewRankModal extends StatefulWidget {
  final String newLevel;
  final String newRankBadge;

  const NewRankModal(
      {Key? key, required this.newLevel, required this.newRankBadge})
      : super(key: key);

  @override
  State<NewRankModal> createState() => _NewLevelScreenState();
}

class _NewLevelScreenState extends State<NewRankModal> {




  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    if (context.read<SettingsBloc>().state.isSoundOn) {
      soundManager.playAchievementSound();
    }
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ProductImageRoutes.newRankBg),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100.h,
                ),
                Text(
                  'NEW LEVEL ALERT!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      decoration: TextDecoration.none),
                ),
                SizedBox(
                  height: 160.h,
                ),
                Image.asset(
                  widget.newRankBadge,
                  width: 55.w,
                ),
                SizedBox(
                  height: 60.h,
                ),
                Text(
                  'Awesome! You have \nunlocked a new level.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
                SizedBox(
                  height: 60.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 7.h),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFEDD7),
                      borderRadius: BorderRadius.all(Radius.circular(40.r))),
                  child: Text(
                    widget.newLevel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: const Color(0xFF214E8A),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none),
                  ),
                ),
                SizedBox(
                  height: 100.h,
                ),
                GestureDetector(
                  onTap: () => {Navigator.pop(context)},
                  child: Text(
                    'Tap to continue',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        decoration: TextDecoration.none),
                  ),
                ),
              ],
            ),
          ),
          // ConfettiWidget(
          //   confettiController: confettiController,
          //   shouldLoop: true,
          //   blastDirectionality: BlastDirectionality.explosive,
          // ),
        ],
      ),
    );
  }
}
