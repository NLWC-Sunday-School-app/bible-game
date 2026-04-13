import '../../../shared/constants/image_routes.dart';

enum PowerUpType { fiftyFifty, timeFreeze, doubleCoins, secondChance }

class PowerUpItem {
  final PowerUpType type;
  final String name;
  final String nameKey;
  final String description;
  final String descriptionKey;
  final int defaultPrice;
  final String settingsKey;
  final bool usesGems;
  final String storageKey;
  final String iconPath;

  const PowerUpItem({
    required this.type,
    required this.name,
    required this.nameKey,
    required this.description,
    required this.descriptionKey,
    required this.defaultPrice,
    required this.settingsKey,
    required this.usesGems,
    required this.storageKey,
    required this.iconPath,
  });

  /// Returns the backend-configured price if available, otherwise the default.
  int getPrice(dynamic gamePlaySettings) {
    if (gamePlaySettings is Map && gamePlaySettings.containsKey(settingsKey)) {
      final val = gamePlaySettings[settingsKey];
      if (val is int) return val;
      if (val is num) return val.toInt();
      if (val is String) return int.tryParse(val) ?? defaultPrice;
    }
    return defaultPrice;
  }

  static const List<PowerUpItem> allPowerUps = [
    PowerUpItem(
      type: PowerUpType.fiftyFifty,
      name: '50/50 Lifeline',
      nameKey: 'store_fifty_fifty',
      description: 'Remove 2 wrong answers',
      descriptionKey: 'store_fifty_fifty_desc',
      defaultPrice: 15000,
      settingsKey: 'fifty_fifty_price',
      usesGems: false,
      storageKey: 'powerup_fifty_fifty',
      iconPath: IconImageRoutes.star,
    ),
    PowerUpItem(
      type: PowerUpType.timeFreeze,
      name: 'Time Freeze',
      nameKey: 'store_time_freeze',
      description: 'Extra 30 seconds',
      descriptionKey: 'store_time_freeze_desc',
      defaultPrice: 20000,
      settingsKey: 'time_freeze_price',
      usesGems: false,
      storageKey: 'powerup_time_freeze',
      iconPath: IconImageRoutes.greenTimer,
    ),
    PowerUpItem(
      type: PowerUpType.doubleCoins,
      name: 'Double Coins',
      nameKey: 'store_double_coins',
      description: '2x coins next game',
      descriptionKey: 'store_double_coins_desc',
      defaultPrice: 10,
      settingsKey: 'double_coins_price',
      usesGems: true,
      storageKey: 'powerup_double_coins',
      iconPath: IconImageRoutes.coinIcon,
    ),
    PowerUpItem(
      type: PowerUpType.secondChance,
      name: 'Second Chance',
      nameKey: 'store_second_chance',
      description: 'Retry 1 wrong answer',
      descriptionKey: 'store_second_chance_desc',
      defaultPrice: 10000,
      settingsKey: 'second_chance_price',
      usesGems: false,
      storageKey: 'powerup_second_chance',
      iconPath: IconImageRoutes.arrowCircleBack,
    ),
  ];
}
