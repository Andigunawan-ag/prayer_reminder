import 'package:flutter/material.dart';
import '../models/prayer_time.dart';

class Constants {
  static List<PrayerTime> defaultPrayerTimes = [
    PrayerTime(
      name: 'Subuh',
      time: '04:30',
      icon: Icons.wb_twilight,
      iconColor: Colors.orange,
    ),
    PrayerTime(
      name: 'Dzuhur',
      time: '12:00',
      icon: Icons.wb_sunny,
      iconColor: Colors.yellow,
    ),
    PrayerTime(
      name: 'Ashar',
      time: '15:30',
      icon: Icons.wb_sunny_outlined,
      iconColor: Colors.orange,
    ),
    PrayerTime(
      name: 'Maghrib',
      time: '18:15',
      icon: Icons.nights_stay_outlined,
      iconColor: Colors.indigo,
    ),
    PrayerTime(
      name: 'Isya',
      time: '22:29',
      icon: Icons.nightlight_round,
      iconColor: Colors.blue,
    ),
  ];
}