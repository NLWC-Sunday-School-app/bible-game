import '../model/power_up.dart';

abstract class PowerUpEvent {}

class LoadPowerUps extends PowerUpEvent {}

class PurchasePowerUp extends PowerUpEvent {
  final PowerUpType type;
  final int userId;
  final int price;
  PurchasePowerUp(this.type, {required this.userId, required this.price});
}

class UsePowerUp extends PowerUpEvent {
  final PowerUpType type;
  UsePowerUp(this.type);
}
