import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:logger/logger.dart';

class StorageService {
  final SharedPreferences _prefs;
  final Logger _logger = Logger();
  
  StorageService(this._prefs);

  // Konstanta untuk key penyimpanan
  static const String notificationKey = 'prayer_notifications';
  static const String adhanSoundKey = 'adhan_sound';
  static const String prayerTimesKey = 'prayer_times';

  // Menyimpan pengaturan notifikasi
  Future<bool> saveNotificationSettings(Map<String, bool> settings) async {
    try {
      final String jsonString = json.encode(settings);
      return await _prefs.setString(notificationKey, jsonString);
    } catch (e) {
      _logger.e('Error saving notification settings: $e');
      return false;
    }
  }

  // Mengambil pengaturan notifikasi
  Map<String, bool> getNotificationSettings() {
    try {
      final String? jsonString = _prefs.getString(notificationKey);
      if (jsonString != null) {
        return Map<String, bool>.from(json.decode(jsonString));
      }
      return {};
    } catch (e) {
      _logger.e('Error getting notification settings: $e');
      return {};
    }
  }

  // Menyimpan pengaturan suara adzan
  Future<bool> saveAdhanSound(String soundPath) async {
    try {
      return await _prefs.setString(adhanSoundKey, soundPath);
    } catch (e) {
      _logger.e('Error saving adhan sound: $e');
      return false;
    }
  }

  // Mengambil pengaturan suara adzan
  String? getAdhanSound() {
    try {
      return _prefs.getString(adhanSoundKey);
    } catch (e) {
      _logger.e('Error getting adzan sound: $e');
      return null;
    }
  }

  // Menyimpan waktu sholat
  Future<bool> savePrayerTimes(Map<String, String> prayerTimes) async {
    try {
      final String jsonString = json.encode(prayerTimes);
      return await _prefs.setString(prayerTimesKey, jsonString);
    } catch (e) {
      _logger.e('Error saving prayer times: $e');
      return false;
    }
  }

  // Mengambil waktu sholat
  Map<String, String> getPrayerTimes() {
    try {
      final String? jsonString = _prefs.getString(prayerTimesKey);
      if (jsonString != null) {
        return Map<String, String>.from(json.decode(jsonString));
      }
      return {};
    } catch (e) {
      _logger.e('Error getting prayer times: $e');
      return {};
    }
  }

  // Method untuk menghapus semua data
  Future<bool> clearAll() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      _logger.e('Error clearing storage: $e');
      return false;
    }
  }
}
