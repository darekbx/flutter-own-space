class OwnSpaceDateUtils {

  static String formatDate(DateTime date) {
    var month = date.month.toString().padLeft(2, '0');
    var day = date.day.toString().padLeft(2, '0');
    return "${date.year}-$month-$day";
  }

  static String formatDateTime(DateTime date) {
    var month = date.month.toString().padLeft(2, '0');
    var day = date.day.toString().padLeft(2, '0');
    var hour = date.hour.toString().padLeft(2, '0');
    var minute = date.minute.toString().padLeft(2, '0');
    return "${date.year}-$month-$day $hour:$minute";
  }
}
