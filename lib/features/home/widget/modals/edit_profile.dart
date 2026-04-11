import 'package:bible_game/shared/features/localization/app_localization.dart';
import 'package:bible_game_api/utils/api_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import '../../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../../shared/utils/validation.dart';
import '../../../../shared/widgets/blue_button.dart';

void showEditProfileModal(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.75),
    builder: (BuildContext context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        backgroundColor: Colors.transparent,
        child: const EditProfileModal(),
      );
    },
  );
}

class EditProfileModal extends StatefulWidget {
  const EditProfileModal({super.key});

  @override
  State<EditProfileModal> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfileModal>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _updateFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    nameController.text =
        BlocProvider.of<AuthenticationBloc>(context).state.user.name;
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
    nameController.dispose();
    _nameFocus.dispose();
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
                        // Close
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
                        // Emblem
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
                            Icons.edit_rounded,
                            color: const Color(0xFF7A3800),
                            size: 30.sp,
                          ),
                        ),
                        SizedBox(height: 14.h),
                        StrokeText(
                          text: tr.t('auth_edit_profile'),
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
                          tr.t('auth_edit_profile_subtitle'),
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

                  // ── Gold divider ──
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
                      key: _updateFormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildField(
                            controller: nameController,
                            focusNode: _nameFocus,
                            hint: tr.t('auth_nickname_hint'),
                            icon: Icons.person_outline_rounded,
                            keyboardType: TextInputType.text,
                            action: TextInputAction.done,
                            onSubmit: (_) => _submitUpdate(soundManager),
                            validator: (t) => Validator.validateName(t!),
                          ),
                          SizedBox(height: 28.h),
                          BlocConsumer<UserBloc, UserState>(
                            listener: (context, state) {
                              if (state.updatedProfile) {
                                Navigator.pop(context);
                                BlocProvider.of<AuthenticationBloc>(context)
                                    .add(FetchUserDataRequested());
                              }
                              if (state.failedToUpdate == true) {
                                ApiException.showSnackBar(context);
                              }
                            },
                            builder: (context, state) {
                              return BlueButton(
                                width: double.infinity,
                                buttonText: tr.t('auth_update_profile'),
                                buttonIsLoading: state.isUpdatingProfile,
                                onTap: () => _submitUpdate(soundManager),
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

  Widget _buildField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    TextInputAction? action,
    String? Function(String?)? validator,
    void Function(String)? onSubmit,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: action,
      onFieldSubmitted: onSubmit,
      style: TextStyle(color: Colors.white, fontSize: 14.sp),
      validator: validator,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF0F2A4A),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 14.w, right: 10.w),
          child: Icon(icon, color: const Color(0xFFFFBB33), size: 20.sp),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 44.w),
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

  void _submitUpdate(dynamic soundManager) {
    soundManager.playClickSound();
    FocusScope.of(context).unfocus();
    if (_updateFormKey.currentState!.validate()) {
      context.read<UserBloc>().add(UpdateUserProfile(nameController.text));
    }
  }
}
