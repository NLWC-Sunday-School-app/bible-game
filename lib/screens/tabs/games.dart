import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabGamesScreen extends StatelessWidget {
  const TabGamesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 25.h),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(110, 91, 220, 1),
                    Color.fromRGBO(60, 46, 144, 1),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/games_cloud.png',
                    width: 240.w,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 80.h),
              child: Text(
                'Games',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.sp,
                    color: Colors.white),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 120.h, bottom: 20.h),
              child: Padding(
                padding: EdgeInsets.only(left: 31.0.w, right: 31.w),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, i) => Center(
                    child: Container(
                        padding: EdgeInsets.only(top: 25.w, bottom: 25.w),
                        width: 151.w,
                        height: 169.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.r),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromRGBO(152, 152, 152, 1).withOpacity(0.2),
                              spreadRadius: 3,
                              blurRadius: 4,
                              offset: const Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                    ),
                  ),
                  itemCount: 8,
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 250.h),
              child: Text(
                'Coming \nsoon',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 34.sp,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
