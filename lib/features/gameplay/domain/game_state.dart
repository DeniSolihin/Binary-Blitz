enum GameMode { bit5, bit8, hex }

enum PowerType { none, superTime, freezeTime, doubleScore, shield, ultimate }

class GameState {
  final int targetValue;
  final List<int> doorBits;
  final List<PowerType> doorPowers;
  final int bitLength;
  final int score;
  final int remainingSeconds;
  final bool isGameOver;
  final bool isFrozen;
  final int shieldCount;
  final GameMode gameMode;
  final int coins;
  final int streakDays;
  final String activeTheme;
  final List<String> unlockedThemes;
  final String? activePowerMessage;

  GameState({
    required this.targetValue,
    required this.doorBits,
    required this.doorPowers,
    required this.bitLength,
    required this.score,
    required this.remainingSeconds,
    required this.isGameOver,
    this.isFrozen = false,
    this.shieldCount = 0,
    required this.gameMode,
    required this.coins,
    required this.streakDays,
    required this.activeTheme,
    required this.unlockedThemes,
    this.activePowerMessage,
  });

  GameState copyWith({
    int? targetValue,
    List<int>? doorBits,
    List<PowerType>? doorPowers,
    int? bitLength,
    int? score,
    int? remainingSeconds,
    bool? isGameOver,
    bool? isFrozen,
    int? shieldCount,
    GameMode? gameMode,
    int? coins,
    int? streakDays,
    String? activeTheme,
    List<String>? unlockedThemes,
    String? activePowerMessage,
  }) {
    return GameState(
      targetValue: targetValue ?? this.targetValue,
      doorBits: doorBits ?? this.doorBits,
      doorPowers: doorPowers ?? this.doorPowers,
      bitLength: bitLength ?? this.bitLength,
      score: score ?? this.score,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isGameOver: isGameOver ?? this.isGameOver,
      isFrozen: isFrozen ?? this.isFrozen,
      shieldCount: shieldCount ?? this.shieldCount,
      gameMode: gameMode ?? this.gameMode,
      coins: coins ?? this.coins,
      streakDays: streakDays ?? this.streakDays,
      activeTheme: activeTheme ?? this.activeTheme,
      unlockedThemes: unlockedThemes ?? this.unlockedThemes,
      activePowerMessage: activePowerMessage,
    );
  }
}