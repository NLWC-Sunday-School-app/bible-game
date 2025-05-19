import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
class BottomTabItemTabletView extends StatelessWidget {
  const BottomTabItemTabletView({Key? key, required this.itemLabel, required this.itemIcon, required this.itemIsSelected, required this.onTap}) : super(key: key);
  final String itemLabel;
  final String itemIcon;
  final bool itemIsSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return  GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 400),
        width: itemIsSelected ? 200.w :  (Get.width - 200.w) / 4 ,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedContainer(
                height: 120.h,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      width: 1.w,
                      color: const Color(0xFFFFFFFF),
                    ),
                  ),
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
                duration: const Duration(milliseconds: 400)
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(itemIcon, width: itemIsSelected ? 93.w : 73.w,),
                    itemIsSelected ? Text(itemLabel, style: TextStyle(
                        fontFamily: 'Mikado',
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w900
                    ),) : const SizedBox()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
