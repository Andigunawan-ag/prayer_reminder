import 'package:flutter/material.dart';

class PrayerTime {
  final String name;
  final String time;
  final IconData icon;
  final Color iconColor;
  final bool isNotificationEnabled;

  PrayerTime({
    required this.name,
    required this.time,
    required this.icon,
    required this.iconColor,
    this.isNotificationEnabled = true,
  });

  PrayerTime copyWith({
    String? name,
    String? time,
    IconData? icon,
    Color? iconColor,
    bool? isNotificationEnabled,
  }) {
    return PrayerTime(
      name: name ?? this.name,
      time: time ?? this.time,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      isNotificationEnabled: isNotificationEnabled ?? this.isNotificationEnabled,
    );
  }
}