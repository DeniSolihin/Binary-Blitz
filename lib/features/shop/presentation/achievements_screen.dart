import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/constants/app_colors.dart';
import '../../gameplay/providers/game_provider.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);

    final achievements = [
      {
        'title': 'First Step',
        'desc': 'Dapatkan skor pertama kamu di Binary Blitz.',
        'icon': Icons.star_border,
        'isUnlocked': gameState.score > 0,
      },
      {
        'title': 'Binary Novice',
        'desc': 'Mencapai skor 100 poin dalam satu sesi.',
        'icon': Icons.psychology,
        'isUnlocked': gameState.score >= 100,
      },
      {
        'title': 'Coin Collector',
        'desc': 'Memiliki koin sebanyak 50 atau lebih.',
        'icon': Icons.monetization_on_outlined,
        'isUnlocked': gameState.coins >= 50,
      },
      {
        'title': 'Streak Master',
        'desc': 'Bermain harian secara beruntun (Streak 3 hari).',
        'icon': Icons.local_fire_department,
        'isUnlocked': gameState.streakDays >= 3,
      },
      {
        'title': 'Theme Collector',
        'desc': 'Membuka minimal 2 tema visual di Shop.',
        'icon': Icons.palette_outlined,
        'isUnlocked': gameState.unlockedThemes.length >= 2,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text(
          'BADGES & ACHIEVEMENTS',
          style: TextStyle(
            color: AppColors.primaryNeon,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final item = achievements[index];
          final bool isUnlocked = item['isUnlocked'] as bool;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isUnlocked ? AppColors.primaryNeon : Colors.white12,
                width: isUnlocked ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? AppColors.primaryNeon.withValues(alpha: 0.2)
                        : Colors.white10,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isUnlocked
                          ? AppColors.primaryNeon
                          : Colors.white24,
                    ),
                  ),
                  child: Icon(
                    item['icon'] as IconData,
                    color: isUnlocked ? AppColors.primaryNeon : Colors.white38,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'] as String,
                        style: TextStyle(
                          color: isUnlocked ? Colors.white : Colors.white38,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['desc'] as String,
                        style: TextStyle(
                          color: isUnlocked ? Colors.white70 : Colors.white24,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  isUnlocked ? Icons.check_circle : Icons.lock_outline,
                  color: isUnlocked ? AppColors.primaryNeon : Colors.white24,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}