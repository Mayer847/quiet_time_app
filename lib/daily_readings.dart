import 'package:flutter/material.dart';
import 'readings.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime _date = DateTime.now();
  bool _isNightMode = false;

  @override
  void initState() {
    super.initState();
    _isNightMode = _date.hour >= 18 || _date.hour < 6;
  }

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
    return "Readings for ${_formatDate(date)}";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isNightMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(_getTitle(_date)),
          actions: [
            IconButton(
              icon: Icon(_isNightMode ? Icons.wb_sunny : Icons.nights_stay),
              onPressed: () {
                setState(() {
                  _isNightMode = !_isNightMode;
                });
              },
            ),
          ],
        ),
        body: GestureDetector(
          onHorizontalDragEnd: (details) {
            final velocity = details.primaryVelocity;
            if (velocity! > 0) {
              setState(() {
                _date = _date.subtract(const Duration(days: 1));
              });
            } else if (velocity < 0) {
              setState(() {
                _date = _date.add(const Duration(days: 1));
              });
            }
          },
          child: Container(
            color: _isNightMode ? Colors.black : Colors.grey[200],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Date: ${_formatDate(_date)}',
                    style: TextStyle(
                      fontSize: 20,
                      color: _isNightMode ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Day: ${_formatDay(_date)}',
                    style: TextStyle(
                      fontSize: 20,
                      color: _isNightMode ? Colors.white : Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<Map<String, String>>(
                    future: getReadings(_date),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Error loading data');
                      } else {
                        final readings = snapshot.data!;
                        return Column(
                          children: [
                            Text(
                              'Morning: ${readings['morningBook']} ${readings['morningChapter']}',
                              style: TextStyle(
                                fontSize: 18,
                                color:
                                    _isNightMode ? Colors.white : Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Evening: ${readings['eveningBook']} ${readings['eveningChapter']}',
                              style: TextStyle(
                                fontSize: 18,
                                color:
                                    _isNightMode ? Colors.white : Colors.black,
                              ),
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
    const monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final monthName = monthNames[date.month - 1];
    return '$monthName ${_padZero(date.day)}, ${date.year}';
  }

  String _formatDay(DateTime date) {
    const dayNames = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];
    return dayNames[date.weekday % 7];
  }
}
