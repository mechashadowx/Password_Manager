class DateController {
  static String getDate() {
    DateTime dateParse = DateTime.parse(DateTime.now().toString());
    String date = '${dateParse.day}-${dateParse.month}-${dateParse.year}';
    return date;
  }
}
