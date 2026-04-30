class DateString {
  
  static String now() {
    return DateTime.now().toIso8601String().split("T")[0];
  }
}