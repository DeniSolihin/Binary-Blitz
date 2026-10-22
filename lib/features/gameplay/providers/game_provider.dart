import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/audio_service.dart';
import '../../leaderboard/data/leaderboard_service.dart';
import '../domain/game_state.dart';

class GameNotifier extends StateNotifier<GameState> {
  Timer? _timer;
  Timer? _freezeTimer;
  final Random _random = Random();
  final LeaderboardService _leaderboardService = LeaderboardService();

  GameNotifier()
      : super(
          GameState(
            targetValue: 0,
            doorBits: const [],
            doorPowers: const [],
            bitLength: 5,
            score: 0,
            remainingSeconds: 60,
            isGameOver: false,
            gameMode: GameMode.bit5,
            coins: 0,
            streakDays: 1,
            activeTheme: 'default',
            unlockedThemes: const ['default'],
          ),
        ) {
    startNewGame();
  }

  // Memulai game baru / Reset State
  void startNewGame() {
    _timer?.cancel();
    _freezeTimer?.cancel();
    final bitLen = _getBitLength(state.gameMode);
    final initialBits = List<int>.filled(bitLen, 0);
    final powers = _generateDoorPowers(bitLen);
    final target = _generateTarget(state.gameMode, bitLen);

    state = state.copyWith(
      targetValue: target,
      doorBits: initialBits,
      doorPowers: powers,
      bitLength: bitLen,
      score: 0,
      remainingSeconds: 60,
      isGameOver: false,
      isFrozen: false,
      shieldCount: 0,
      activePowerMessage: null,
    );

    _startTimer();
  }

  // Mengacak Status Pintu (3 Zonk + 2 Power)
  List<PowerType> _generateDoorPowers(int bitLen) {
    List<PowerType> powers = List.filled(bitLen, PowerType.none);
    List<int> indices = List.generate(bitLen, (i) => i)..shuffle(_random);
    
    List<PowerType> availablePowers = [
      PowerType.superTime,
      PowerType.freezeTime,
      PowerType.doubleScore,
      PowerType.shield,
      PowerType.ultimate,
    ];

    for (int i = 0; i < min(2, bitLen); i++) {
      powers[indices[i]] = availablePowers[_random.nextInt(availablePowers.length)];
    }

    return powers;
  }

  // Mengubah bit (0 -> 1 atau 1 -> 0)
  void toggleBit(int index) {
    if (state.isGameOver) return;

    AudioService.playTapSFX();

    final newBits = List<int>.from(state.doorBits);
    newBits[index] = newBits[index] == 0 ? 1 : 0;

    state = state.copyWith(
      doorBits: newBits,
      activePowerMessage: null,
    );
    _checkAnswer();
  }

  // Validasi kalkulasi penjumlahan bit
  void _checkAnswer() {
    int currentSum = 0;
    for (int i = 0; i < state.doorBits.length; i++) {
      if (state.doorBits[i] == 1) {
        int power = state.doorBits.length - 1 - i;
        currentSum += (1 << power);
      }
    }

    if (currentSum == state.targetValue) {
      _onCorrectAnswer();
    } else if (currentSum > state.targetValue) {
      _onWrongAnswer();
    }
  }

  // Eksekusi jika Jawaban Benar
  void _onCorrectAnswer() {
    AudioService.playCorrectSFX();

    int bonusTime = 5;
    int earnedScore = 10;
    String? powerMessage;
    int currentShields = state.shieldCount;

    for (int i = 0; i < state.doorBits.length; i++) {
      if (state.doorBits[i] == 1) {
        final power = state.doorPowers[i];
        switch (power) {
          case PowerType.superTime:
            bonusTime += 10;
            powerMessage = "SUPER TIME! (+10 Detik)";
            break;
          case PowerType.freezeTime:
            _activateFreezeTime();
            powerMessage = "FREEZE TIME! (Waktu Berhenti 10 Detik)";
            break;
          case PowerType.doubleScore:
            earnedScore *= 2;
            powerMessage = "DOUBLE SCORE! (+20 Poin)";
            break;
          case PowerType.shield:
            currentShields = 3;
            powerMessage = "SHIELD ACTIVE! (Kebal 3x Kesalahan)";
            break;
          case PowerType.ultimate:
            bonusTime += 10;
            earnedScore *= 2;
            powerMessage = "ULTIMATE POWER! (+10 Detik & Double Score)";
            break;
          case PowerType.none:
            break;
        }
      }
    }

    final newScore = state.score + earnedScore;
    final newCoins = state.coins + 2;
    final bitLen = state.bitLength;
    final newTarget = _generateTarget(state.gameMode, bitLen);
    final newPowers = _generateDoorPowers(bitLen);

    state = state.copyWith(
      score: newScore,
      coins: newCoins,
      targetValue: newTarget,
      doorBits: List.filled(bitLen, 0),
      doorPowers: newPowers,
      remainingSeconds: state.remainingSeconds + bonusTime,
      shieldCount: currentShields,
      activePowerMessage: powerMessage,
    );
  }

  void _activateFreezeTime() {
    _freezeTimer?.cancel();
    state = state.copyWith(isFrozen: true);
    _freezeTimer = Timer(const Duration(seconds: 10), () {
      state = state.copyWith(isFrozen: false);
    });
  }

  // Eksekusi jika Jawaban Salah
  void _onWrongAnswer() {
    AudioService.playWrongSFX();

    if (state.shieldCount > 0) {
      final updatedShield = state.shieldCount - 1;
      state = state.copyWith(
        shieldCount: updatedShield,
        doorBits: List.filled(state.bitLength, 0),
        activePowerMessage: updatedShield > 0
            ? "SHIELD DIGUNAKAN! (Sisa $updatedShield x Lindungan)"
            : "SHIELD HABIS!",
      );
      return;
    }

    final int penaltyTime = state.gameMode == GameMode.bit5 ? 5 : 10;
    final updatedTime = max(0, state.remainingSeconds - penaltyTime);
    final bool gameOver = updatedTime <= 0;

    state = state.copyWith(
      remainingSeconds: updatedTime,
      doorBits: List.filled(state.bitLength, 0),
      isGameOver: gameOver,
    );

    if (gameOver) {
      _timer?.cancel();
      _submitScoreToFirebase();
    }
  }

  void _submitScoreToFirebase() {
    if (state.score > 0) {
      _leaderboardService.submitScore(
        userId: 'guest_user_123',
        username: 'Player 1',
        score: state.score,
      );
    }
  }

  void setGameMode(GameMode mode) {
    state = state.copyWith(gameMode: mode);
    startNewGame();
  }

  void switchMode(GameMode mode) {
    setGameMode(mode);
  }

  void buyTheme(String themeId, int price) {
    if (state.coins >= price && !state.unlockedThemes.contains(themeId)) {
      final updatedUnlocked = List<String>.from(state.unlockedThemes)..add(themeId);
      state = state.copyWith(
        coins: state.coins - price,
        unlockedThemes: updatedUnlocked,
        activeTheme: themeId,
      );
    }
  }

  void selectTheme(String themeId) {
    if (state.unlockedThemes.contains(themeId)) {
      state = state.copyWith(activeTheme: themeId);
    }
  }

  int _getBitLength(GameMode mode) {
    switch (mode) {
      case GameMode.bit5:
        return 5;
      case GameMode.bit8:
      case GameMode.hex:
        return 8;
    }
  }

  int _generateTarget(GameMode mode, int bitLen) {
    int maxVal = (1 << bitLen) - 1;
    return _random.nextInt(maxVal) + 1;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.isFrozen) return;

      if (state.remainingSeconds > 1) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        _timer?.cancel();
        state = state.copyWith(remainingSeconds: 0, isGameOver: true);
        _submitScoreToFirebase();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _freezeTimer?.cancel();
    super.dispose();
  }
}

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});