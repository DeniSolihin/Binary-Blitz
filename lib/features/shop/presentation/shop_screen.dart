import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/constants/app_colors.dart';
import '../../gameplay/providers/game_provider.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final gameNotifier = ref.read(gameProvider.notifier);

    final themes = [
      {
        'id': 'default',
        'name': 'Neon Matrix',
        'price': 0,
        'color': AppColors.primaryNeon,
        'desc': 'Tema standar dengan nuansa hijau neon cybernetic.',
      },
      {
        'id': 'cyberpunk',
        'name': 'Cyberpunk Pink',
        'price': 100,
        'color': Colors.pinkAccent,
        'desc': 'Tampilan futuristik dengan sentuhan pink neon energik.',
      },
      {
        'id': 'retro_gold',
        'name': 'Gold Arcade',
        'price': 250,
        'color': AppColors.accentYellow,
        'desc': 'Tema klasik ala mesin arcade retro berwarna emas.',
      },
      {
        'id': 'ice_frost',
        'name': 'Ice Frost',
        'price': 500,
        'color': Colors.cyanAccent,
        'desc': 'Efek visual dingin kebiruan yang tenang dan tajam.',
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text(
          'THEME SHOP',
          style: TextStyle(
            color: AppColors.accentYellow,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                const Icon(Icons.monetization_on, color: AppColors.accentYellow, size: 20),
                const SizedBox(width: 4),
                Text(
                  '${gameState.coins}',
                  style: const TextStyle(
                    color: AppColors.accentYellow,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: themes.length,
        itemBuilder: (context, index) {
          final theme = themes[index];
          final String id = theme['id'] as String;
          final String name = theme['name'] as String;
          final int price = theme['price'] as int;
          final Color color = theme['color'] as Color;
          final String desc = theme['desc'] as String;

          final isUnlocked = gameState.unlockedThemes.contains(id);
          final isSelected = gameState.activeTheme == id;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? color : Colors.white12,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: color),
                  ),
                  child: Icon(Icons.palette, color: color),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        desc,
                        style: const TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                if (isSelected)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: null,
                    child: const Text('PAKAI', style: TextStyle(fontWeight: FontWeight.bold)),
                  )
                else if (isUnlocked)
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: color,
                      side: BorderSide(color: color),
                    ),
                    onPressed: () => gameNotifier.selectTheme(id),
                    child: const Text('PILIH'),
                  )
                else
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentYellow,
                      foregroundColor: Colors.black,
                    ),
                    icon: const Icon(Icons.monetization_on, size: 16),
                    label: Text('$price'),
                    onPressed: gameState.coins >= price
                        ? () => gameNotifier.buyTheme(id, price)
                        : null,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}