//daily_readings.dart
import 'package:flutter/material.dart';
import 'readings.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime _date = DateTime.now();
  String _getTitle(DateTime date) {
    final today = DateTime.now();
    if (date.year == today.year && date.month == today.month) {
      if (date.day == today.day) {
        return "Today's Readings";
      } else if (date.day == today.day - 1) {
        return "Yesterday's Readings";
      } else if (date.day == today.day + 1) {
        return "Tomorrow's Readings";
      }
    }
    return "Readings for ${date.year}-${_padZero(date.month)}-${_padZero(date.day)}";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text(_getTitle(_date))),
        body: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! > 0) {
              setState(() {
                _date = _date.subtract(const Duration(days: 1));
              });
            } else if (details.primaryVelocity! < 0) {
              setState(() {
                _date = _date.add(const Duration(days: 1));
              });
            }
          },
          child: FutureBuilder(
            future: getReadings(_date),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final readings = snapshot.data as Map<String, String>;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text('Date: ${readings['date']}'),
                      Text(
                          'Morning: ${readings['morningBook']}, Chapter ${readings['morningChapter']}'),
                      Text(
                          'Evening: ${readings['eveningBook']}, Chapter ${readings['eveningChapter']}'),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  String _padZero(int value) {
    if (value < 10) {
      return '0$value';
    } else {
      return value.toString();
    }
  }
}
