import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../services/audio_service.dart'; // Pastikan AudioService diimpor

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
    'Makkah', 'Madinah', 'Al-Alaqsa', // Suara adzan yang tersedia
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Memuat suara Adzan yang dipilih dari penyimpanan
  Future<void> _loadSettings() async {
    selectedAdhan = widget.storageService.getAdhanSound() ?? adhanOptions[0];
    setState(() {});
  }

  // Fungsi untuk menyimpan suara yang dipilih
  void _saveAdhan() {
    widget.storageService.saveAdhanSound(selectedAdhan!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Suara adzan disimpan: $selectedAdhan')),
    );
  }

  // Fungsi untuk memutar suara Adzan
  void _testAdhan() {
    print("Tombol Test Suara Adzan ditekan");

    String audioPath;
    switch (selectedAdhan) {
      case 'Makkah':
        audioPath = 'adzan_makkah'; // Sesuaikan dengan nama file audio
        break;
      case 'Madinah':
        audioPath = 'adzan_madinah';
        break;
      case 'Al-Alaqsa':
        audioPath = 'adzan_alaqsa';
        break;
      default:
        audioPath = 'adzan_alaqsa';
    }

    // Pertama, hentikan audio yang sedang diputar (jika ada)
    AudioService().stopAdhan().then((_) {
      print('Audio berhasil dihentikan');
      // Memutar audio dengan menggunakan AudioService
      AudioService().playAdhan(audioPath).then((_) {
        print('Audio berhasil diputar');
      }).catchError((error) {
        print('Gagal memutar audio: $error');
      });
    }).catchError((error) {
      print('Gagal menghentikan audio: $error');
    });
  }

  // Fungsi untuk menghentikan audio adzan
  void _stopAdhan() {
    AudioService().stopAdhan().then((_) {
      print('Audio berhenti');
    }).catchError((error) {
      print('Gagal menghentikan audio: $error');
    });
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
                });
                _saveAdhan(); // Simpan suara yang dipilih
              },
            ),
          ),
          // Tombol untuk menguji suara Adzan
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _testAdhan,
              child: const Text('Test Suara Adzan'),
            ),
          ),
          // Tombol untuk menghentikan suara Adzan
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _stopAdhan,
              child: const Text('Berhenti Suara Adzan'),
            ),
          ),
        ],
      ),
    );
  }
}
