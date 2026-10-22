import 'package:flutter/services.dart';

class HapticService {
  // Method untuk audio_service
  static void lightImpact() {
    HapticFeedback.lightImpact();
  }

  static void heavyImpact() {
    HapticFeedback.heavyImpact();
  }

  static void errorFeedback() {
    HapticFeedback.vibrate();
  }

  // Alias untuk game_screen
  static void lightClick() {
    HapticFeedback.lightImpact();
  }

  static void heavyBoom() {
    HapticFeedback.heavyImpact();
  }
}