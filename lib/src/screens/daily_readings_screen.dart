import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/theme_provider.dart';
import '../utils/date_utils.dart';
import '../services/readings_service.dart';

class DailyReadingsScreen extends StatefulWidget {
  const DailyReadingsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DailyReadingsScreenState createState() => _DailyReadingsScreenState();
}

class _DailyReadingsScreenState extends State<DailyReadingsScreen> {
  DateTime _date = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      themeProvider.setInitialTheme(_date);
    });
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
    return "Readings for ${formatDate(date)}";
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(_date)),
        actions: [
          IconButton(
            icon: Icon(
                themeProvider.isNightMode ? Icons.wb_sunny : Icons.nights_stay),
            onPressed: () {
              themeProvider.toggleTheme();
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
          color: themeProvider.isNightMode ? Colors.black : Colors.grey[200],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Date: ${formatDate(_date)}',
                  style: TextStyle(
                    fontSize: 20,
                    color:
                        themeProvider.isNightMode ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Day: ${formatDay(_date)}',
                  style: TextStyle(
                    fontSize: 20,
                    color:
                        themeProvider.isNightMode ? Colors.white : Colors.black,
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
                              color: themeProvider.isNightMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Evening: ${readings['eveningBook']} ${readings['eveningChapter']}',
                            style: TextStyle(
                              fontSize: 18,
                              color: themeProvider.isNightMode
                                  ? Colors.white
                                  : Colors.black,
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
    );
  }
}
