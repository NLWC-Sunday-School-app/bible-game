import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_bible_game/features/four_scriptures/bloc/four_scriptures_one_word_bloc.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';


void showScriptureModal(BuildContext context, String bibleText){
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context){
      return ScriptureModal(bibleText: bibleText,);
    }
  );
}


class ScriptureModal extends StatelessWidget {
  const ScriptureModal({super.key, required this.bibleText});
  final String bibleText;

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<FourScripturesOneWordBloc, FourScripturesOneWordState>(
  builder: (context, state) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.4,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            topLeft: Radius.circular(15),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    IconImageRoutes.blueCircleClose,
                    width: 50.w,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                bibleText,
                style: TextStyle(
                    color: const Color(0xFF548CD7),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                'King James Version',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 13.sp,
                  color: const Color(0xFFA7A7A7),
                ),
              ),
              SizedBox(height: 20.h),
              state.isFetchingBibleVerse!
                    ? Container(
                  margin: EdgeInsets.only(top: 20.h),
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF548CD7),),
                  ),
                )
                    : Text(
                  state.bibleText,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      height: 1.8,
                      color: const Color(0xFF292929)),
                ),

            ],
          ),
        ),
      ),
    );
  },
);
  }
}
