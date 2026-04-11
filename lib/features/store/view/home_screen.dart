import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:stroke_text/stroke_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:bible_game/features/store/widget/modal/successfully_bought_gem_modal.dart';
import 'package:bible_game/shared/features/authentication/bloc/authentication_bloc.dart';
import 'package:bible_game/shared/features/connectivity/bloc/connectivity_bloc.dart';
import 'package:bible_game/shared/features/settings/bloc/settings_bloc.dart';
import 'package:bible_game/shared/features/user/bloc/user_bloc.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/constants/image_routes.dart';
import '../../../shared/widgets/green_button.dart';
import '../../home/widget/modals/create_profile_modal.dart';
import '../../home/widget/modals/login_modal.dart';
import 'package:intl/intl.dart';
import 'package:bible_game/shared/features/localization/app_localization.dart';
import '../bloc/power_up_bloc.dart';
import '../bloc/power_up_event.dart';
import '../bloc/power_up_state.dart';
import '../model/power_up.dart';

class StoreHomeScreen extends StatefulWidget {
  const StoreHomeScreen({super.key});

  @override
  State<StoreHomeScreen> createState() => _StoreHomeScreenState();
}

class _StoreHomeScreenState extends State<StoreHomeScreen> {
  void _showToast(BuildContext context, String message) {
    FToast fToast = FToast();
    fToast.init(context);
    Widget toast = Container(
      width: 375.w,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.0),
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.0),
          ],
          stops: const [0.0, 0.2, 0.8, 1.0],
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StrokeText(
            text: message,
            textStyle: TextStyle(
              color: const Color(0xFFFFD400),
              fontSize: 16.sp,
              fontWeight: FontWeight.w900,
            ),
            strokeColor: Colors.black,
            strokeWidth: 4,
          ),
        ],
      ),
    );
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.CENTER,
      toastDuration: const Duration(seconds: 2),
    );
  }

  void _handlePowerUpPurchase(BuildContext context, PowerUpItem item) {
    final authState = context.read<AuthenticationBloc>().state;
    final soundManager = context.read<SettingsBloc>().soundManager;
    final coinBalance = authState.user.coinWalletBalance;
    final gemBalance = authState.user.gems;

    final hasEnough =
        item.usesGems ? gemBalance >= item.price : coinBalance >= item.price;

    if (!hasEnough) {
      soundManager.playClickSound();
      _showToast(
        context,
        item.usesGems ? 'Not enough gems!' : 'Not enough coins!',
      );
      return;
    }

    soundManager.playClickSound();
    final userId = authState.user.id;
    context.read<PowerUpBloc>().add(PurchasePowerUp(item.type, userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###,###');
    final soundManager = context.read<SettingsBloc>().soundManager;
    final tr = AppLocalization.tr(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: AppColors.primaryColorShade,
      ),
      backgroundColor: const Color(0xFF3887E1),
      body: BlocListener<PowerUpBloc, PowerUpState>(
        listenWhen: (prev, curr) =>
            prev.isPurchasing && !curr.isPurchasing,
        listener: (context, powerUpState) {
          final soundManager = context.read<SettingsBloc>().soundManager;
          if (powerUpState.error != null) {
            // Purchase failed
            _showToast(context, powerUpState.error!);
          } else if (powerUpState.lastPurchased != null) {
            // Purchase succeeded — refresh user balance
            soundManager.playAchievementSound();
            context.read<AuthenticationBloc>().add(FetchUserDataRequested());
            final item = PowerUpItem.allPowerUps
                .firstWhere((p) => p.type == powerUpState.lastPurchased);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Image.asset(item.iconPath, width: 20.w, height: 20.w),
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
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          final user = state.user;
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ProductImageRoutes.patternTwoBg),
                fit: BoxFit.cover,
              ),
            ),
            child: user.id != 0
                ? _buildStoreContent(context, state, formatter, soundManager, tr)
                : _buildLoginContent(context, soundManager, tr),
          );
        },
      ),
      ),
    );
  }

  Widget _buildLoginContent(
      BuildContext context, dynamic soundManager, dynamic tr) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          StrokeText(
            text: tr.t('store_title'),
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.w900,
            ),
            strokeColor: AppColors.titleDropShadowColor,
            strokeWidth: 6,
          ),
          SizedBox(height: 40.h),
          GreenButton(
            onTap: () {
              soundManager.playClickSound();
              showLoginModal(context);
            },
            buttonIsLoading: false,
            width: 350.w,
            customWidget: Center(
              child: StrokeText(
                text: tr.t('profile_log_in'),
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
          SizedBox(height: 20.h),
          GestureDetector(
            onTap: () {
              soundManager.playClickSound();
              showCreateProfileModal(context);
            },
            child: Container(
              width: 350.w,
              padding: EdgeInsets.symmetric(vertical: 15.h),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProductImageRoutes.newBlueBtnBg),
                  fit: BoxFit.fill,
                ),
              ),
              child: Center(
                child: StrokeText(
                  text: tr.t('auth_create_profile'),
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
        ],
      ),
    );
  }

  Widget _buildStoreContent(
    BuildContext context,
    AuthenticationState authState,
    NumberFormat formatter,
    dynamic soundManager,
    dynamic tr,
  ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: 10.h),

          // ── Title ──
          StrokeText(
            text: tr.t('store_title'),
            textStyle: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.w900,
            ),
            strokeColor: AppColors.titleDropShadowColor,
            strokeWidth: 6,
          ),
          SizedBox(height: 12.h),

          // ── Wallet Bar ──
          _buildWalletBar(authState, formatter),
          SizedBox(height: 16.h),

          // ── Store Items ──
          SizedBox(height: 4.h),
          _buildStoreGrid(context, tr),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  WALLET BAR
  // ══════════════════════════════════════════════════════════════
  Widget _buildWalletBar(AuthenticationState authState, NumberFormat formatter) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0D2550), Color(0xFF1A3A6B)],
          ),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: const Color(0xFF4A8AD4).withOpacity(0.3),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              offset: const Offset(0, 4),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            // Coins
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(IconImageRoutes.coinIcon, width: 24.w),
                  SizedBox(width: 8.w),
                  Text(
                    formatter.format(authState.user.coinWalletBalance),
                    style: TextStyle(
                      color: const Color(0xFFFFD400),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 1.5,
              height: 24.h,
              color: Colors.white.withOpacity(0.15),
            ),
            // Gems
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(IconImageRoutes.gemIcon, width: 24.w),
                  SizedBox(width: 8.w),
                  Text(
                    '${authState.user.gems}',
                    style: TextStyle(
                      color: const Color(0xFFE0B0FF),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  // ══════════════════════════════════════════════════════════════
  //  SECTION HEADER
  // ══════════════════════════════════════════════════════════════
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    const Color(0xFFFFD400).withOpacity(0.5),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: StrokeText(
              text: title,
              textStyle: TextStyle(
                color: const Color(0xFFFFD400),
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
              strokeColor: Colors.black.withOpacity(0.4),
              strokeWidth: 4,
            ),
          ),
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFFD400).withOpacity(0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  STORE GRID (Gem + Power-Ups in one unified grid)
  // ══════════════════════════════════════════════════════════════
  Widget _buildStoreGrid(BuildContext context, dynamic tr) {
    return BlocBuilder<PowerUpBloc, PowerUpState>(
      builder: (context, powerUpState) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10.h,
            crossAxisSpacing: 10.w,
            childAspectRatio: 0.88,
            children: [
              // Gem card as the first item
              _buildGemCard(context, tr),
              // Power-up cards
              ...PowerUpItem.allPowerUps.map((item) {
                final qty = powerUpState.getQuantity(item.type);
                return _buildPowerUpCard(context, item, qty);
              }),
            ],
          ),
        );
      },
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  GEM CARD (same style as power-up cards)
  // ══════════════════════════════════════════════════════════════
  Widget _buildGemCard(BuildContext context, dynamic tr) {
    const accentColor = Color(0xFFB388FF);

    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        final coinBalance =
            context.read<AuthenticationBloc>().state.user.coinWalletBalance;
        final gemPrice = context
            .read<SettingsBloc>()
            .state
            .gamePlaySettings['gem_price'];
        final isOnline = context.read<ConnectivityBloc>().state.isOnline;
        final gems = context.read<AuthenticationBloc>().state.user.gems;

        return Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A3A6B), Color(0xFF0D2550)],
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: accentColor.withOpacity(0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon + quantity
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          accentColor.withOpacity(0.25),
                          accentColor.withOpacity(0.08),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: accentColor.withOpacity(0.2),
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        IconImageRoutes.bigGemIcon,
                        width: 22.w,
                        height: 22.w,
                      ),
                    ),
                  ),
                  if (gems > 0)
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        'x$gems',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8.h),

              // Name
              Text(
                'Buy Gem',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 2.h),

              // Description
              Text(
                'Unlock premium items',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 10.sp,
                ),
              ),
              const Spacer(),

              // Buy button
              GestureDetector(
                onTap: () {
                  if (!isOnline) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(tr.t('store_requires_internet')),
                        backgroundColor: Colors.orange.shade800,
                        duration: const Duration(seconds: 2),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  if (coinBalance >= int.parse(gemPrice)) {
                    context.read<UserBloc>().add(PurchaseGem());
                    Future.delayed(const Duration(seconds: 2), () {
                      context
                          .read<AuthenticationBloc>()
                          .add(FetchUserDataRequested());
                    });
                    Future.delayed(const Duration(seconds: 1), () {
                      showSuccessfullyBoughtGemModal(context);
                    });
                    Future.delayed(const Duration(seconds: 3), () {
                      Navigator.pop(context);
                    });
                  } else {
                    _showToast(context, tr.t('store_not_enough_coins'));
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withOpacity(0.8),
                        accentColor.withOpacity(0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: accentColor.withOpacity(0.4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.2),
                        offset: const Offset(0, 3),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: userState.isPurchasingGem
                      ? Center(
                          child: SizedBox(
                            height: 14.w,
                            width: 14.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              IconImageRoutes.coinIcon,
                              width: 16.w,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              NumberFormat('#,###,###').format(int.tryParse(gemPrice ?? '2500') ?? 2500),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPowerUpCard(BuildContext context, PowerUpItem item, int quantity) {
    // Unique accent color per power-up type
    final Color accentColor;
    switch (item.type) {
      case PowerUpType.fiftyFifty:
        accentColor = const Color(0xFFFF6B6B);
        break;
      case PowerUpType.timeFreeze:
        accentColor = const Color(0xFF54D6FF);
        break;
      case PowerUpType.doubleCoins:
        accentColor = const Color(0xFFFFD400);
        break;
      case PowerUpType.secondChance:
        accentColor = const Color(0xFF7BED9F);
        break;
    }

    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A3A6B),
            const Color(0xFF0D2550),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: accentColor.withOpacity(0.25),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + quantity
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 38.w,
                height: 38.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      accentColor.withOpacity(0.25),
                      accentColor.withOpacity(0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: accentColor.withOpacity(0.2),
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    item.iconPath,
                    width: 22.w,
                    height: 22.w,
                  ),
                ),
              ),
              if (quantity > 0)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7FB800),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'x$quantity',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),

          // Name
          Text(
            item.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 2.h),

          // Description
          Text(
            item.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 10.sp,
            ),
          ),
          const Spacer(),

          // Buy button
          GestureDetector(
            onTap: () => _handlePowerUpPurchase(context, item),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accentColor.withOpacity(0.8),
                    accentColor.withOpacity(0.6),
                  ],
                ),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: accentColor.withOpacity(0.4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.2),
                    offset: const Offset(0, 3),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    item.usesGems
                        ? IconImageRoutes.gemIcon
                        : IconImageRoutes.coinIcon,
                    width: 16.w,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    NumberFormat('#,###,###').format(item.price),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
