import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class PrayerApiService {
  static const String baseUrl = 'https://api.aladhan.com/v1/timings';

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Layanan lokasi tidak aktif');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Izin lokasi ditolak');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<Map<String, dynamic>> getPrayerTimes() async {
    try {
      final position = await getCurrentLocation();
      final response = await http.get(Uri.parse(
          '$baseUrl/${DateTime.now().millisecondsSinceEpoch}?latitude=${position.latitude}&longitude=${position.longitude}&method=2'));

      if (response.statusCode == 200) {
        return json.decode(response.body)['data']['timings'];
      } else {
        throw Exception('Gagal mengambil jadwal sholat');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}