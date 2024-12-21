import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  final SharedPreferences _prefs;
  
  StorageService(this._prefs);

  // Konstanta untuk key penyimpanan
  static const String NOTIFICATION_KEY = 'prayer_notifications';
  static const String ADHAN_SOUND_KEY = 'adhan_sound';
  static const String PRAYER_TIMES_KEY = 'prayer_times';

  // Menyimpan pengaturan notifikasi
  Future<bool> saveNotificationSettings(Map<String, bool> settings) async {
    try {
      final String jsonString = json.encode(settings);
      return await _prefs.setString(NOTIFICATION_KEY, jsonString);
    } catch (e) {
      print('Error saving notification settings: $e');
      return false;
    }
  }

  // Mengambil pengaturan notifikasi
  Map<String, bool> getNotificationSettings() {
    try {
      final String? jsonString = _prefs.getString(NOTIFICATION_KEY);
      if (jsonString != null) {
        return Map<String, bool>.from(json.decode(jsonString));
      }
      return {};
    } catch (e) {
      print('Error getting notification settings: $e');
      return {};
    }
  }

  // Menyimpan pengaturan suara adzan
  Future<bool> saveAdhanSound(String soundPath) async {
    try {
      return await _prefs.setString(ADHAN_SOUND_KEY, soundPath);
    } catch (e) {
      print('Error saving adhan sound: $e');
      return false;
    }
  }

  // Mengambil pengaturan suara adzan
  String? getAdhanSound() {
    try {
      return _prefs.getString(ADHAN_SOUND_KEY);
    } catch (e) {
      print('Error getting adhan sound: $e');
      return null;
    }
  }

  // Menyimpan waktu sholat
  Future<bool> savePrayerTimes(Map<String, String> prayerTimes) async {
    try {
      final String jsonString = json.encode(prayerTimes);
      return await _prefs.setString(PRAYER_TIMES_KEY, jsonString);
    } catch (e) {
      print('Error saving prayer times: $e');
      return false;
    }
  }

  // Mengambil waktu sholat
  Map<String, String> getPrayerTimes() {
    try {
      final String? jsonString = _prefs.getString(PRAYER_TIMES_KEY);
      if (jsonString != null) {
        return Map<String, String>.from(json.decode(jsonString));
      }
      return {};
    } catch (e) {
      print('Error getting prayer times: $e');
      return {};
    }
  }

  // Method untuk menghapus semua data
  Future<bool> clearAll() async {
    try {
      return await _prefs.clear();
    } catch (e) {
      print('Error clearing storage: $e');
      return false;
    }
  }
}