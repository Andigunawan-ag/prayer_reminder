import 'package:audioplayers/audioplayers.dart';

class AudioService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playAdhanFromUrl(String url) async {
    // Memainkan suara adzan dari URL
    await _audioPlayer.play(UrlSource(url));
  }

  Future<void> stopAdhan() async {
    await _audioPlayer.stop();
  }
}