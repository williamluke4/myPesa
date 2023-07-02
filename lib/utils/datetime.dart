import 'package:intl/intl.dart';

final mmmyDateFormat = DateFormat('MMM y');
final timeFormat24 = DateFormat.Hm(); //17:08  force 24 hour time

const gsDateBase = 2209161600 / 86400;
const gsDateFactor = 86400000;

double? dateToGsheets(DateTime? dateTime, {bool localTime = true}) {
  if (dateTime == null) return null;
  final offset = dateTime.millisecondsSinceEpoch / gsDateFactor;
  final shift = localTime ? dateTime.timeZoneOffset.inHours / 24 : 0;
  return gsDateBase + offset + shift;
}

DateTime? dateFromGsheets(String? value, {bool localTime = true}) {
  final date = double.tryParse(value ?? '');
  if (date == null) return null;
  final millis = (date - gsDateBase) * gsDateFactor;
  return DateTime.fromMillisecondsSinceEpoch(millis.toInt(), isUtc: localTime);
}
