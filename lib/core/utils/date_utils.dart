import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static String dayKey(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
}
