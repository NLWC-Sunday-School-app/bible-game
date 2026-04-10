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
    return   Chip(label: Text(topic, style: TextStyle(color: Color(0xFF2A539E)),),
        deleteIcon: Icon(Icons.close, color: Color(0xFF2A539E),),
        onDeleted: () {
          soundManager.playClickSound();
          bloc.add(SelectQuickGameTopic(QuickGameTopic(id: id, tag: topic)));
        },
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
          side: BorderSide(color: Color(0xFF38AECC)),
        ),
      );
  }
}
