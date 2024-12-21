import 'package:flutter/material.dart';
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

  const HomeScreen({
    super.key,
    required this.storageService,
    required this.notificationService,
  });

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  List<PrayerTime> prayerTimes = Constants.defaultPrayerTimes;

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
  }

  void _toggleNotification(int index, bool value) {
    setState(() {
      prayerTimes[index] = prayerTimes[index].copyWith(
        isNotificationEnabled: value,
      );
    });
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
                  onNotificationChanged: (value) => _toggleNotification(index, value),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}