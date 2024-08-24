import 'package:bible_game_api/model/quick_game_topic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/constants/image_routes.dart';
import '../../../shared/features/settings/bloc/settings_bloc.dart';
import '../bloc/quick_game_bloc.dart';

class SelectedTopicPill extends StatelessWidget {
  const SelectedTopicPill({super.key, required this.topic, required this.id});

  final String topic;
  final int id;

  @override
  Widget build(BuildContext context) {
    final QuickGameBloc bloc = BlocProvider.of<QuickGameBloc>(context);
    final soundManager = context.read<SettingsBloc>().soundManager;
    return  GestureDetector(
      onTap: () {
        soundManager.playClickSound();
      bloc.add(SelectQuickGameTopic(QuickGameTopic(id: id, tag: topic)));
    },
      child: Container(
        constraints: new BoxConstraints(
          maxWidth: 120.w,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
          vertical: 5.h,
        ),
        decoration: BoxDecoration(
            color: Color(0xFFFDFFF7),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: Color(0xFF38AECC), width: 1.5.w)
        ),
        child: Row(
          children: [
            Text(
              topic,
              style: TextStyle(
                fontSize: 13.sp,
                color: Color(0xFF2A539E),
                fontWeight: FontWeight.w500
              ),
            ),
            Spacer(),
            Image.asset(IconImageRoutes.blueCancel, width: 16.w,)
          ],
        ),
      ),
    );
  }
}
