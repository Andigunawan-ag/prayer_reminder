import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  final StorageService storageService;
  final NotificationService notificationService;

  const SettingsScreen({
    super.key,
    required this.storageService,
    required this.notificationService,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? selectedAdhan;
  final List<String> adhanOptions = [
    'Makkah',
    'Madinah', 
    'Al-Alaqsa',
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    selectedAdhan = widget.storageService.getAdhanSound() ?? adhanOptions[0];
    setState(() {});
  }

  void _testAdhan() async {
    final now = DateTime.now().add(const Duration(seconds: 5));
    await widget.notificationService.scheduleNotification(
      id: 999,
      title: 'Test Adzan',
      body: 'Ini adalah test suara adzan',
      scheduledTime: now,
      sound: selectedAdhan?.toLowerCase() ?? 'adhan_makkah',
    );
    
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notifikasi akan muncul dalam 5 detik')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Pilih Suara Adzan Yang Anda Ingin'),
            trailing: DropdownButton<String>(
              value: selectedAdhan,
              items: adhanOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedAdhan = newValue;
                  widget.storageService.saveAdhanSound(newValue!);
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _testAdhan,
              child: const Text('Test Suara Adzan'),
            ),
          ),
        ],
      ),
    );
  }
}