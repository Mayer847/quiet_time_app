import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'src/theme/theme_provider.dart';
import 'src/screens/daily_readings_screen.dart';

void main() async {
  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      theme: themeProvider.isNightMode ? ThemeData.dark() : ThemeData.light(),
      home: const DailyReadingsScreen(),
    );
  }
}
