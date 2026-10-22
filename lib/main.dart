import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/constants/app_colors.dart';
import 'features/auth/presentation/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: BinaryBlitzApp()));
}

class BinaryBlitzApp extends StatelessWidget {
  const BinaryBlitzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Binary Blitz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.primaryNeon,
      ),
      home: const LoginScreen(),
    );
  }
}