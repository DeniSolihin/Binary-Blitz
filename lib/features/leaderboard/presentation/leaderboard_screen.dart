import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';
import '../data/leaderboard_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final LeaderboardService _leaderboardService = LeaderboardService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text(
          'GLOBAL LEADERBOARD',
          style: TextStyle(
            color: AppColors.primaryNeon,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _leaderboardService.getTopPlayersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryNeon),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Gagal memuat data peringkat.',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }

          final players = snapshot.data ?? [];

          if (players.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada skor tercatat.',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: players.length,
            itemBuilder: (context, index) {
              final player = players[index];
              final username = player['username'] ?? 'Anonymous';
              final score = player['score'] ?? 0;
              final rank = index + 1;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: rank == 1
                        ? AppColors.accentYellow
                        : rank == 2
                            ? Colors.grey
                            : rank == 3
                                ? Colors.brown
                                : Colors.white12,
                    width: rank <= 3 ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Rank Badge
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: rank == 1
                            ? AppColors.accentYellow
                            : rank == 2
                                ? Colors.grey
                                : rank == 3
                                    ? Colors.brown
                                    : Colors.white10,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '#$rank',
                          style: TextStyle(
                            color: rank <= 3 ? Colors.black : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Username
                    Expanded(
                      child: Text(
                        username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    // Score
                    Text(
                      '$score PTS',
                      style: const TextStyle(
                        color: AppColors.primaryNeon,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}