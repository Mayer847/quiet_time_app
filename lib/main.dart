import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/screens/quiet_time_app_screen.dart';
import 'src/services/readings_service.dart';
import 'src/theme/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ReadingsService.instance.load();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const QuietTimeApp(),
    ),
  );
}

class QuietTimeApp extends StatelessWidget {
  const QuietTimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiet Time',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: themeProvider.isNightMode ? ThemeMode.dark : ThemeMode.light,
      home: const QuietTimeAppScreen(),
    );
  }
}
