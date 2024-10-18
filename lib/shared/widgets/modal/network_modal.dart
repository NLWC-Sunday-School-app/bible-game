import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:bible_game/shared/constants/app_routes.dart';
import 'package:bible_game/shared/screens/splash_screen.dart';

void showNetworkModal(BuildContext context) {
  showDialog(
      context: context,
      barrierColor: const Color.fromRGBO(40, 40, 40, 0.95),
      builder: (BuildContext context) {
        return NoNetworkModal();
      });
}

class NoNetworkModal extends StatelessWidget {
  const NoNetworkModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      child: SizedBox(
        height: 280.h,
        // width: 350.h,
        child: Container(
          padding: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Connection Error',
                style: TextStyle(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Unable to connect to the server.\ncheck your internet connection and try again',
                style: TextStyle(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 30.h,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.splashScreen);
                },
                child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      'Try again',
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 18.sp),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
