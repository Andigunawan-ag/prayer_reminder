import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Fungsi untuk memutar adzan berdasarkan path
  Future<void> playAdhan(String soundPath) async {
    // Pertama, hentikan audio yang sedang diputar
    await _audioPlayer.stop();

    // Memutar audio dengan menggunakan AudioPlayer
    await _audioPlayer.play(AssetSource('audio/$soundPath.mp3')); // Pastikan file ada di assets/audio/
  }

  // Fungsi untuk menghentikan adzan
  Future<void> stopAdhan() async {
    await _audioPlayer.stop();
  }
}
