//readings.dart
import 'package:flutter/services.dart';
import 'package:daily_qt_hl/constants.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

Future<Map<String, String>> getReadings(DateTime date) async {
  // Load the Excel file from the assets
  ByteData data = await rootBundle.load(excelFilePath);
  var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  var decoder = SpreadsheetDecoder.decodeBytes(bytes, verify: true);

  var table = decoder.tables['Sheet1'];
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

  var row = table?.rows.skip(1).firstWhere(
    (row) {
      // Convert the numerical month to its corresponding name
      final excelMonth = row[0]; // Assuming first column is Month as a word
      final excelDay = row[1]; // Assuming second column is Day as a number
      return excelMonth == monthNames[date.month - 1] && excelDay == date.day;
    },
    orElse: () => [], // Return an empty list if no match is found
  );

  if (row!.isNotEmpty) {
    final morningBook = row[2]; // Assuming third column is Morning (Book)
    final morningChapter =
        row[3]; // Assuming fourth column is Morning (Chapter)
    final eveningBook = row[4]; // Assuming fifth column is Evening (Book)
    final eveningChapter = row[5]; // Assuming sixth column is Evening (Chapter)
    return {
      'date': _formatDate(
          date), // Use _formatDate to format the date as "Month dd, yyyy"
      'morningBook': morningBook.toString(),
      'morningChapter': morningChapter.toString(),
      'eveningBook': eveningBook.toString(),
      'eveningChapter': eveningChapter.toString(),
    };
  } else {
    throw Exception('No readings found for ${_formatDate(date)}.');
  }
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
