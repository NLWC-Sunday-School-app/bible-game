import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({Key? key, required this.buttonText, required this.goToNextScreen, required this.isLoading}) : super(key: key);

  final String buttonText;
  final bool isLoading;
  final VoidCallback goToNextScreen;


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: goToNextScreen,
      child: Container(
        width: 250,
        padding: EdgeInsets.only(
          left: 66.w,
          right: 66.w,
          top: 16.h,
          bottom: 16.h,
        ),
        decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(224, 153, 16, 1),
                Color.fromRGBO(254, 193, 75, 1),
              ],
            ),
            borderRadius: BorderRadius.circular(20.r)),
        child: isLoading ? const Center(
          child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              )),
        ) : Text(
          buttonText,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFFFFFFFF),
          ),
        ),
      ),
    );
  }
}
