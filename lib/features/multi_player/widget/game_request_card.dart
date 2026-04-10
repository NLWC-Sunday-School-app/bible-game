import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/constants/image_routes.dart';
class GameRequestCard extends StatelessWidget {
  const GameRequestCard({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return
      InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Container(
                height: 64.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(width: 2.w, color: Color(0xFFD43824)),
                ),
                child: Row(
                  children: [
                    SizedBox(width: 50.w,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Game Requests', style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF014CA3)
                        ),),
                        Text('READY TO RUMBLE?', style: TextStyle(
                            color: Color(0xFFA3735C),
                            fontWeight: FontWeight.w400,
                            fontSize: 7.sp,
                            letterSpacing: 3
                        ),),
                      ],
                    ),
                    SizedBox(width: 50.w,),
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                          color: Color(0xFFD43824),
                          shape: BoxShape.circle
                      ),
                      child: Text('0', style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white
                      ),),
                    ),
                    SizedBox(width: 50.w,),
                    Image.asset(ProductImageRoutes.gameRequestSword, width: 50.w,),

                  ],
                ),
              ),
              Positioned(
                top: 10.h,
                child: Image.asset(
                  ProductImageRoutes.redTag,
                  width: 50.w,
                ),
              )
            ],
          ),
        ),
      );
  }
}
