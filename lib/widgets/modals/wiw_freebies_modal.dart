import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stroke_text/stroke_text.dart';

class WiwFreebiesModal extends StatelessWidget {
  const WiwFreebiesModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(2.w),
      backgroundColor: Colors.black.withOpacity(0.86),
      child: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/aesthetics/freebies_modal_bg.png'),
                fit: BoxFit.fill),
          ),
           child: Column(
             children: [
               SizedBox(height: 80.h,),
               Image.asset('assets/images/aesthetics/freebie_banner.png', width: 200.w,),
               SizedBox(height: 100.h,),
               Image.asset('assets/images/aesthetics/wallet_purse.png', width: 160.w,),
               Text(
                 '1000 coins won!', style: TextStyle(
                 fontFamily: 'Mikado',
                 color: Colors.white,
                 fontSize: 24.sp,
                 fontWeight: FontWeight.w900
               ),),
               const Spacer(),
               InkWell(
                 onTap: () => Get.back(),
                 child: StrokeText(
                   text:'Tap to continue',
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
               SizedBox(height: 50.h,),
             ],
           ),
        ),
      ),
    );
  }
}
