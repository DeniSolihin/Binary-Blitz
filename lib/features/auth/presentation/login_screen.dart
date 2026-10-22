import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';
import '../../../core/services/auth_service.dart';
import '../../gameplay/presentation/game_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _handleGuestLogin() async {
    setState(() => _isLoading = true);
    final user = await _authService.signInAsGuest();
    setState(() => _isLoading = false);

    if (user != null && mounted) {
      _navigateToGame();
    }
  }

  void _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    final user = await _authService.signInWithGoogle();
    setState(() => _isLoading = false);

    if (user != null && mounted) {
      _navigateToGame();
    }
  }

  void _navigateToGame() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const GameScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.memory,
                size: 80,
                color: AppColors.primaryNeon,
              ),
              const SizedBox(height: 16),
              const Text(
                'BINARY BLITZ',
                style: TextStyle(
                  color: AppColors.primaryNeon,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Kuasai Konversi Biner & Heksadesimal',
                style: TextStyle(color: Colors.white60, fontSize: 14),
              ),
              const SizedBox(height: 48),

              if (_isLoading)
                const CircularProgressIndicator(color: AppColors.primaryNeon)
              else ...[
                // Tombol Google Sign-In
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.g_mobiledata, size: 28),
                    label: const Text(
                      'MASUK DENGAN GOOGLE',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: _handleGoogleLogin,
                  ),
                ),
                const SizedBox(height: 12),

                // Tombol Guest Mode
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryNeon,
                      side: const BorderSide(color: AppColors.primaryNeon),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.person_outline),
                    label: const Text(
                      'MAIN SEBAGAI GUEST',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: _handleGuestLogin,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}