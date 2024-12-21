import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  Future<void> playAdhan(String soundPath) async {
    await _audioPlayer.play(AssetSource(soundPath));
  }

  Future<void> stopAdhan() async {
    await _audioPlayer.stop();
  }
}