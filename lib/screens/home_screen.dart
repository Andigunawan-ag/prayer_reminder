import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../models/prayer_time.dart';
import '../utils/constants.dart';
import '../widgets/prayer_time_card.dart';
import '../screens/qibla_screen.dart';
import '../screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final StorageService storageService;
  final NotificationService notificationService;
  final AudioPlayer audioPlayer;

  const HomeScreen({
    super.key,
    required this.storageService,
    required this.notificationService,
    required this.audioPlayer,
  });

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  List<PrayerTime> prayerTimes = Constants.defaultPrayerTimes;
  late Timer _timer;
  String _currentTime = _formatTime(DateTime.now());

  // Format waktu jam:menit:detik
  static String _formatTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
  }

  // Fungsi untuk memperbarui waktu setiap detik
  void _startClock() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentTime = _formatTime(DateTime.now());
      });
    });
  }

  // Fungsi untuk memutar adzan
  void _playAdhan(String audioPath) async {
    try {
      await widget.audioPlayer.stop();
      await widget.audioPlayer.play(AssetSource('assets/audio/$audioPath.mp3'));
    } catch (e) {
      print('Gagal memutar audio: $e');
    }
  }

  // Fungsi untuk mengatur pengingat adzan
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
      scheduleTime.add(const Duration(days: 1));
    }

    print('Pengingat adzan akan berbunyi pada: $scheduleTime');

    widget.notificationService.scheduleNotification(
      id: prayerTimes.indexOf(prayerTime),
      title: 'Waktu Sholat ${prayerTime.name}',
      body: 'Sudah memasuki waktu sholat ${prayerTime.name}',
      scheduledTime: scheduleTime,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pengingat untuk sholat ${prayerTime.name} telah diatur'),
      ),
    );

    String audioPath = 'adzan_makkah'; // Adjust to your audio path
    _playAdhan(audioPath);
  }

  // Fungsi untuk mengubah status notifikasi
  void _toggleNotification(int index, bool value) {
    setState(() {
      prayerTimes[index] = prayerTimes[index].copyWith(
        isNotificationEnabled: value,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _startClock(); // Mulai timer untuk memperbarui jam digital
  }

  @override
  void dispose() {
    _timer.cancel(); // Hentikan timer ketika widget dibuang
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengingat Sholat'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 38, 215, 238), // Latar belakang AppBar menjadi hitam
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
      body: Container(  // Mengubah latar belakang konten utama
        color: Color.fromARGB(255, 79, 122, 214), // Warna latar belakang konten
        child: SingleChildScrollView( 
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 223, 225, 233),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color.fromARGB(255, 94, 226, 54), width: 2),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Jam Saat Ini: $_currentTime',
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Jadwal Sholat Hari Ini',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 75, 241, 81),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.green, width: 2),
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      // List jadwal sholat
                      Column(
                        children: prayerTimes.map((prayerTime) {
                          return PrayerTimeCard(
                            prayerTime: prayerTime,
                            onTap: () => _setPrayerReminder(prayerTime),
                            onNotificationChanged: (value) => _toggleNotification(prayerTimes.indexOf(prayerTime), value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
