import 'package:another_flushbar/flushbar.dart';
import 'package:bible_game/shared/features/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/features/home/widget/modals/enter_reset_password_code_modal.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:stroke_text/stroke_text.dart';
import '../../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../../shared/utils/validation.dart';
import '../../../../shared/widgets/blue_button.dart';

void showResetPasswordModal(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.75),
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        backgroundColor: Colors.transparent,
        child: const ResetPasswordModal(),
      );
    },
  );
}

class ResetPasswordModal extends StatefulWidget {
  const ResetPasswordModal({super.key});

  @override
  State<ResetPasswordModal> createState() => _ResetPasswordModalState();
}

class _ResetPasswordModalState extends State<ResetPasswordModal>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _resetPasswordFormKey = GlobalKey<FormState>();
  final textController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
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
    _emailFocus.dispose();
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
                                Color(0xFF7EE8FA),
                                Color(0xFF3BA8D8),
                                Color(0xFF0D80B0),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF3BA8D8).withOpacity(0.4),
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
                            Icons.lock_reset_rounded,
                            color: Colors.white,
                            size: 30.sp,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        StrokeText(
                          text: tr.t('auth_reset_password'),
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Mikado',
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w900,
                          ),
                          strokeColor: const Color(0xFF042A6B),
                          strokeWidth: 5,
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          tr.t('auth_reset_password_subtitle'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.white.withOpacity(0.65),
                            fontFamily: 'Mikado',
                            fontWeight: FontWeight.w500,
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

                  // ── Form ──
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
                    child: Form(
                      key: _resetPasswordFormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: textController,
                            focusNode: _emailFocus,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _submit(soundManager),
                            style: TextStyle(
                                color: Colors.white, fontSize: 14.sp),
                            validator: (t) => Validator.validateEmail(t!),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF0F2A4A),
                              prefixIcon: Padding(
                                padding:
                                    EdgeInsets.only(left: 14.w, right: 10.w),
                                child: Icon(Icons.mail_outline_rounded,
                                    color: const Color(0xFFFFBB33),
                                    size: 20.sp),
                              ),
                              prefixIconConstraints:
                                  BoxConstraints(minWidth: 44.w),
                              hintText: tr.t('auth_reset_email_hint'),
                              hintStyle: TextStyle(
                                  color: const Color(0xFF456080),
                                  fontSize: 14.sp),
                              errorStyle: TextStyle(
                                fontSize: 11.sp,
                                color: const Color(0xFFFF6B6B),
                                fontWeight: FontWeight.w500,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 16.h),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.r),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.r),
                                borderSide: const BorderSide(
                                    color: Color(0xFF1A3A5E), width: 1.5),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.r),
                                borderSide: const BorderSide(
                                    color: Color(0xFFFFBB33), width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.r),
                                borderSide: const BorderSide(
                                    color: Color(0xFFFF6B6B), width: 1.5),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.r),
                                borderSide: const BorderSide(
                                    color: Color(0xFFFF6B6B), width: 2),
                              ),
                            ),
                          ),
                          SizedBox(height: 28.h),
                          BlocConsumer<AuthenticationBloc, AuthenticationState>(
                            listener: (context, state) {
                              if (state.forgotPasswordMailSent) {
                                Navigator.pop(context);
                                Flushbar(
                                  message: tr.t('auth_otp_sent'),
                                  flushbarPosition: FlushbarPosition.TOP,
                                  flushbarStyle: FlushbarStyle.GROUNDED,
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 3),
                                ).show(context);
                                showEnterResetPasswordCodeModal(context);
                              }
                            },
                            builder: (context, state) {
                              return BlueButton(
                                width: double.infinity,
                                buttonText: tr.t('auth_send_code'),
                                buttonIsLoading:
                                    state.isSendingForgotPasswordCode,
                                onTap: () => _submit(soundManager),
                              );
                            },
                          ),
                          SizedBox(height: 12.h),
                        ],
                      ),
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

  void _submit(dynamic soundManager) {
    soundManager.playClickSound();
    FocusScope.of(context).unfocus();
    if (_resetPasswordFormKey.currentState!.validate()) {
      context
          .read<AuthenticationBloc>()
          .add(SendForgotPasswordMail(textController.text));
    }
  }
}
