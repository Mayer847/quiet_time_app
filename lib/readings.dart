// readings.dart
import 'package:flutter/services.dart';
import 'package:daily_qt_hl/constants.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

Future<Map<String, String>> getReadings() async {
  final today = DateTime.now(); // Get today's date

  // Load the Excel file from the assets
  ByteData data = await rootBundle.load(excelFilePath);
  var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  var decoder = SpreadsheetDecoder.decodeBytes(bytes, verify: true);

  var table = decoder.tables['Sheet1']; // Assuming your sheet name is 'Sheet1'

  var row = table?.rows.firstWhere(
    (row) => row[0].toString() == today.toString().split(' ')[0],
    orElse: () => [], // Return an empty list if no match is found
  );

  if (row!.isNotEmpty) {
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
