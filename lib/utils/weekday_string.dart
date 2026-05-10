class WeekdayString {
  static final List<String> _weekDays = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ];

  static String now() {
    return _weekDays[DateTime.now().weekday - 1];
  }
}