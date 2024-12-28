import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../services/audio_service.dart';
import '../services/adhan_service.dart';

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
  final AudioService _audioService = AudioService();
  final AdhanService _adhanService = AdhanService();

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
    try {
      final url = await _adhanService.fetchAdhanUrl();
      if (url != null) {
        await _audioService.playAdhanFromUrl(url);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
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