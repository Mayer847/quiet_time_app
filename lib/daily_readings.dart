import 'dart:io';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        future: getReadings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final readings = snapshot.data as Map<String, String>;
            return Scaffold(
              appBar: AppBar(title: const Text('Today\'s Readings')),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                        'Morning: ${readings['morningBook']}, Chapter ${readings['morningChapter']}'),
                    Text(
                        'Evening: ${readings['eveningBook']}, Chapter ${readings['eveningChapter']}'),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<Map<String, String>> getReadings() async {
    final today = DateTime.now(); // Get today's date
    const filePath =
        'C:Users/Mayer/android_apps/daily_qt_hl/lib/qt_schedule.xlsx'; // Replace with the actual path to your XLSX file

    final bytes = File(filePath).readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);
    final table =
        excel.tables['Sheet1']; // Assuming your sheet name is 'Sheet1'

    final row = table?.rows.firstWhere(
      (row) => row[0].toString() == today.toString().split(' ')[0],
      orElse: () => [], // Return an empty list if no match is found
    );

    if (row != null && row.isNotEmpty) {
      final morningBook = row[1];
      final morningChapter = row[2];
      final eveningBook = row[3];
      final eveningChapter = row[4];

      return {
        'morningBook': morningBook.toString(),
        'morningChapter': morningChapter.toString(),
        'eveningBook': eveningBook.toString(),
        'eveningChapter': eveningChapter.toString(),
      };
    } else {
      throw Exception('No readings found for today.');
    }
  }
}
