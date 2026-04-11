import '../model/power_up.dart';

abstract class PowerUpEvent {}

class LoadPowerUps extends PowerUpEvent {}

class PurchasePowerUp extends PowerUpEvent {
  final PowerUpType type;
  final int userId;
  PurchasePowerUp(this.type, {required this.userId});
}

class UsePowerUp extends PowerUpEvent {
  final PowerUpType type;
  UsePowerUp(this.type);
}
