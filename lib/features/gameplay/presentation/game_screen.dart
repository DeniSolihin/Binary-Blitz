import '../../pvp_battle/presentation/pvp_screen.dart';
import '../../leaderboard/presentation/leaderboard_screen.dart';
import '../../shop/presentation/achievements_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/constants/app_colors.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/services/haptic_service.dart';
import '../../daily_blitz/presentation/daily_blitz_dialog.dart';
import '../../diagnostic/presentation/post_match_dialog.dart';
import '../../diagnostic/presentation/quick_reference_sheet.dart';
import '../../shop/presentation/shop_screen.dart';
import '../domain/game_state.dart';
import '../providers/game_provider.dart';
import 'widgets/tutorial_dialog.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  bool _isFlashing = false;
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    AudioService.playBGM();
  }

  void _triggerFlash() {
    setState(() => _isFlashing = true);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _isFlashing = false);
      }
    });
  }

  String _getFormattedTarget(GameState state) {
    if (state.gameMode == GameMode.hex) {
      return '0x${state.targetValue.toRadixString(16).toUpperCase().padLeft(2, '0')}';
    }
    return '${state.targetValue}';
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final gameNotifier = ref.read(gameProvider.notifier);

    ref.listen(gameProvider, (previous, next) {
      if (previous != null && next.score > previous.score) {
        _triggerFlash();
      }

      if (next.isGameOver && !(previous?.isGameOver ?? false)) {
        HapticService.heavyBoom();
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => PostMatchDialog(
            finalScore: next.score,
            targetValue: next.targetValue,
            onRestart: () => gameNotifier.startNewGame(),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text(
          'BINARY BLITZ',
          style: TextStyle(
            color: AppColors.primaryNeon,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _isMuted ? Icons.volume_off : Icons.volume_up,
              color: AppColors.primaryNeon,
            ),
            tooltip: 'Mute/Unmute',
            onPressed: () {
              AudioService.toggleMute();
              setState(() => _isMuted = AudioService.isMuted);
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline, color: AppColors.primaryNeon),
            tooltip: 'Tutorial',
            onPressed: () => TutorialDialog.show(context),
          ),
          IconButton(
            icon: const Icon(Icons.menu_book_outlined, color: AppColors.secondaryNeon),
            tooltip: 'Quick Reference',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const QuickReferenceSheet(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.accentYellow),
            tooltip: 'Shop',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShopScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          color: _isFlashing
              ? AppColors.primaryNeon.withValues(alpha: 0.2)
              : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ModeChip(
                      label: '5-BIT',
                      isSelected: gameState.gameMode == GameMode.bit5,
                      onTap: () => gameNotifier.switchMode(GameMode.bit5),
                    ),
                    const SizedBox(width: 8),
                    _ModeChip(
                      label: '8-BIT',
                      isSelected: gameState.gameMode == GameMode.bit8,
                      onTap: () => gameNotifier.switchMode(GameMode.bit8),
                    ),
                    const SizedBox(width: 8),
                    _ModeChip(
                      label: 'HEX HARD',
                      isSelected: gameState.gameMode == GameMode.hex,
                      onTap: () => gameNotifier.switchMode(GameMode.hex),
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _NavButton(
                      icon: Icons.calendar_today,
                      label: 'Daily',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => DailyBlitzDialog(
                            streakDays: gameState.streakDays,
                          ),
                        );
                      },
                    ),
                    _NavButton(
                      icon: Icons.leaderboard,
                      label: 'Rank',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LeaderboardScreen(),
                          ),
                        );
                      },
                    ),
                    _NavButton(
                      icon: Icons.sports_esports,
                      label: 'PvP',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PvpScreen(),
                          ),
                        );
                      },
                    ),
                    _NavButton(
                      icon: Icons.emoji_events,
                      label: 'Badges',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AchievementsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                Column(
                  children: [
                    if (gameState.activePowerMessage != null)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryNeon.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.primaryNeon),
                        ),
                        child: Text(
                          gameState.activePowerMessage!,
                          style: const TextStyle(
                            color: AppColors.primaryNeon,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (gameState.shieldCount > 0)
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.blueAccent),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.shield, color: Colors.blueAccent, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  'SHIELD: ${gameState.shieldCount}/3',
                                  style: const TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (gameState.isFrozen)
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.cyanAccent.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.cyanAccent),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.ac_unit, color: Colors.cyanAccent, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  'TIME FROZEN',
                                  style: TextStyle(
                                    color: Colors.cyanAccent,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _InfoCard(
                      label: 'SKOR',
                      value: '${gameState.score}',
                      color: AppColors.primaryNeon,
                    ),
                    _InfoCard(
                      label: 'KOIN',
                      value: '+${gameState.coins}',
                      color: AppColors.accentYellow,
                    ),
                    _InfoCard(
                      label: 'WAKTU',
                      value: gameState.isFrozen ? 'FROZEN' : '${gameState.remainingSeconds}s',
                      color: gameState.isFrozen
                          ? Colors.cyanAccent
                          : gameState.remainingSeconds <= 10
                              ? Colors.redAccent
                              : AppColors.secondaryNeon,
                    ),
                  ],
                ),

                Column(
                  children: [
                    Text(
                      gameState.gameMode == GameMode.hex
                          ? 'KONVERSI HEX KE BINER:'
                          : 'BENTUK ANGKA INI:',
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 14,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _isFlashing
                              ? Colors.white
                              : gameState.gameMode == GameMode.hex
                                  ? AppColors.accentYellow
                                  : AppColors.primaryNeon,
                          width: _isFlashing ? 3 : 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _isFlashing
                                ? AppColors.primaryNeon
                                : (gameState.gameMode == GameMode.hex
                                        ? AppColors.accentYellow
                                        : AppColors.primaryNeon)
                                    .withValues(alpha: 0.3),
                            blurRadius: _isFlashing ? 24 : 12,
                            spreadRadius: _isFlashing ? 6 : 2,
                          ),
                        ],
                      ),
                      child: Text(
                        _getFormattedTarget(gameState),
                        style: TextStyle(
                          color: _isFlashing
                              ? AppColors.primaryNeon
                              : gameState.gameMode == GameMode.hex
                                  ? AppColors.accentYellow
                                  : Colors.white,
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      gameState.doorBits.length,
                      (index) {
                        final bitVal = gameState.doorBits[index];
                        final power = gameState.doorBits.length - 1 - index;
                        final decimalVal = 1 << power;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            children: [
                              Text(
                                '$decimalVal',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              InkWell(
                                onTap: () => gameNotifier.toggleBit(index),
                                borderRadius: BorderRadius.circular(10),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  width: gameState.doorBits.length > 5 ? 42 : 56,
                                  height: gameState.doorBits.length > 5 ? 60 : 72,
                                  decoration: BoxDecoration(
                                    color: bitVal == 1
                                        ? AppColors.primaryNeon
                                        : AppColors.surface,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: bitVal == 1
                                          ? AppColors.primaryNeon
                                          : Colors.white24,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$bitVal',
                                      style: TextStyle(
                                        color: bitVal == 1
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: gameState.doorBits.length > 5 ? 22 : 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryNeon : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryNeon : Colors.white24,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white70,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryNeon, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _InfoCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 10),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}