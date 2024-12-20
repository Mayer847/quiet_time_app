String padZero(int value) {
  return value.toString().padLeft(2, '0');
}

String formatDate(DateTime date) {
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
  return '$monthName ${padZero(date.day)}, ${date.year}';
}

String formatDay(DateTime date) {
  const dayNames = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  return dayNames[date.weekday % 7];
}
