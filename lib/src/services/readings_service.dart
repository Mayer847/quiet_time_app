import 'package:daily_qt_hl/constants.dart';
import 'package:daily_qt_hl/src/utils/date_utils.dart';
import 'package:flutter/services.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

Future<Map<String, String>> getReadings(DateTime date) async {
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
      final excelMonth = row[0];
      final excelDay = row[1];
      return excelMonth == monthNames[date.month - 1] && excelDay == date.day;
    },
    orElse: () => [],
  );

  if (row!.isNotEmpty) {
    final morningBook = row[2];
    final morningChapter = row[3];
    final eveningBook = row[4];
    final eveningChapter = row[5];
    return {
      'date': formatDate(date),
      'morningBook': morningBook.toString(),
      'morningChapter': morningChapter.toString(),
      'eveningBook': eveningBook.toString(),
      'eveningChapter': eveningChapter.toString(),
    };
  } else {
    throw Exception('No readings found for ${formatDate(date)}.');
  }
}
