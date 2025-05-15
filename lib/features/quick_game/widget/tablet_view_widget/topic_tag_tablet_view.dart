import 'package:bible_game_api/model/quick_game_topic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/features/settings/bloc/settings_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/quick_game_bloc.dart';

class TopicTagTabletView extends StatelessWidget {
  const TopicTagTabletView({super.key, required this.topic, required this.id});

  final String topic;
  final int id;

  @override
  Widget build(BuildContext context) {
    final QuickGameBloc bloc = BlocProvider.of<QuickGameBloc>(context);
    final soundManager = context.read<SettingsBloc>().soundManager;
    return BlocBuilder<QuickGameBloc, QuickGameState>(
      builder: (context, state) {
        bool isSelected = state.selectedGameTopics
                ?.contains(QuickGameTopic(id: id, tag: topic)) ??
            false;
        return GestureDetector(
          onTap: () {
            soundManager.playClickSound();
            bloc.add(SelectQuickGameTopic(QuickGameTopic(id: id, tag: topic)));
          },
          child: Container(
            child: Center(
              child: Stack(
                children: [
                  Container(
                    // width: 151.w,
                    // height: 194.h,
                    decoration: BoxDecoration(
                      // color: Colors.red,
                      image: DecorationImage(
                        image: isSelected
                            ? AssetImage(ProductImageRoutes.activeQuickGameTag)
                            : AssetImage(
                                ProductImageRoutes.inactiveQuickGameTag),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      topic,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2B539E),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
