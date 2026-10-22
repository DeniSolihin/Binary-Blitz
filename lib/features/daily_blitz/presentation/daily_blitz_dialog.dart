import 'package:flutter/material.dart';
import '../../../../app/constants/app_colors.dart';

class DailyBlitzDialog extends StatelessWidget {
  final int streakDays;

  const DailyBlitzDialog({super.key, required this.streakDays});

  static void show(BuildContext context, int streakDays) {
    showDialog(
      context: context,
      builder: (context) => DailyBlitzDialog(streakDays: streakDays),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_fire_department, color: AppColors.secondaryNeon, size: 28),
          SizedBox(width: 8),
          Text('DAILY STREAK', style: TextStyle(color: AppColors.secondaryNeon, fontWeight: FontWeight.bold)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$streakDays HARI',
            style: const TextStyle(color: AppColors.textWhite, fontSize: 40, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Konsistensi belajar kamu sangat bagus! Selesaikan 1 soal hari ini untuk mempertahankan streak dan dapatkan +50 Koin bonus.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryNeon),
          onPressed: () => Navigator.pop(context),
          child: const Text('KLAIM BONUS', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}