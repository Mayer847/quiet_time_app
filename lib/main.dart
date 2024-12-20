import 'package:flutter/material.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'daily_readings.dart' as daily_readings;

void main() async {
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  runApp(const MaterialApp(
    home: daily_readings.MyApp(),
  ));
}
