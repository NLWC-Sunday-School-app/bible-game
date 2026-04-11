import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import '../../constants/app_routes.dart';
import '../../features/settings/bloc/settings_bloc.dart';

void showDeleteAccountModal(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.8),
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 30.w),
        backgroundColor: Colors.transparent,
        child: const DeleteAccountModal(),
      );
    },
  );
}

class DeleteAccountModal extends StatelessWidget {
  const DeleteAccountModal({super.key});

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;

    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state.hasLoggedOut) {
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.home, (Route<dynamic> route) => false);
          GetStorage().remove('user_token');
          GetStorage().remove('refresh_token');
        }
      },
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: const Color(0xFFFF6B6B).withOpacity(0.4),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF4444).withOpacity(0.2),
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
              padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 24.w),
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
                      onTap: () {
                        soundManager.playClickSound();
                        Navigator.pop(context);
                      },
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

                  // Warning icon
                  Container(
                    width: 72.w,
                    height: 72.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFFF6B6B),
                          Color(0xFFEE5A24),
                          Color(0xFFC0392B),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFEE5A24).withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withOpacity(0.4),
                        width: 3,
                      ),
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.white,
                      size: 36.sp,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  StrokeText(
                    text: 'Delete Account?',
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Mikado',
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w900,
                    ),
                    strokeColor: const Color(0xFF042A6B),
                    strokeWidth: 4,
                  ),
                  SizedBox(height: 12.h),

                  Text(
                    "You will lose all your data\nand won't be able to get it back.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13.sp,
                      color: Colors.white.withOpacity(0.6),
                      fontFamily: 'Mikado',
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 28.h),

                  // Keep account button
                  GestureDetector(
                    onTap: () {
                      soundManager.playClickSound();
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.r),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2E7FE8), Color(0xFF1565C0)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF1565C0).withOpacity(0.3),
                            offset: const Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Center(
                        child: StrokeText(
                          text: 'No, Keep My Account',
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          strokeColor: const Color(0xFF042A6B),
                          strokeWidth: 3,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Delete button
                  GestureDetector(
                    onTap: () {
                      soundManager.playClickSound();
                      context.read<AuthenticationBloc>().add(DeleteAccount());
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: const Color(0xFFFF6B6B).withOpacity(0.4),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: state.isDeletingAccount
                            ? SizedBox(
                                height: 18.h,
                                width: 18.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFFFF6B6B),
                                ),
                              )
                            : Text(
                                'Yes, Delete',
                                style: TextStyle(
                                  color: const Color(0xFFFF6B6B),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
