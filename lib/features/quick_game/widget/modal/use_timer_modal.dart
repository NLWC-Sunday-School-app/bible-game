import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/shared/widgets/green_button.dart';

import '../../../../shared/constants/app_routes.dart';
import '../../../../shared/constants/image_routes.dart';
import '../../../../shared/features/settings/bloc/settings_bloc.dart';
import '../../../store/bloc/power_up_bloc.dart';
import '../../../store/bloc/power_up_event.dart';
import '../../../store/model/power_up.dart';

void showUseTimerModal(BuildContext context) {
  showDialog(
      context: context,
      barrierColor: const Color.fromRGBO(40, 40, 40, 0.95),
      builder: (BuildContext context) {
        return UserTimerModal();
      });
}

class UserTimerModal extends StatefulWidget {
  const UserTimerModal({super.key});

  @override
  State<UserTimerModal> createState() => _UserTimerModalState();
}

class _UserTimerModalState extends State<UserTimerModal> {
  bool _doubleCoins = false;
  bool _secondChance = false;

  void _startGame(bool hasTimer) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    soundManager.playClickSound();

    // Deduct activated power-ups from inventory
    if (_doubleCoins) {
      context.read<PowerUpBloc>().add(UsePowerUp(PowerUpType.doubleCoins));
    }
    if (_secondChance) {
      context.read<PowerUpBloc>().add(UsePowerUp(PowerUpType.secondChance));
    }

    Navigator.pushNamed(context, AppRoutes.questionLoadingScreen, arguments: {
      'gameType': 'quick_game',
      'hasTimer': hasTimer,
      'doubleCoins': _doubleCoins,
      'secondChance': _secondChance,
    });
  }

  @override
  Widget build(BuildContext context) {
    final soundManager = context.read<SettingsBloc>().soundManager;
    final powerUpState = context.watch<PowerUpBloc>().state;
    final doubleCoinsQty =
        powerUpState.getQuantity(PowerUpType.doubleCoins);
    final secondChanceQty =
        powerUpState.getQuantity(PowerUpType.secondChance);
    final hasAnyBoost = doubleCoinsQty > 0 || secondChanceQty > 0;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ProductImageRoutes.streakModalBg),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20.h),
              Row(
                children: [
                  SizedBox(width: 40.w),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      soundManager.playClickSound();
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      IconImageRoutes.blueCircleCancel,
                      width: 35.w,
                    ),
                  ),
                  SizedBox(width: 10.w),
                ],
              ),
              SizedBox(height: 20.h),
              Text(
                'How do you want to play \nyour quick game?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 24.h),
              // Power-up activation section
              if (hasAnyBoost) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      Text(
                        'Activate Boosts',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFFFD700),
                          fontFamily: 'Mikado',
                        ),
                      ),
                      SizedBox(height: 10.h),
                      if (doubleCoinsQty > 0)
                        _BoostToggle(
                          iconPath: IconImageRoutes.coinIcon,
                          label: 'Double Coins',
                          subtitle: '2x coins this game',
                          quantity: doubleCoinsQty,
                          isActive: _doubleCoins,
                          accentColor: const Color(0xFFFFD700),
                          onToggle: () =>
                              setState(() => _doubleCoins = !_doubleCoins),
                        ),
                      if (doubleCoinsQty > 0 && secondChanceQty > 0)
                        SizedBox(height: 8.h),
                      if (secondChanceQty > 0)
                        _BoostToggle(
                          iconPath: IconImageRoutes.arrowCircleBack,
                          label: 'Second Chance',
                          subtitle: 'Retry 1 wrong answer',
                          quantity: secondChanceQty,
                          isActive: _secondChance,
                          accentColor: const Color(0xFF7BED9F),
                          onToggle: () =>
                              setState(() => _secondChance = !_secondChance),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
              ],
              GreenButton(
                onTap: () => _startGame(true),
                buttonIsLoading: false,
                width: 310.w,
                customWidget: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      IconImageRoutes.greenTimer,
                      width: 20.w,
                    ),
                    SizedBox(width: 10.w),
                    StrokeText(
                      text: 'Play with a timer',
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      strokeColor: const Color(0xFF272D39),
                      strokeWidth: 3,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () => _startGame(false),
                child: Container(
                  width: 310.w,
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(ProductImageRoutes.newBlueBtnBg),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Center(
                    child: StrokeText(
                      text: 'Play without a timer',
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      strokeColor: const Color(0xFF272D39),
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

/// Toggle row for activating a boost before game start
class _BoostToggle extends StatelessWidget {
  final String iconPath;
  final String label;
  final String subtitle;
  final int quantity;
  final bool isActive;
  final Color accentColor;
  final VoidCallback onToggle;

  const _BoostToggle({
    required this.iconPath,
    required this.label,
    required this.subtitle,
    required this.quantity,
    required this.isActive,
    required this.accentColor,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isActive
              ? accentColor.withOpacity(0.2)
              : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isActive
                ? accentColor.withOpacity(0.7)
                : Colors.white.withOpacity(0.15),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Image.asset(iconPath, width: 22.w, height: 22.w),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.white60,
                    ),
                  ),
                ],
              ),
            ),
            // Quantity badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                'x$quantity',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white70,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            // Toggle indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 40.w,
              height: 22.h,
              decoration: BoxDecoration(
                color: isActive ? accentColor : Colors.grey.shade700,
                borderRadius: BorderRadius.circular(11.r),
              ),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment:
                    isActive ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 18.w,
                  height: 18.h,
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
