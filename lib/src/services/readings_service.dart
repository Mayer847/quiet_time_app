import 'dart:convert';

import 'package:flutter/services.dart';

import '../../constants.dart';
import '../models/reading.dart';

class ReadingsService {
  ReadingsService._();

  static final ReadingsService instance = ReadingsService._();

  Map<String, DailyReading>? _readings;

  Future<void> load() async {
    if (_readings != null) return;

    final jsonString = await rootBundle.loadString(readingsFilePath);
    final jsonList = jsonDecode(jsonString) as List<dynamic>;

    _readings = {
      for (final item in jsonList)
        (item as Map<String, dynamic>)['key'] as String:
            DailyReading.fromJson(item),
    };
  }

  DailyReading? getReading(DateTime date) {
    final readings = _readings;

    if (readings == null) {
      throw StateError('ReadingsService.load() must be called first.');
    }

    return readings[readingDateKey(date)];
  }
}

String readingDateKey(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');

  return '$month-$day';
}
