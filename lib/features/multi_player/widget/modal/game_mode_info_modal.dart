import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';

import '../../../../shared/features/settings/bloc/settings_bloc.dart';

/// Explains one group game mode, in the same full-screen "How to play"
/// treatment the other guides use (see who_is_who_guide.dart).
///
/// The rules here are taken from what the screens actually do, so they stay
/// true as long as those do.
void showGameModeInfoModal(
  BuildContext context, {
  required String title,
  required String image,
  required String summary,
  required List<String> rules,
  String? comingSoonNote,
}) {
  showDialog(
    context: context,
    builder: (context) => _GameModeInfoGuide(
      title: title,
      image: image,
      summary: summary,
      rules: rules,
      comingSoonNote: comingSoonNote,
    ),
  );
}

class _GameModeInfoGuide extends StatelessWidget {
  const _GameModeInfoGuide({
    required this.title,
    required this.image,
    required this.summary,
    required this.rules,
    this.comingSoonNote,
  });

  final String title;
  final String image;
  final String summary;
  final List<String> rules;
  final String? comingSoonNote;

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;

    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.black.withValues(alpha: 0.96),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 36.w, vertical: 24.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                Image.asset(image, width: 96.w, height: 96.w),
                SizedBox(height: 18.h),
                StrokeText(
                  text: title,
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Mikado',
                    fontSize: 30.sp,
                    fontWeight: FontWeight.w900,
                    shadows: const [
                      Shadow(
                        color: Color(0xFF673125),
                        blurRadius: 5.0,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  strokeColor: const Color(0xFFF1B30C),
                  strokeWidth: 5,
                ),
                SizedBox(height: 16.h),
                Text(
                  summary,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.45,
                  ),
                ),
                SizedBox(height: 26.h),
                ...rules.map(
                  (rule) => Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 7.h, right: 12.w),
                          width: 8.w,
                          height: 8.w,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF1B30C),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            rule,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              height: 1.45,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (comingSoonNote != null) ...[
                  SizedBox(height: 8.h),
                  Text(
                    comingSoonNote!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFF1B30C),
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                    ),
                  ),
                ],
                SizedBox(height: 44.h),
                InkWell(
                  onTap: () {
                    soundManager.playClickSound();
                    Navigator.pop(context);
                  },
                  child: StrokeText(
                    text: 'Tap to continue',
                    textStyle: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontFamily: 'Mikado',
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w900,
                    ),
                    strokeColor: const Color(0xFFF1B30C),
                    strokeWidth: 5,
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
