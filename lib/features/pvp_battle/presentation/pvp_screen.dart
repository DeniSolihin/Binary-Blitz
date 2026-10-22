import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';

class PvpScreen extends StatefulWidget {
  const PvpScreen({super.key});

  @override
  State<PvpScreen> createState() => _PvpScreenState();
}

class _PvpScreenState extends State<PvpScreen> {
  int p1Score = 0;
  int p2Score = 0;
  int targetValue = 0;
  List<int> p1Bits = List.filled(5, 0);
  List<int> p2Bits = List.filled(5, 0);
  int timerSeconds = 60;
  Timer? _timer;
  bool isGameOver = false;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _startNewPvPMatch();
  }

  void _startNewPvPMatch() {
    _timer?.cancel();
    setState(() {
      p1Score = 0;
      p2Score = 0;
      p1Bits = List.filled(5, 0);
      p2Bits = List.filled(5, 0);
      timerSeconds = 60;
      isGameOver = false;
      _generateNewTarget();
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerSeconds > 1) {
        setState(() => timerSeconds--);
      } else {
        _timer?.cancel();
        setState(() {
          timerSeconds = 0;
          isGameOver = true;
        });
      }
    });
  }

  void _generateNewTarget() {
    targetValue = _random.nextInt(31) + 1;
  }

  void _toggleBitP1(int index) {
    if (isGameOver) return;
    setState(() {
      p1Bits[index] = p1Bits[index] == 0 ? 1 : 0;
    });
    _checkP1();
  }

  void _toggleBitP2(int index) {
    if (isGameOver) return;
    setState(() {
      p2Bits[index] = p2Bits[index] == 0 ? 1 : 0;
    });
    _checkP2();
  }

  void _checkP1() {
    int sum = 0;
    for (int i = 0; i < 5; i++) {
      if (p1Bits[i] == 1) sum += (1 << (4 - i));
    }
    if (sum == targetValue) {
      setState(() {
        p1Score += 10;
        p1Bits = List.filled(5, 0);
        p2Bits = List.filled(5, 0);
        _generateNewTarget();
      });
    }
  }

  void _checkP2() {
    int sum = 0;
    for (int i = 0; i < 5; i++) {
      if (p2Bits[i] == 1) sum += (1 << (4 - i));
    }
    if (sum == targetValue) {
      setState(() {
        p2Score += 10;
        p1Bits = List.filled(5, 0);
        p2Bits = List.filled(5, 0);
        _generateNewTarget();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: isGameOver
            ? _buildWinnerOverlay()
            : Column(
                children: [
                  // Player 2 Area (Rotated 180 Degrees)
                  Expanded(
                    child: RotatedBox(
                      quarterTurns: 2,
                      child: _buildPlayerArea(
                        playerLabel: 'PLAYER 2',
                        score: p2Score,
                        bits: p2Bits,
                        onToggle: _toggleBitP2,
                        color: AppColors.secondaryNeon,
                      ),
                    ),
                  ),

                  // Center Bar (Status Target & Timer)
                  Container(
                    color: AppColors.surface,
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'P2: $p2Score',
                          style: const TextStyle(
                            color: AppColors.secondaryNeon,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryNeon,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'TARGET: $targetValue | ${timerSeconds}s',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          'P1: $p1Score',
                          style: const TextStyle(
                            color: AppColors.primaryNeon,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Player 1 Area
                  Expanded(
                    child: _buildPlayerArea(
                      playerLabel: 'PLAYER 1',
                      score: p1Score,
                      bits: p1Bits,
                      onToggle: _toggleBitP1,
                      color: AppColors.primaryNeon,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildPlayerArea({
    required String playerLabel,
    required int score,
    required List<int> bits,
    required Function(int) onToggle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            playerLabel,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final bitVal = bits[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: InkWell(
                  onTap: () => onToggle(index),
                  child: Container(
                    width: 50,
                    height: 65,
                    decoration: BoxDecoration(
                      color: bitVal == 1 ? color : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: bitVal == 1 ? color : Colors.white24,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$bitVal',
                        style: TextStyle(
                          color: bitVal == 1 ? Colors.black : Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildWinnerOverlay() {
    String winnerText = p1Score > p2Score
        ? 'PLAYER 1 MENANG!'
        : (p2Score > p1Score ? 'PLAYER 2 MENANG!' : 'SERI!');
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            winnerText,
            style: const TextStyle(
              color: AppColors.primaryNeon,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'P1: $p1Score PTS  vs  P2: $p2Score PTS',
            style: const TextStyle(color: Colors.white70, fontSize: 18),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryNeon,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: _startNewPvPMatch,
            child: const Text(
              'MAIN LAGI',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white38),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('KELUAR'),
          ),
        ],
      ),
    );
  }
}