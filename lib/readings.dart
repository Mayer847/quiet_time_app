// readings.dart
import 'package:flutter/services.dart';
import 'package:daily_qt_hl/constants.dart';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';

Future<Map<String, String>> getReadings() async {
  final today = DateTime.now(); // Get today's date

  // Load the Excel file from the assets
  ByteData data = await rootBundle.load(excelFilePath);
  if (data.lengthInBytes == 0) {
    throw Exception('No data found in the file');
  }
  var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  var excel = Excel.decodeBytes(bytes);

  final table = excel.tables['Sheet1']; // Assuming your sheet name is 'Sheet1'

  // Convert today's date to the format in your Excel file
  var formatter = DateFormat('M/d/yyyy');
  String formattedDate = formatter.format(today);

  final row = table?.rows.firstWhere(
    (row) => row[0].toString() == formattedDate,
    orElse: () => [], // Return an empty list if no match is found
  );

  // final row = table?.rows.firstWhere(
  //   (row) => row[0].toString() == today.toString().split(' ')[0],
  //   orElse: () => [], // Return an empty list if no match is found
  // );

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
