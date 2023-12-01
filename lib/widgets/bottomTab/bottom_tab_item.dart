import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
class BottomTabItem extends StatelessWidget {
  const BottomTabItem({Key? key, required this.itemLabel, required this.itemIcon, required this.itemIsSelected, required this.onTap}) : super(key: key);
  final String itemLabel;
  final String itemIcon;
  final bool itemIsSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
            width: itemIsSelected ? 120.w :  (Get.width - 120) / 4.098 ,
            decoration: BoxDecoration(
              gradient: !itemIsSelected ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF17397E),
                  Color(0xFF2A509C),
                ],
              ) : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF3270BC),
                  Color(0xFF3270BC),
                ],
              ) ,
            ),
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(itemLabel, width: itemIsSelected ? 60.w : 40.w,),
                itemIsSelected ? Text(itemIcon, style: TextStyle(
                    fontFamily: 'Mikado',
                     color: Colors.white,
                     fontSize: 16.sp,
                     fontWeight: FontWeight.w900
                ),) : const SizedBox()
              ],
            ),

      ),
    );
  }
}
