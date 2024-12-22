import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'services/storage_service.dart';
import 'services/notification_service.dart';


void main() async {
  // Pastikan inisialisasi widget dan setup lainnya berjalan dengan benar
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  // Inisialisasi layanan penyimpanan dan layanan notifikasi
  final storageService = StorageService(prefs);
  final notificationService = NotificationService();
  
  // Inisialisasi notifikasi
  await notificationService.initNotification();

  // Menjalankan aplikasi
  runApp(MyApp(
    storageService: storageService,
    notificationService: notificationService,
  ));
}

class MyApp extends StatelessWidget {
  final StorageService storageService;
  final NotificationService notificationService;

  const MyApp({
    Key? key,
    required this.storageService, 
    required this.notificationService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pengingat Sholat',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: HomeScreen(
        storageService: storageService,
        notificationService: notificationService,
      ),
    );
  }
}
