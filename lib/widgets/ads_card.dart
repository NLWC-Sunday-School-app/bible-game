import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdsCard extends StatelessWidget {
  const AdsCard({Key? key, required this.imageUrl, required this.title})
      : super(key: key);

  final String imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width >= 600 ? 510 : 350,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.r),
                  topLeft: Radius.circular(20.r)),
              child: Image.network(
                imageUrl,
                width: Get.width >= 600 ? 510 : 350,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: AutoSizeText(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
            ),
          )
        ],
      ),
    );
  }
}
