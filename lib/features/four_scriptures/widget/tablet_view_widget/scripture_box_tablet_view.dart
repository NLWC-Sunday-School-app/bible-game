import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/features/four_scriptures/bloc/four_scriptures_one_word_bloc.dart';
import 'package:bible_game/features/four_scriptures/widget/modal/scripture_modal.dart';
import 'package:bible_game/shared/constants/image_routes.dart';

import '../../../../shared/features/settings/bloc/settings_bloc.dart';

class ScriptureBoxTabletView extends StatelessWidget {
  const ScriptureBoxTabletView({
    Key? key,
    required this.scripture,
    required this.unFormattedScripture,
  }) : super(key: key);
  final String scripture;
  final String unFormattedScripture;

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    return GestureDetector(
      onTap: () {
        soundManager.playClickSound();
        BlocProvider.of<FourScripturesOneWordBloc>(context).add(FetchBibleVerse(unFormattedScripture));
        showScriptureModal(context, unFormattedScripture);
      },
      child: Container(
        height: 180.h,
        width: 180.w,
        // padding: EdgeInsets.all(35.w),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(ProductImageRoutes.scriptureWoodenBg),
              fit: BoxFit.fill
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              scripture,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}