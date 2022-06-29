import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreferenceBottomModalSheet extends StatelessWidget {
  const PreferenceBottomModalSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.9,
      child: SingleChildScrollView(
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
                      child: Image.asset(
                        'assets/images/cancel.png',
                        width: 12.w,
                      ),
                    ),
                  ),
                  Text(
                    'Preferences',
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
              child: Column(
                children: [
                  Divider(),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8.0.w),
                        child: const Icon(
                          Icons.info,
                          color: Color.fromRGBO(118, 99, 229, 1),
                        ),
                      ),
                      Text(
                        'Upaates',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(82, 82, 82, 1),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 15.w,
                        color: const Color.fromRGBO(154, 154, 154, 1),
                      )
                    ],
                  ),
                  Divider(),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8.0.w),
                        child: const Icon(
                          Icons.people,
                          color: Color.fromRGBO(118, 99, 229, 1),
                        ),
                      ),
                      Text(
                        'Legal',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(82, 82, 82, 1),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 15.w,
                        color: const Color.fromRGBO(154, 154, 154, 1),
                      )
                    ],
                  ),
                  Divider(),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8.0.w),
                        child: const Icon(
                          Icons.settings,
                          color: Color.fromRGBO(118, 99, 229, 1),
                        ),
                      ),
                      Text(
                        'Advanced',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(82, 82, 82, 1),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 15.w,
                        color: const Color.fromRGBO(154, 154, 154, 1),
                      )
                    ],
                  ),
                  Divider(),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8.0.w),
                        child: const Icon(
                          Icons.star,
                          color: Color.fromRGBO(118, 99, 229, 1),
                        ),
                      ),
                      Text(
                        'Rate app',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(82, 82, 82, 1),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 15.w,
                        color: const Color.fromRGBO(154, 154, 154, 1),
                      )
                    ],
                  ),
                  Divider(),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8.0.w),
                        child: const Icon(
                          Icons.insert_drive_file_rounded,
                          color: Color.fromRGBO(118, 99, 229, 1),
                        ),
                      ),
                      Text(
                        'Policy',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(82, 82, 82, 1),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 15.w,
                        color: const Color.fromRGBO(154, 154, 154, 1),
                      )
                    ],
                  ),
                  Divider(),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Game updates ',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(151, 151, 151, 1),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            'Allow Auto Upadte',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12.sp,
                            ),
                          )
                        ],
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 15.w,
                        color: const Color.fromRGBO(154, 154, 154, 1),
                      )
                    ],
                  ),
                  Divider(),
                  SizedBox(
                    height: 15.h,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8.0.w),
                        child: const Icon(
                          Icons.wine_bar,
                          color: Color.fromRGBO(118, 99, 229, 1),
                        ),
                      ),
                      Text(
                        'Total Ranking',
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(82, 82, 82, 1)),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 15.w,
                        color: const Color.fromRGBO(154, 154, 154, 1),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
