import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  double? _direction; // Arah kompas
  double? _qiblaDirection; // Arah kiblat lokal
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _initCompass();
  }

  // Memeriksa izin lokasi
  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Layanan lokasi tidak aktif')),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Izin lokasi ditolak')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Izin lokasi ditolak permanen. Silakan aktifkan di pengaturan'),
        ),
      );
      return;
    }

    setState(() {
      _hasPermission = true;
    });
    _calculateQiblaDirection();
  }

  // Menghitung arah Kiblat berdasarkan lokasi pengguna secara lokal
  Future<void> _calculateQiblaDirection() async {
    try {
      Position position = await Geolocator.getCurrentPosition();

      // Koordinat Ka'bah (Mekah)
      const kaabahLat = 21.422487;
      const kaabahLng = 39.826206;

      // Menghitung arah kiblat menggunakan rumus matematika
      double deltaL = kaabahLng - position.longitude;
      double y = math.sin(deltaL);
      double x = math.cos(position.latitude) * math.tan(kaabahLat) - math.sin(position.latitude) * math.cos(deltaL);
      double qibla = math.atan2(y, x);
      qibla = qibla * (180 / math.pi); // Mengkonversi ke derajat
      qibla = (qibla + 360) % 360; // Menjaga hasil antara 0 dan 360 derajat

      print('Posisi Anda: lat=${position.latitude}, lng=${position.longitude}');
      print('Arah Kiblat: $qibla');

      if (!mounted) return;
      setState(() {
        _qiblaDirection = qibla;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Menginisialisasi kompas untuk mendapatkan arah kompas
  void _initCompass() {
    FlutterCompass.events?.listen((event) {
      setState(() {
        _direction = event.heading;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return Scaffold(
        appBar: AppBar(title: const Text('Kompas Kiblat')),
        body: const Center(
          child: Text('Membutuhkan izin lokasi'),
        ),
      );
    }

    if (_direction == null || _qiblaDirection == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Kompas Kiblat')),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    double rotation = _direction! - _qiblaDirection!;
    if (rotation < 0) {
      rotation += 360;  // Menjaga rotasi tetap dalam rentang 0-360 derajat
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kompas Kiblat'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Arah Kiblat: ${_qiblaDirection!.toStringAsFixed(1)}°',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Center(
            child: Transform.rotate(
              angle: (rotation * (math.pi / 180) * -1),
              child: Image.asset(
                'assets/images/compass.png',  // Pastikan Anda memiliki gambar kompas di folder assets/images
                width: 200,
                height: 200,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Arahkan panah ke kiblat',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
