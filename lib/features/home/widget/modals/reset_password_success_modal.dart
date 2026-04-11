import 'package:bible_game/shared/features/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../../shared/widgets/blue_button.dart';
import 'login_modal.dart';

void showResetPasswordSuccessModal(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.75),
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 40.w),
        backgroundColor: Colors.transparent,
        child: const ResetPasswordSuccessModal(),
      );
    },
  );
}

class ResetPasswordSuccessModal extends StatelessWidget {
  const ResetPasswordSuccessModal({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalization.tr(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: const Color(0xFF5AA0F0).withOpacity(0.6),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A9EFF).withOpacity(0.35),
            blurRadius: 28,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 4,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1565C0),
                Color(0xFF0C2244),
                Color(0xFF071832),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.15),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.white.withOpacity(0.8),
                      size: 18.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),

              // Success icon
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF7BED9F),
                      Color(0xFF2ECC71),
                      Color(0xFF1A9A54),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2ECC71).withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 3,
                  ),
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 40.sp,
                ),
              ),
              SizedBox(height: 24.h),

              StrokeText(
                text: tr.t('auth_new_password_set'),
                textStyle: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Mikado',
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                ),
                strokeColor: const Color(0xFF042A6B),
                strokeWidth: 5,
              ),
              SizedBox(height: 24.h),

              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  return state.user.id == 0
                      ? BlueButton(
                          buttonText: tr.t('auth_log_in_button'),
                          buttonIsLoading: false,
                          width: double.infinity,
                          onTap: () {
                            Navigator.pop(context);
                            showLoginModal(context);
                          },
                        )
                      : const SizedBox();
                },
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }
}
