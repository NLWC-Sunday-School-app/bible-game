import 'package:bible_game_api/model/quick_game_topic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/constants/colors.dart';
import '../../../shared/constants/image_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/quick_game_bloc.dart';

class TopicTag extends StatelessWidget {
  const TopicTag({super.key, required this.topic, required this.id});

  final String topic;
  final int id;

  @override
  Widget build(BuildContext context) {
    final QuickGameBloc bloc = BlocProvider.of<QuickGameBloc>(context);
    return BlocBuilder<QuickGameBloc, QuickGameState>(
      builder: (context, state) {
        bool isSelected = state.selectedGameTopics
                ?.contains(QuickGameTopic(id: id, tag: topic)) ??
            false;
        return GestureDetector(
          onTap: () {
            bloc.add(SelectQuickGameTopic(QuickGameTopic(id: id, tag: topic)));
          },
          child: Container(

            child: Center(
              child: Stack(
                children: [
                  Container(
                    // width: 100.w,
                    // height: 150.h,
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
                  Positioned(
                    top: 50.h,
                    left: 0.w,
                    right: 0.w,
                    child: Text(
                      topic,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.sp,
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
