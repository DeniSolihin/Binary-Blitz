import 'package:flutter/material.dart';
import '../../../../app/constants/app_colors.dart';

class PostMatchDialog extends StatelessWidget {
  final int finalScore;
  final int targetValue;
  final VoidCallback onRestart;

  const PostMatchDialog({
    super.key,
    required this.finalScore,
    required this.targetValue,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    final binaryStr = targetValue.toRadixString(2).padLeft(8, '0');
    final hexStr = targetValue.toRadixString(16).toUpperCase().padLeft(2, '0');

    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'EVALUASI PERMAINAN',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.wrong, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Skor Akhir: $finalScore', style: const TextStyle(color: AppColors.textWhite, fontSize: 20)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Analisis Soal Terakhir:', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
                const SizedBox(height: 6),
                Text('• Desimal: $targetValue', style: const TextStyle(color: AppColors.textWhite)),
                Text('• Biner: $binaryStr', style: const TextStyle(color: AppColors.primaryNeon)),
                Text('• Hex: 0x$hexStr', style: const TextStyle(color: AppColors.secondaryNeon)),
              ],
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNeon),
          onPressed: () {
            Navigator.pop(context);
            onRestart();
          },
          child: const Text('MAIN LAGI', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}