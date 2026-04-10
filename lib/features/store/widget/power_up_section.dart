import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
import '../bloc/power_up_bloc.dart';
import '../bloc/power_up_event.dart';
import '../bloc/power_up_state.dart';
import '../model/power_up.dart';
import 'power_up_card.dart';

class PowerUpSection extends StatelessWidget {
  const PowerUpSection({super.key});

  void _handlePurchase(BuildContext context, PowerUpItem item) {
    final authState = context.read<AuthenticationBloc>().state;
    final soundManager = context.read<SettingsBloc>().soundManager;
    final coinBalance = authState.user.coinWalletBalance;
    final gemBalance = authState.user.gems;

    final hasEnough = item.usesGems
        ? gemBalance >= item.price
        : coinBalance >= item.price;

    if (!hasEnough) {
      final message = item.usesGems
          ? 'Not enough gems!'
          : 'Not enough coins! Play more games';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.orange.shade800,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    soundManager.playClickSound();
    context.read<PowerUpBloc>().add(PurchasePowerUp(item.type));
    soundManager.playAchievementSound();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(
              item.emoji,
              style: TextStyle(fontSize: 18.sp),
            ),
            SizedBox(width: 8.w),
            Text(
              '${item.name} purchased!',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF7FB800),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PowerUpBloc, PowerUpState>(
      builder: (context, powerUpState) {
        return Column(
          children: [
            // Section header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: const Color(0xFF10498D),
                      thickness: 2,
                      endIndent: 12,
                    ),
                  ),
                  StrokeText(
                    text: 'POWER-UPS',
                    textStyle: TextStyle(
                      color: const Color(0xFFFFD400),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                    strokeColor: Colors.black.withOpacity(0.4),
                    strokeWidth: 4,
                  ),
                  Expanded(
                    child: Divider(
                      color: const Color(0xFF10498D),
                      thickness: 2,
                      indent: 12,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Power-up grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: 0.85,
                children: PowerUpItem.allPowerUps.map((item) {
                  return PowerUpCard(
                    item: item,
                    quantity: powerUpState.getQuantity(item.type),
                    isPurchasing: powerUpState.isPurchasing,
                    onBuy: () => _handlePurchase(context, item),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
