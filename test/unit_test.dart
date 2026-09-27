import 'package:flutter_test/flutter_test.dart';
import 'package:quiet_time_app/src/services/readings_service.dart';
import 'package:quiet_time_app/src/utils/date_utils.dart';

void main() {
  group('readingDateKey', () {
    test('formats January 1 correctly', () {
      expect(
        readingDateKey(DateTime(2026, 1, 1)),
        '01-01',
      );
    });

    test('formats February 29 correctly', () {
      expect(
        readingDateKey(DateTime(2024, 2, 29)),
        '02-29',
      );
    });

    test('formats December 31 correctly', () {
      expect(
        readingDateKey(DateTime(2026, 12, 31)),
        '12-31',
      );
    });

    test('ignores the year', () {
      expect(
        readingDateKey(DateTime(2025, 9, 27)),
        readingDateKey(DateTime(2026, 9, 27)),
      );
    });
  });

  group('date utilities', () {
    test('formats date correctly', () {
      expect(
        formatDate(DateTime(2026, 9, 27)),
        'September 27, 2026',
      );
    });

    test('formats Sunday correctly', () {
      expect(
        formatDay(DateTime(2026, 9, 27)),
        'Sunday',
      );
    });
  });
}
