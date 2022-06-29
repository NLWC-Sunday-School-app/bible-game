import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BadgesBottomModalSheet extends StatelessWidget {
  const BadgesBottomModalSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20.0.h, bottom: 10.h),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => {Navigator.pop(context)},
                  child: Padding(
                    padding: EdgeInsets.only(left: 25.0.w, right: 125.w),
                    child: Image.asset('assets/images/cancel.png', width: 12.w,),
                  ),
                ),
                Text(
                  'Badges',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15.sp,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.w),
            child: Divider(),
          )
        ],
      ),
    );
  }
}
