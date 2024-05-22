import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_bible_game/app.dart';
import 'package:the_bible_game/shared/constants/colors.dart';
import 'package:the_bible_game/shared/widgets/blue_button.dart';

class SearchBox extends StatefulWidget {
  const SearchBox({super.key});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Container(
        margin: EdgeInsets.only(top: 20.h),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
            color: Color(0xFFF7F6F6),
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.searchBoxBorder,
                offset: Offset(0, 5),
                blurRadius: 0,
                spreadRadius: -2,
              ),
            ]),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                cursorColor: AppColors.primaryColor,
                decoration: InputDecoration(
                  hintText: 'Search tags',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF9C9C9C)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2.w,
                      color: AppColors.searchBoxBorder,
                    ),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2.w,
                      color: AppColors.primaryColor,
                    ),
                    borderRadius: BorderRadius.circular(6.r),
                  ),

                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14.h, horizontal: 12.w),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            BlueButton(
              width: 90.w,
              buttonText: 'Search',
              buttonIsLoading: false,
            )
          ],
        ),
      ),
    );
  }
}
