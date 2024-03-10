import 'dart:io';
import 'package:daily_qt_hl/constants.dart';
import 'package:excel/excel.dart';

Future<Map<String, String>> getReadings() async {
  final today = DateTime.now(); // Get today's date

  final bytes = File(excelFilePath).readAsBytesSync();
  final excel = Excel.decodeBytes(bytes);
  final table = excel.tables['Sheet1']; // Assuming your sheet name is 'Sheet1'

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
