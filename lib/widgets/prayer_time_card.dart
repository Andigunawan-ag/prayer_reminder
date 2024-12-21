import 'package:flutter/material.dart';
import '../models/prayer_time.dart';

class PrayerTimeCard extends StatelessWidget {
  final PrayerTime prayerTime;
  final VoidCallback onTap;
  final ValueChanged<bool>? onNotificationChanged;

  const PrayerTimeCard({
    Key? key,
    required this.prayerTime,
    required this.onTap,
    this.onNotificationChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(prayerTime.icon, color: prayerTime.iconColor),
        title: Text(prayerTime.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(prayerTime.time),
            const SizedBox(width: 8),
            Switch(
              value: prayerTime.isNotificationEnabled,
              onChanged: onNotificationChanged,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}