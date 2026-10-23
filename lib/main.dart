import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const BinaryBlitzApp());
}

class BinaryBlitzApp extends StatelessWidget {
  const BinaryBlitzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Binary Blitz',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF060911),
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const HomeScreen();
        }
        return const LoginScreen();
      },
    );
  }
}

/* ============================================================================
   1. LAYAR LOGIN
   ============================================================================ */
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      if (googleAuth != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
    }
  }

  Future<void> _signInGuest() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
    } catch (e) {
      debugPrint("Guest Sign-In Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: const Color(0xFF00F2FE), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00F2FE).withValues(alpha: 0.5),
                  blurRadius: 25,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'BINARY BLITZ',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: Color(0xFF00F2FE),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '⚡ EDUKASI BINER ⚡',
                  style: TextStyle(
                    color: Color(0xFF00F2FE),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 32),
                
                _buildPillButton(
                  icon: Icons.language,
                  label: 'Lanjut dengan Google',
                  onTap: _signInWithGoogle,
                ),
                const SizedBox(height: 14),

                _buildPillButton(
                  icon: Icons.person_outline,
                  label: 'Main sebagai Guest',
                  onTap: _signInGuest,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPillButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF38BDF8)),
            const SizedBox(width: 14),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ============================================================================
   2. HOME MENU (PILIH MODE & FITUR)
   ============================================================================ */
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int coins = 120;

  void _openShop() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color(0xFF0F172A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          border: Border(top: BorderSide(color: Color(0xFF00F2FE), width: 2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '🛒 TOKO SKIN & ITEM',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B)),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            const Divider(color: Color(0xFF334155)),
            ListTile(
              leading: const Icon(Icons.door_front_door, color: Color(0xFF00F2FE)),
              title: const Text('Skin Pintu Emas Neon'),
              subtitle: const Text('100 Koin'),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF59E0B)),
                onPressed: coins >= 100 ? () {} : null,
                child: const Text('BELI', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startGame(String mode, int seconds, int bitCount) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GameplayScreen(
          modeName: mode,
          initialSeconds: seconds,
          bitCount: bitCount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userName = user?.displayName ?? "GoogleUser9673";

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: const Color(0xFF00F2FE), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00F2FE).withValues(alpha: 0.5),
                    blurRadius: 20,
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.monetization_on, color: Color(0xFFF59E0B)),
                          const SizedBox(width: 6),
                          Text(
                            '$coins',
                            style: const TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.shopping_cart, color: Color(0xFFF59E0B), size: 28),
                        onPressed: _openShop,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  const Text(
                    'BINARY BLITZ',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF00F2FE),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.language, size: 16, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 6),
                      Text(
                        userName,
                        style: const TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Mode List
                  _buildMenuPill('TUTORIAL', 'BELAJAR', Icons.book, () => _startGame('Tutorial', 0, 5)),
                  const SizedBox(height: 14),
                  _buildMenuPill('NORMAL', '1 MENIT', Icons.sports_kabaddi, () => _startGame('Normal', 60, 5)),
                  const SizedBox(height: 14),
                  _buildMenuPill('HARD', '1 MENIT', Icons.local_fire_department, () => _startGame('Hard', 60, 8)),
                  const SizedBox(height: 14),
                  _buildMenuPill('LEADERBOARD', 'SKOR', Icons.emoji_events, () {}),
                  const SizedBox(height: 24),

                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFF334155)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    icon: const Icon(Icons.door_back_door, color: Color(0xFFF59E0B)),
                    label: const Text('GANTI AKUN'),
                    onPressed: () => FirebaseAuth.instance.signOut(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuPill(String title, String badgeText, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 22),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF00F2FE),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: const Color(0xFF00F2FE).withValues(alpha: 0.5), blurRadius: 8)],
              ),
              child: Text(
                badgeText,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ============================================================================
   3. LAYAR GAMEPLAY (DENGAN PINTU BINER & TIMER KALAH OTOMATIS)
   ============================================================================ */
class GameplayScreen extends StatefulWidget {
  final String modeName;
  final int initialSeconds;
  final int bitCount;

  const GameplayScreen({
    super.key,
    required this.modeName,
    required this.initialSeconds,
    required this.bitCount,
  });

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  late int secondsLeft;
  late List<int> bits;
  int targetDecimal = 28;
  int score = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    secondsLeft = widget.initialSeconds;
    bits = List.filled(widget.bitCount, 0);
    _generateNextTarget();

    if (widget.initialSeconds > 0) {
      _startTimer();
    }
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft > 1) {
        setState(() => secondsLeft--);
      } else {
        t.cancel();
        _showGameOverDialog();
      }
    });
  }

  void _generateNextTarget() {
    setState(() {
      targetDecimal = (bits.length == 5) ? (1 + (DateTime.now().millisecondsSinceEpoch % 31)) : (10 + (DateTime.now().millisecondsSinceEpoch % 200));
      bits = List.filled(widget.bitCount, 0);
    });
  }

  int get currentDecimal {
    int val = 0;
    for (int i = 0; i < bits.length; i++) {
      int power = bits.length - 1 - i;
      val += bits[i] * (1 << power);
    }
    return val;
  }

  void _checkAnswer() {
    if (currentDecimal == targetDecimal) {
      setState(() => score += 10);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🎉 BENAR! +10 Poin'), backgroundColor: Colors.green, duration: Duration(milliseconds: 800)),
      );
      _generateNextTarget();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Salah, coba lagi!'), backgroundColor: Colors.red, duration: Duration(milliseconds: 800)),
      );
    }
  }

  void _showGameOverDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Colors.redAccent, width: 2),
        ),
        title: const Text('GAME OVER!', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w900, fontSize: 24)),
        content: Text('Waktu kamu habis!\nSkor Akhir: $score', style: const TextStyle(color: Colors.white, fontSize: 16)),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00F2FE)),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                secondsLeft = widget.initialSeconds;
                score = 0;
              });
              _startTimer();
            },
            child: const Text('MAIN LAGI', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('KE MENU UTAMA', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: const Color(0xFF00F2FE), width: 2),
                boxShadow: [BoxShadow(color: const Color(0xFF00F2FE).withValues(alpha: 0.5), blurRadius: 15)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top Bar: Timer, Pause, Score
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.hourglass_top, color: Color(0xFFF59E0B), size: 18),
                            const SizedBox(width: 6),
                            Text(
                              widget.initialSeconds == 0 ? '∞' : '${secondsLeft}s',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.pause_circle_filled, color: Colors.white, size: 32),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Color(0xFFF59E0B), size: 18),
                            const SizedBox(width: 6),
                            Text('$score', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Target Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFF59E0B)),
                    ),
                    child: Column(
                      children: [
                        const Text('TARGET DESIMAL', style: TextStyle(color: Colors.white70, letterSpacing: 1.5, fontSize: 12)),
                        const SizedBox(height: 6),
                        Text(
                          '$targetDecimal',
                          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B)),
                        ),
                        Text(
                          'Input Saat Ini: $currentDecimal',
                          style: const TextStyle(color: Color(0xFF00F2FE), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Tampilan Pintu Biner (5 Pintu Ringkas)
                  const Text('PILIH PINTU BINER (0 / 1):', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(bits.length, (index) {
                      final isOpen = bits[index] == 1;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            bits[index] = bits[index] == 0 ? 1 : 0;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 52,
                          height: 70,
                          decoration: BoxDecoration(
                            color: isOpen ? const Color(0xFF00F2FE) : const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isOpen ? const Color(0xFF00F2FE) : const Color(0xFFF59E0B), width: 2),
                            boxShadow: isOpen
                                ? [BoxShadow(color: const Color(0xFF00F2FE).withValues(alpha: 0.5), blurRadius: 10)]
                                : [],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                isOpen ? Icons.door_back_door : Icons.door_front_door,
                                color: isOpen ? Colors.black : const Color(0xFFF59E0B),
                                size: 24,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${bits[index]}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isOpen ? Colors.black : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 28),

                  // Keyboard Angka 0 & 1 Ringkas + Tombol Konfirmasi
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E293B),
                            side: const BorderSide(color: Color(0xFF334155)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            setState(() => bits = List.filled(widget.bitCount, 0));
                          },
                          child: const Text('RESET', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF59E0B),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(Icons.check_circle, color: Colors.black),
                          label: const Text(
                            'KONFIRMASI',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          onPressed: _checkAnswer,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}