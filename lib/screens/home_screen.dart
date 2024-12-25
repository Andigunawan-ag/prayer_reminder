import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../models/prayer_time.dart';
import '../utils/constants.dart';
import '../widgets/prayer_time_card.dart';
import '../screens/qibla_screen.dart';
import '../screens/settings_screen.dart';
import '../services/audio_service.dart'; // Pastikan AudioService diimpor

class HomeScreen extends StatefulWidget {
  final StorageService storageService;
  final NotificationService notificationService;

  const HomeScreen({
    super.key,
    required this.storageService,
    required this.notificationService, required AudioPlayer audioPlayer,
  });

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  List<PrayerTime> prayerTimes = Constants.defaultPrayerTimes;

  // Fungsi untuk mengatur pengingat dan memutar audio berdasarkan waktu sholat
  void _setPrayerReminder(PrayerTime prayerTime) {
    if (!prayerTime.isNotificationEnabled) return;

    final now = DateTime.now();
    final timeParts = prayerTime.time.split(':');
    final scheduleTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );

    if (scheduleTime.isBefore(now)) {
      scheduleTime.add(const Duration(days: 1)); // Jika waktu sholat sudah lewat, set besok
    }

    // Mengatur notifikasi pengingat sholat
    widget.notificationService.scheduleNotification(
      id: prayerTimes.indexOf(prayerTime),
      title: 'Waktu Sholat ${prayerTime.name}',
      body: 'Sudah memasuki waktu sholat ${prayerTime.name}',
      scheduledTime: scheduleTime,
    );

    // Menampilkan snack bar bahwa pengingat telah diset
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pengingat untuk sholat ${prayerTime.name} telah diatur'),
      ),
    );

    // Memilih audio yang akan diputar berdasarkan waktu sholat
    String audioPath = _getAdzanAudioForPrayer(prayerTime.name);

    // Menggunakan AudioService untuk memutar audio
    AudioService().playAdhan(audioPath).then((_) {
      print('Audio berhasil diputar');
    }).catchError((error) {
      print('Gagal memutar audio: $error');
    });
  }

  // Fungsi untuk menentukan file audio berdasarkan nama waktu sholat
  String _getAdzanAudioForPrayer(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'subuh':
        return 'adzan_makkah'; // Adzan Makkah untuk Subuh
      case 'dzuhur':
        return 'adzan_madinah'; // Adzan Madinah untuk Dzuhur
      case 'asar':
        return 'adzan_alaqsa'; // Adzan Al-Aqsa untuk Asar
      case 'maghrib':
        return 'adzan_makkah'; // Adzan Makkah untuk Maghrib
      case 'isya':
        return 'adzan_madinah'; // Adzan Madinah untuk Isya
      default:
        return 'adzan_makkah'; // Default ke Adzan Makkah
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengingat Sholat'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.explore),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QiblaScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    storageService: widget.storageService,
                    notificationService: widget.notificationService,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Jadwal Sholat Hari Ini',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: prayerTimes.length,
              itemBuilder: (context, index) {
                return PrayerTimeCard(
                  prayerTime: prayerTimes[index],
                  onTap: () => _setPrayerReminder(prayerTimes[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
