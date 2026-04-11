import '../../../shared/constants/image_routes.dart';

enum PowerUpType { fiftyFifty, timeFreeze, doubleCoins, secondChance }

class PowerUpItem {
  final PowerUpType type;
  final String name;
  final String nameKey;
  final String description;
  final String descriptionKey;
  final int price;
  final bool usesGems;
  final String storageKey;
  final String iconPath;

  const PowerUpItem({
    required this.type,
    required this.name,
    required this.nameKey,
    required this.description,
    required this.descriptionKey,
    required this.price,
    required this.usesGems,
    required this.storageKey,
    required this.iconPath,
  });

  static const List<PowerUpItem> allPowerUps = [
    PowerUpItem(
      type: PowerUpType.fiftyFifty,
      name: '50/50 Lifeline',
      nameKey: 'store_fifty_fifty',
      description: 'Remove 2 wrong answers',
      descriptionKey: 'store_fifty_fifty_desc',
      price: 15000,
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
      price: 20000,
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
      price: 10,
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
      price: 10000,
      usesGems: false,
      storageKey: 'powerup_second_chance',
      iconPath: IconImageRoutes.arrowCircleBack,
    ),
  ];
}
