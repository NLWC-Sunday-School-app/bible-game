import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ModalBlueButton extends StatelessWidget {
  const ModalBlueButton({Key? key, required this.buttonText, this.onTap, required this.buttonIsLoading}) : super(key: key);
  final String buttonText;
  final VoidCallback? onTap;
  final bool buttonIsLoading;
  @override
  Widget build(BuildContext context) {
    return  InkWell(
       onTap: onTap,
      child: Container(
        width: 240.w,
        padding: EdgeInsets.symmetric(
            vertical: 12.h, horizontal: 15.w),
        decoration: BoxDecoration(
          border: Border.all(
              color: const Color(0xFF1E62D4), width: 3.w),
          borderRadius: BorderRadius.all(Radius.circular(10.r)),
          image: const DecorationImage(
            image: AssetImage(
                'assets/images/aesthetics/blue_btn_bg.png'),
            fit: BoxFit.fill,
          ),
        ),
        child:
        buttonIsLoading ? Center(
            child: SizedBox(
                height: 20.w,
                width: 20.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                )),
          ) : Text(
          buttonText,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Mikado',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white),
        ),
      ),
    );
  }
}
