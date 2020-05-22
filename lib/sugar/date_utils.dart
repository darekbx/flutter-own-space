class DateUtils {

  static String formatDate(DateTime date) {
    var month = date.month.toString().padLeft(2, '0');
    var day = date.day.toString().padLeft(2, '0');
    return "${date.year}-$month-$day";
  }
}