import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _bgmPlayer = AudioPlayer();
  static final AudioPlayer _sfxPlayer = AudioPlayer();
  static bool _isMuted = false;

  static bool get isMuted => _isMuted;

  // 1. BGM Game
  static Future<void> playBGM() async {
    if (_isMuted) return;
    await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    await _bgmPlayer.play(AssetSource('audio/bgm.mp3'));
  }

  static Future<void> pauseBGM() async {
    await _bgmPlayer.pause();
  }

  static Future<void> resumeBGM() async {
    if (!_isMuted) {
      await _bgmPlayer.resume();
    }
  }

  static Future<void> stopBGM() async {
    await _bgmPlayer.stop();
  }

  static Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    if (_isMuted) {
      await _bgmPlayer.pause();
    } else {
      await resumeBGM();
    }
  }

  // 2. SFX Jawaban & Tap
  static Future<void> playTapSFX() async {
    if (_isMuted) return;
    await _sfxPlayer.play(AssetSource('audio/tap.mp3'));
  }

  static Future<void> playCorrectSFX() async {
    if (_isMuted) return;
    await _sfxPlayer.play(AssetSource('audio/correct.mp3'));
  }

  static Future<void> playWrongSFX() async {
    if (_isMuted) return;
    await _sfxPlayer.play(AssetSource('audio/wrong.mp3'));
  }

  // 3. SFX Kondisi Khusus
  static Future<void> playGameOverSFX() async {
    if (_isMuted) return;
    await _sfxPlayer.play(AssetSource('audio/gameover.mp3'));
  }

  static Future<void> playNewRecordSFX() async {
    if (_isMuted) return;
    await _sfxPlayer.play(AssetSource('audio/record.mp3'));
  }

  static Future<void> playWarningSFX() async {
    if (_isMuted) return;
    await _sfxPlayer.play(AssetSource('audio/warning.mp3'));
  }
}