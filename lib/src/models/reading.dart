class ReadingPassage {
  const ReadingPassage({
    required this.book,
    required this.passage,
  });

  final String book;
  final String passage;

  factory ReadingPassage.fromJson(Map<String, dynamic> json) {
    return ReadingPassage(
      book: json['book'] as String,
      passage: json['passage'] as String,
    );
  }

  String get displayText => '$book $passage';
}

class DailyReading {
  const DailyReading({
    required this.key,
    required this.morning,
    required this.evening,
  });

  final String key;
  final ReadingPassage morning;
  final ReadingPassage evening;

  factory DailyReading.fromJson(Map<String, dynamic> json) {
    return DailyReading(
      key: json['key'] as String,
      morning: ReadingPassage.fromJson(
        json['morning'] as Map<String, dynamic>,
      ),
      evening: ReadingPassage.fromJson(
        json['evening'] as Map<String, dynamic>,
      ),
    );
  }
}
