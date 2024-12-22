import 'package:flutter/material.dart';
import 'prayer_time.dart';  // Mengimpor model PrayerTime

class PrayerTimeList extends StatelessWidget {
  final List<PrayerTime> prayerTimes = [
    PrayerTime(
      name: 'Subuh',
      time: '05:00 AM',
      icon: Icons.access_alarm,
      iconColor: Colors.blue,
    ),
    PrayerTime(
      name: 'Dzuhur',
      time: '12:00 PM',
      icon: Icons.access_alarm,
      iconColor: Colors.green,
    ),
    PrayerTime(
      name: 'Asar',
      time: '03:30 PM',
      icon: Icons.access_alarm,
      iconColor: Colors.orange,
    ),
    PrayerTime(
      name: 'Maghrib',
      time: '06:00 PM',
      icon: Icons.access_alarm,
      iconColor: Colors.red,
    ),
    PrayerTime(
      name: 'Isha',
      time: '07:30 PM',
      icon: Icons.access_alarm,
      iconColor: Colors.purple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prayer Times'),
      ),
      body: ListView.builder(
        itemCount: prayerTimes.length,
        itemBuilder: (context, index) {
          final prayer = prayerTimes[index];
          return ListTile(
            leading: Icon(prayer.icon, color: prayer.iconColor),
            title: Text(prayer.name),
            subtitle: Text(prayer.time),
            trailing: Switch(
              value: prayer.isNotificationEnabled,
              onChanged: (value) {
                // Mengubah status notifikasi saat switch diubah
                prayerTimes[index] = prayer.copyWith(isNotificationEnabled: value);
              },
            ),
          );
        },
      ),
    );
  }
}
