import 'package:intl/intl.dart';

class HistoryRecord {
  final DateTime data_tm;
  final String data_value;

  const HistoryRecord({
    required this.data_tm,
    required this.data_value,
  });

  factory HistoryRecord.fromJson(Map<String, dynamic> json) {
    return HistoryRecord(
      data_tm: DateFormat("y-M-d H:m:s").parse(json['ADDED']),
      data_value: json['VALUE'] as String,
    );
  }

}
