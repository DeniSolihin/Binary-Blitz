import 'package:flutter/material.dart';
import '../../../../app/constants/app_colors.dart';

class QuickReferenceSheet extends StatelessWidget {
  const QuickReferenceSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const QuickReferenceSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'KAMUS SAKU KONVERSI',
                style: TextStyle(color: AppColors.primaryNeon, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textMuted),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: const [
                _ReferenceRow(dec: '0', bin: '0000', hex: '0x0'),
                _ReferenceRow(dec: '1', bin: '0001', hex: '0x1'),
                _ReferenceRow(dec: '2', bin: '0010', hex: '0x2'),
                _ReferenceRow(dec: '3', bin: '0011', hex: '0x3'),
                _ReferenceRow(dec: '4', bin: '0100', hex: '0x4'),
                _ReferenceRow(dec: '5', bin: '0101', hex: '0x5'),
                _ReferenceRow(dec: '10', bin: '1010', hex: '0xA'),
                _ReferenceRow(dec: '12', bin: '1100', hex: '0xC'),
                _ReferenceRow(dec: '15', bin: '1111', hex: '0xF'),
                _ReferenceRow(dec: '255', bin: '1111 1111', hex: '0xFF'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReferenceRow extends StatelessWidget {
  final String dec;
  final String bin;
  final String hex;

  const _ReferenceRow({required this.dec, required this.bin, required this.hex});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('DEC: $dec', style: const TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold)),
          Text('BIN: $bin', style: const TextStyle(color: AppColors.primaryNeon)),
          Text('HEX: $hex', style: const TextStyle(color: AppColors.secondaryNeon, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}