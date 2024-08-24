import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:the_bible_game/shared/constants/image_routes.dart';

void showRetryLevelModal(BuildContext context){
  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (BuildContext context){
        return  RetryLevelModal();
      }
  );
}


class RetryLevelModal extends StatelessWidget {
  const RetryLevelModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ProductImageRoutes.retryBg),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 150.h,
            ),
            Text(
              'Retry level',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                  color: Colors.white,
                  decoration: TextDecoration.none),
            ),
            SizedBox(
              height: 100.h,
            ),
            Image.asset(
              ProductImageRoutes.groupStar,
              width: 200.w,
            ),
            SizedBox(
              height: 60.h,
            ),
            Text(
              'Oops! you couldn’t \ncomplete the goal \nplay again.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.sp,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  decoration: TextDecoration.none),
            ),
            SizedBox(
              height: 100.h,
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text(
                'Tap to continue',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    decoration: TextDecoration.none),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
