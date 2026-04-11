import 'package:equatable/equatable.dart';
import '../model/power_up.dart';

class PowerUpState extends Equatable {
  final Map<PowerUpType, int> quantities;
  final bool isPurchasing;
  final PowerUpType? lastPurchased;
  final String? error;
  // Increment counter to guarantee unique state on each use/purchase
  final int _version;

  const PowerUpState({
    this.quantities = const {},
    this.isPurchasing = false,
    this.lastPurchased,
    this.error,
    int version = 0,
  }) : _version = version;

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
      version: _version + 1,
    );
  }

  @override
  List<Object?> get props => [quantities, isPurchasing, lastPurchased, error, _version];
}
