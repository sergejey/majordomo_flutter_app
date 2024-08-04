class DeviceSchedulePoint {
  final String id;
  String linkedMethod;
  String linkedMethodTitle;
  String setTime;
  String setDays;
  String value;

  DeviceSchedulePoint({
    required this.id,
    required this.linkedMethod,
    required this.linkedMethodTitle,
    required this.setTime,
    required this.setDays,
    required this.value,
  });

  factory DeviceSchedulePoint.fromJson(Map<String, dynamic> json) {
    return DeviceSchedulePoint(
      id: json['ID'] as String,
      linkedMethod: json['LINKED_METHOD'] as String,
      linkedMethodTitle: json['LINKED_METHOD'] as String,
      setTime: json['SET_TIME'] as String,
      setDays: json['SET_DAYS'] as String,
      value: json['VALUE'] as String,
    );
  }
}

class DeviceScheduleMethod {
  final String title;
  final String methodName;
  final bool valueRequired;

  const DeviceScheduleMethod({
    required this.title,
    required this.methodName,
    required this.valueRequired,
  });

  factory DeviceScheduleMethod.fromJson(Map<String, dynamic> json) {
    return DeviceScheduleMethod(
      title: json['DESCRIPTION'] as String,
      methodName: json['NAME'] as String,
      valueRequired: ((json['_CONFIG_REQ_VALUE']) ?? 0) == 1,
    );
  }
}
