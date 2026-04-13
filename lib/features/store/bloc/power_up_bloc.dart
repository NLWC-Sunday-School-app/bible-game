import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:bible_game_api/api/game_api.dart';
import '../model/power_up.dart';
import 'power_up_event.dart';
import 'power_up_state.dart';

class PowerUpBloc extends Bloc<PowerUpEvent, PowerUpState> {
  final GameAPI gameAPI;

  PowerUpBloc({required this.gameAPI}) : super(const PowerUpState()) {
    on<LoadPowerUps>(_onLoad);
    on<PurchasePowerUp>(_onPurchase);
    on<UsePowerUp>(_onUse);
  }

  final _storage = GetStorage();

  void _onLoad(LoadPowerUps event, Emitter<PowerUpState> emit) {
    final quantities = <PowerUpType, int>{};
    for (final item in PowerUpItem.allPowerUps) {
      quantities[item.type] = _storage.read<int>(item.storageKey) ?? 0;
    }
    emit(state.copyWith(quantities: quantities));
  }

  Future<void> _onPurchase(
      PurchasePowerUp event, Emitter<PowerUpState> emit) async {
    final item =
        PowerUpItem.allPowerUps.firstWhere((p) => p.type == event.type);
    final price = event.price;

    emit(state.copyWith(isPurchasing: true, error: null));

    try {
      if (!item.usesGems) {
        // Deduct coins via backend API
        final success = await gameAPI.buyFromStore(
          event.userId,
          price,
          description: 'Power-up: ${item.name}',
        );
        if (!success) {
          emit(state.copyWith(
            isPurchasing: false,
            error: 'Purchase failed',
          ));
          return;
        }
      }

      // Increment local quantity
      final current = state.getQuantity(event.type);
      final newQty = current + 1;
      _storage.write(item.storageKey, newQty);

      final updated = Map<PowerUpType, int>.from(state.quantities);
      updated[event.type] = newQty;

      emit(state.copyWith(
        quantities: updated,
        lastPurchased: event.type,
        isPurchasing: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isPurchasing: false,
        error: 'Purchase failed. Try again.',
      ));
    }
  }

  void _onUse(UsePowerUp event, Emitter<PowerUpState> emit) {
    final item =
        PowerUpItem.allPowerUps.firstWhere((p) => p.type == event.type);
    final current = state.getQuantity(event.type);
    if (current <= 0) return;

    final newQty = current - 1;
    _storage.write(item.storageKey, newQty);

    final updated = Map<PowerUpType, int>.from(state.quantities);
    updated[event.type] = newQty;

    emit(state.copyWith(quantities: updated));
  }
}
