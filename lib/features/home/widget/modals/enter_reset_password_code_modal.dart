import 'package:bible_game/shared/features/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/features/home/widget/modals/set_new_password_modal.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../../shared/widgets/blue_button.dart';
import '../../../../shared/widgets/custom_toast.dart';

void showEnterResetPasswordCodeModal(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.75),
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        backgroundColor: Colors.transparent,
        child: const EnterResetPasswordCodeModal(),
      );
    },
  );
}

class EnterResetPasswordCodeModal extends StatefulWidget {
  const EnterResetPasswordCodeModal({super.key});

  @override
  State<EnterResetPasswordCodeModal> createState() =>
      _EnterResetPasswordCodeModalState();
}

class _EnterResetPasswordCodeModalState
    extends State<EnterResetPasswordCodeModal>
    with SingleTickerProviderStateMixin {
  final textController = TextEditingController();
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    textController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    final tr = AppLocalization.tr(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Container(
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Header ──
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 20.h, bottom: 28.h),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF2E7FE8),
                          Color(0xFF1565C0),
                          Color(0xFF0D50A0),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 16.w),
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
                        ),
                        SizedBox(height: 4.h),
                        Container(
                          width: 64.w,
                          height: 64.w,
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
                                blurRadius: 16,
                                spreadRadius: 2,
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white.withOpacity(0.5),
                              width: 3,
                            ),
                          ),
                          child: Icon(
                            Icons.pin_rounded,
                            color: Colors.white,
                            size: 30.sp,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        StrokeText(
                          text: tr.t('auth_code_sent'),
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Mikado',
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w900,
                          ),
                          strokeColor: const Color(0xFF042A6B),
                          strokeWidth: 5,
                        ),
                        SizedBox(height: 6.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Text(
                            tr.t('auth_code_sent_subtitle'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.white.withOpacity(0.65),
                              fontFamily: 'Mikado',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    height: 4,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFFAA00),
                          Color(0xFFFFD700),
                          Color(0xFFFFE066),
                          Color(0xFFFFD700),
                          Color(0xFFFFAA00),
                        ],
                      ),
                    ),
                  ),

                  // ── Pin Code ──
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 24.h),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF0C2244),
                          Color(0xFF071832),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        PinCodeTextField(
                          autoDisposeControllers: false,
                          mainAxisAlignment: MainAxisAlignment.center,
                          length: 4,
                          scrollPadding: EdgeInsets.zero,
                          animationType: AnimationType.fade,
                          textStyle: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          pinTheme: PinTheme(
                            fieldOuterPadding: EdgeInsets.all(5.w),
                            inactiveFillColor: const Color(0xFF0F2A4A),
                            inactiveColor: const Color(0xFF1A3A5E),
                            activeColor: const Color(0xFFFFBB33),
                            selectedColor: const Color(0xFFFFBB33),
                            selectedFillColor: const Color(0xFF0F2A4A),
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(14.r),
                            fieldHeight: 56.w,
                            fieldWidth: 56.w,
                            activeFillColor: const Color(0xFF0F2A4A),
                            borderWidth: 2,
                          ),
                          animationDuration: const Duration(milliseconds: 300),
                          enableActiveFill: true,
                          controller: textController,
                          onCompleted: (text) {},
                          appContext: context,
                          onChanged: (String value) {},
                        ),
                        SizedBox(height: 24.h),
                        BlocConsumer<AuthenticationBloc, AuthenticationState>(
                          listener: (context, state) {
                            if (state.hasVerifiedCode) {
                              Navigator.pop(context);
                              showCustomToast(
                                  context, tr.t('auth_verification_success'));
                              showSetNewPasswordModal(context);
                            }
                          },
                          builder: (context, state) {
                            return BlueButton(
                              width: double.infinity,
                              buttonText: tr.t('auth_verify_code'),
                              buttonIsLoading: state.isVerifyingCode,
                              onTap: () {
                                soundManager.playClickSound();
                                if (textController.text.length == 4) {
                                  context.read<AuthenticationBloc>().add(
                                      VerifyOTP(textController.text));
                                }
                              },
                            );
                          },
                        ),
                        SizedBox(height: 12.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
