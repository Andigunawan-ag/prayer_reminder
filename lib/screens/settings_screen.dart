import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  final StorageService storageService;

  const SettingsScreen({
    Key? key,
    required this.storageService,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? selectedAdhan;
  final List<String> adhanOptions = [
    'Makkah',
    'Madinah', 
    'Al-Aqsa',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Pilih Suara Adzan'),
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
        ],
      ),
    );
  }
}