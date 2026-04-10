import '../model/power_up.dart';

class PowerUpState {
  final Map<PowerUpType, int> quantities;
  final bool isPurchasing;
  final PowerUpType? lastPurchased;
  final String? error;

  const PowerUpState({
    this.quantities = const {},
    this.isPurchasing = false,
    this.lastPurchased,
    this.error,
  });

  int getQuantity(PowerUpType type) => quantities[type] ?? 0;

  PowerUpState copyWith({
    Map<PowerUpType, int>? quantities,
    bool? isPurchasing,
    PowerUpType? lastPurchased,
    String? error,
  }) {
    return PowerUpState(
      quantities: quantities ?? this.quantities,
      isPurchasing: isPurchasing ?? this.isPurchasing,
      lastPurchased: lastPurchased,
      error: error,
    );
  }
}
