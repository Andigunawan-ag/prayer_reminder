import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Pastikan import audioplayers
import 'package:shared_preferences/shared_preferences.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final storageService = StorageService(prefs);
  final notificationService = NotificationService();
  await notificationService.initNotification();

  final audioPlayer = AudioPlayer();  // Inisialisasi AudioPlayer

  runApp(MyApp(
    storageService: storageService,
    notificationService: notificationService,
    audioPlayer: audioPlayer,  // Kirim AudioPlayer ke MyApp
  ));
}

class MyApp extends StatelessWidget {
  final StorageService storageService;
  final NotificationService notificationService;
  final AudioPlayer audioPlayer;  // Terima AudioPlayer sebagai parameter

  const MyApp({
    super.key,
    required this.storageService,
    required this.notificationService,
    required this.audioPlayer,  // Terima AudioPlayer
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pengingat Sholat',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: HomeScreen(
        storageService: storageService,
        notificationService: notificationService,
        audioPlayer: audioPlayer,  // Kirim AudioPlayer ke HomeScreen
      ),
    );
  }
}
