import 'package:flutter/material.dart';
import '../../../../app/constants/app_colors.dart';

class TutorialDialog extends StatelessWidget {
  const TutorialDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const TutorialDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.primaryNeon, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Modal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.school, color: AppColors.primaryNeon),
                      SizedBox(width: 8),
                      Text(
                        'CARA BERMAIN',
                        style: TextStyle(
                          color: AppColors.primaryNeon,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(color: Colors.white24, height: 20),

              // 1. Konsep Nilai Bit
              const Text(
                '1. Pembobotan Nilai Bit',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Setiap tombol biner memiliki bobot angka kelipatan dua dari kanan ke kiri:',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 10),

              // Visual Tabel Bit (16, 8, 4, 2, 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  _BitCard(value: '16', bit: '1'),
                  _BitCard(value: '8', bit: '1'),
                  _BitCard(value: '4', bit: '0'),
                  _BitCard(value: '2', bit: '0'),
                  _BitCard(value: '1', bit: '1'),
                ],
              ),
              const SizedBox(height: 12),

              // Contoh Penjumlahan
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Contoh di atas:\n16 + 8 + 1 = 25 (Desimal)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.accentYellow,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Aturan Waktu & Penalti
              const Text(
                '2. Bonus & Penalti Waktu',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 6),
              const _RuleRow(
                icon: Icons.add_circle_outline,
                color: Colors.greenAccent,
                text: 'Jawaban Benar: +5 Detik',
              ),
              const SizedBox(height: 4),
              const _RuleRow(
                icon: Icons.remove_circle_outline,
                color: Colors.redAccent,
                text: 'Jawaban Salah (Mode Normal): -5 Detik',
              ),
              const SizedBox(height: 4),
              const _RuleRow(
                icon: Icons.warning_amber_rounded,
                color: Colors.orangeAccent,
                text: 'Jawaban Salah (Mode Hard/Hex): -10 Detik',
              ),
              const SizedBox(height: 20),

              // Tombol Paham
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryNeon,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'SAYA PAHAM!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BitCard extends StatelessWidget {
  final String value;
  final String bit;

  const _BitCard({required this.value, required this.bit});

  @override
  Widget build(BuildContext context) {
    final isActive = bit == '1';
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
        const SizedBox(height: 4),
        Container(
          width: 38,
          height: 48,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryNeon : AppColors.background,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? AppColors.primaryNeon : Colors.white24,
            ),
          ),
          child: Center(
            child: Text(
              bit,
              style: TextStyle(
                color: isActive ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RuleRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _RuleRow({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ),
      ],
    );
  }
}