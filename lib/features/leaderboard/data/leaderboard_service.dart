import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Simpan / Update Skor Pemain ke Firebase
  Future<void> submitScore({
    required String userId,
    required String username,
    required int score,
  }) async {
    try {
      final userDoc = _firestore.collection('leaderboard').doc(userId);
      final snapshot = await userDoc.get();

      if (snapshot.exists) {
        final currentHighScore = snapshot.data()?['score'] ?? 0;
        if (score > currentHighScore) {
          await userDoc.update({
            'score': score,
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }
      } else {
        await userDoc.set({
          'userId': userId,
          'username': username,
          'score': score,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (_) {}
  }

  // Dipanggil oleh leaderboard_screen.dart
  Future<List<Map<String, dynamic>>> getTopScores() async {
    try {
      final snapshot = await _firestore
          .collection('leaderboard')
          .orderBy('score', descending: true)
          .limit(10)
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (_) {
      return [];
    }
  }

  // Stream Realtime untuk Leaderboard
  Stream<List<Map<String, dynamic>>> getTopPlayersStream() {
    return _firestore
        .collection('leaderboard')
        .orderBy('score', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }
}