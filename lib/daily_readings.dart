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
          // Enable swiping anywhere on the screen
          onHorizontalDragEnd: (details) {
            final velocity = details.primaryVelocity;
            if (velocity! > 0) {
              // Swipe right (subtract one day)
              setState(() {
                _date = _date.subtract(const Duration(days: 1));
              });
            } else if (velocity < 0) {
              // Swipe left (add one day)
              setState(() {
                _date = _date.add(const Duration(days: 1));
              });
            }
          },
          child: Container(
            color: Colors.grey[200], // Set grey background color
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Date: ${_formatDate(_date)}',
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<Map<String, String>>(
                    future: getReadings(_date),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator(); // Show loading indicator while waiting for data
                      } else if (snapshot.hasError) {
                        return const Text('Error loading data');
                      } else {
                        final readings = snapshot.data!;
                        return Column(
                          children: [
                            Text(
                              'Morning: ${readings['morningBook']}, Chapter ${readings['morningChapter']}',
                              style: const TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Evening: ${readings['eveningBook']}, Chapter ${readings['eveningChapter']}',
                              style: const TextStyle(fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _padZero(int value) {
    return value.toString().padLeft(2, '0');
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${_padZero(date.month)}-${_padZero(date.day)}';
  }
}
