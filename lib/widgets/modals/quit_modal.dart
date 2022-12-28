import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
class QuitModal extends StatelessWidget {
  const QuitModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: SingleChildScrollView(
        child: SizedBox(
          height: 450,
          width: 350,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/modal_layout_2.png'),
                  fit: BoxFit.fill),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AutoSizeText(
                  'ARE YOU SURE YOU\n WANT TO QUIT?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Neuland',
                    fontSize: 20,
                    color: Color(0xFF4075BB),
                  ),
                ),
                const SizedBox(height: 20,),
                const AutoSizeText(
                  'You will lose unsaved progress.',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 40,),
                GestureDetector(
                  onTap: () =>  Get.back(result: false),
                  child: Container(
                    width: 200.w,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        color: const Color(0xFFE8F8FF),
                        border: Border.all(color: const Color(0xFF548CD7)),
                        borderRadius: const BorderRadius.all(Radius.circular(40))
                    ),
                    child: Text('NO, I DONT',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Neuland',
                          letterSpacing: 1,
                          color: const Color(0xFF4075BB),
                          fontSize: 14.sp
                      ),),
                  ),
                ),
                const SizedBox(height: 20,),
                GestureDetector(
                  onTap: () => {
                    Get.back(result: true),
                    Get.back(result: true),
                    Get.back(result: true)
                  },
                  child: Container(
                    width: 200.w,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                        color: const Color(0xFF548CD7),
                        border: Border.all(color: const Color(0xFF548CD7)),
                        borderRadius: const BorderRadius.all(Radius.circular(40))
                    ),
                    child: Text('YES, QUIT',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'Neuland',
                          letterSpacing: 1,
                          color: Colors.white,
                          fontSize: 14.sp
                      ),),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
