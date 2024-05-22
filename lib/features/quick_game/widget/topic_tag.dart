import 'package:flutter/material.dart';

import '../../../shared/constants/colors.dart';
import '../../../shared/constants/image_routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopicTag extends StatelessWidget {
  const TopicTag({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
          child: Stack(
            children: [
              Container(
                // width: 100.w,
                // height: 150.h,
                decoration: BoxDecoration(
                  // color: Colors.red,
                  image: DecorationImage(
                    image: AssetImage(ProductImageRoutes.activeQuickGameTag),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Positioned(
                top: 70.h,
                left: 0.w,
                right: 0.w,
                child: Text(
                  'Second Coming',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2B539E),
                  ),
                ),
              )
            ],
          ),
        ),

    );
  }
}
