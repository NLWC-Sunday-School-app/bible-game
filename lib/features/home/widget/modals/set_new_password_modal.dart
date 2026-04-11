import 'package:another_flushbar/flushbar.dart';
import 'package:bible_game/shared/features/localization/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/features/home/widget/modals/reset_password_success_modal.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import '../../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../../shared/utils/validation.dart';
import '../../../../shared/widgets/blue_button.dart';

void showSetNewPasswordModal(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.75),
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        backgroundColor: Colors.transparent,
        child: const SetNewPasswordModal(),
      );
    },
  );
}

class SetNewPasswordModal extends StatefulWidget {
  const SetNewPasswordModal({super.key});

  @override
  State<SetNewPasswordModal> createState() => _SetNewPasswordModalState();
}

class _SetNewPasswordModalState extends State<SetNewPasswordModal>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _newPasswordFormKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final FocusNode _newPassFocus = FocusNode();
  final FocusNode _confirmPassFocus = FocusNode();
  bool _obscureNew = true;
  bool _obscureConfirm = true;
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
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    _newPassFocus.dispose();
    _confirmPassFocus.dispose();
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
                                Color(0xFFFFE066),
                                Color(0xFFFFAA00),
                                Color(0xFFFF8800),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFAA00).withOpacity(0.4),
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
                            Icons.vpn_key_rounded,
                            color: const Color(0xFF7A3800),
                            size: 28.sp,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        StrokeText(
                          text: tr.t('auth_set_password'),
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
                          tr.t('auth_set_password_subtitle'),
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
                      key: _newPasswordFormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildPasswordField(
                            controller: newPasswordController,
                            focusNode: _newPassFocus,
                            hint: tr.t('auth_new_password_hint'),
                            obscure: _obscureNew,
                            onToggle: () =>
                                setState(() => _obscureNew = !_obscureNew),
                            action: TextInputAction.next,
                            onSubmit: (_) => FocusScope.of(context)
                                .requestFocus(_confirmPassFocus),
                            validator: (t) => Validator.validatePassword(t!),
                          ),
                          SizedBox(height: 16.h),
                          _buildPasswordField(
                            controller: confirmPasswordController,
                            focusNode: _confirmPassFocus,
                            hint: tr.t('auth_confirm_password_hint'),
                            obscure: _obscureConfirm,
                            onToggle: () => setState(
                                () => _obscureConfirm = !_obscureConfirm),
                            action: TextInputAction.done,
                            onSubmit: (_) => _submit(soundManager),
                            validator: (t) =>
                                Validator.validateConfirmPassword(
                                    t!, newPasswordController.text),
                          ),
                          SizedBox(height: 28.h),
                          BlocConsumer<AuthenticationBloc, AuthenticationState>(
                            listener: (context, state) {
                              if (state.hasResetPassword) {
                                Navigator.pop(context);
                                Flushbar(
                                  message: tr.t('auth_password_reset_success'),
                                  flushbarPosition: FlushbarPosition.TOP,
                                  flushbarStyle: FlushbarStyle.GROUNDED,
                                  backgroundColor: Colors.green,
                                  duration: const Duration(seconds: 3),
                                ).show(context);
                                showResetPasswordSuccessModal(context);
                              }
                            },
                            builder: (context, state) {
                              return BlueButton(
                                width: double.infinity,
                                buttonText: tr.t('auth_set_new_password'),
                                buttonIsLoading: state.isResettingPassword,
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

  Widget _buildPasswordField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    TextInputAction? action,
    String? Function(String?)? validator,
    void Function(String)? onSubmit,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: action,
      obscureText: obscure,
      onFieldSubmitted: onSubmit,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp("[A-Za-z0-9#-]*")),
      ],
      style: TextStyle(color: Colors.white, fontSize: 14.sp),
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF0F2A4A),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 14.w, right: 10.w),
          child: Icon(Icons.lock_outline_rounded,
              color: const Color(0xFFFFBB33), size: 20.sp),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 44.w),
        suffixIcon: GestureDetector(
          onTap: onToggle,
          child: Padding(
            padding: EdgeInsets.only(right: 14.w),
            child: Icon(
              obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
              color: const Color(0xFF5A7A9A),
              size: 20.sp,
            ),
          ),
        ),
        suffixIconConstraints: BoxConstraints(minWidth: 40.w),
        hintText: hint,
        hintStyle: TextStyle(color: const Color(0xFF456080), fontSize: 14.sp),
        errorStyle: TextStyle(
          fontSize: 11.sp,
          color: const Color(0xFFFF6B6B),
          fontWeight: FontWeight.w500,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Color(0xFF1A3A5E), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Color(0xFFFFBB33), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: Color(0xFFFF6B6B), width: 2),
        ),
      ),
    );
  }

  void _submit(dynamic soundManager) {
    soundManager.playClickSound();
    FocusScope.of(context).unfocus();
    if (_newPasswordFormKey.currentState!.validate()) {
      context
          .read<AuthenticationBloc>()
          .add(ResetPassword(newPasswordController.text));
    }
  }
}
