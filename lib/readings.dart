import 'package:flutter/services.dart';
import 'package:daily_qt_hl/constants.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

Future<Map<String, String>> getReadings() async {
  final today = DateTime.now(); // Get today's date

  // Format the date to match the format in the Excel sheet
  final formattedDate =
      '${today.year}-${_padZero(today.month)}-${_padZero(today.day)}';

  // Load the Excel file from the assets
  ByteData data = await rootBundle.load(excelFilePath);
  var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  var decoder = SpreadsheetDecoder.decodeBytes(bytes, verify: true);

  var table = decoder.tables['Sheet1'];

  var row = table?.rows.skip(1).firstWhere(
    (row) {
      // Convert Excel date format to Dart DateTime
      final excelDate = DateTime(1899, 12, 30)
          .add(Duration(days: int.parse(row[0].toString())));
      final formattedExcelDate =
          '${excelDate.year}-${_padZero(excelDate.month)}-${_padZero(excelDate.day)}';

      return formattedExcelDate == formattedDate;
    },
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

String _padZero(int value) {
  if (value < 10) {
    return '0$value';
  } else {
    return value.toString();
  }
}
