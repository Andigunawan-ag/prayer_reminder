import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playAdhan(String soundPath) async {
    // Pastikan soundPath sesuai dengan nama file di assets/audio/
    await _audioPlayer.play(AssetSource('audio/$soundPath.mp3')); // Tambahkan 'audio/' di depan
  }

  Future<void> stopAdhan() async {
    await _audioPlayer.stop();
  }
}