enum PowerUpType { fiftyFifty, timeFreeze, doubleCoins, skipQuestion }

class PowerUpItem {
  final PowerUpType type;
  final String name;
  final String nameKey;
  final String description;
  final String descriptionKey;
  final int price;
  final bool usesGems;
  final String storageKey;
  final String emoji;

  const PowerUpItem({
    required this.type,
    required this.name,
    required this.nameKey,
    required this.description,
    required this.descriptionKey,
    required this.price,
    required this.usesGems,
    required this.storageKey,
    required this.emoji,
  });

  static const List<PowerUpItem> allPowerUps = [
    PowerUpItem(
      type: PowerUpType.fiftyFifty,
      name: '50/50 Lifeline',
      nameKey: 'store_fifty_fifty',
      description: 'Remove 2 wrong answers',
      descriptionKey: 'store_fifty_fifty_desc',
      price: 500,
      usesGems: false,
      storageKey: 'powerup_fifty_fifty',
      emoji: '\u{1F3AF}',
    ),
    PowerUpItem(
      type: PowerUpType.timeFreeze,
      name: 'Time Freeze',
      nameKey: 'store_time_freeze',
      description: 'Extra 30 seconds',
      descriptionKey: 'store_time_freeze_desc',
      price: 300,
      usesGems: false,
      storageKey: 'powerup_time_freeze',
      emoji: '\u{23F1}',
    ),
    PowerUpItem(
      type: PowerUpType.doubleCoins,
      name: 'Double Coins',
      nameKey: 'store_double_coins',
      description: '2x coins next game',
      descriptionKey: 'store_double_coins_desc',
      price: 2,
      usesGems: true,
      storageKey: 'powerup_double_coins',
      emoji: '\u{2728}',
    ),
    PowerUpItem(
      type: PowerUpType.skipQuestion,
      name: 'Skip Question',
      nameKey: 'store_skip_question',
      description: 'Skip without penalty',
      descriptionKey: 'store_skip_question_desc',
      price: 400,
      usesGems: false,
      storageKey: 'powerup_skip_question',
      emoji: '\u{23E9}',
    ),
  ];
}
