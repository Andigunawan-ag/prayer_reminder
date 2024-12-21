// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:prayer_reminder/main.dart';
import 'package:prayer_reminder/services/storage_service.dart';
import 'package:prayer_reminder/services/notification_service.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Setup dependencies
    final prefs = await SharedPreferences.getInstance();
    final storageService = StorageService(prefs);
    final notificationService = NotificationService();
    await notificationService.initNotification();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      storageService: storageService,
      notificationService: notificationService,
    ));

    // Perbarui test sesuai dengan fitur aplikasi yang sebenarnya
    expect(find.text('Pengingat Sholat'), findsOneWidget);
  });
}
