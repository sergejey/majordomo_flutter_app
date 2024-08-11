import 'package:home_app/utils/logging.dart';

class DeviceLink {
  final String id;
  String device1_id;
  String device2_id;
  String device1_title;
  String device2_title;
  String link_type;
  String link_type_title;
  Map<String, dynamic> link_settings;
  String comment;
  bool active;

  DeviceLink({
    required this.id,
    required this.device1_id,
    required this.device2_id,
    required this.device1_title,
    required this.device2_title,
    required this.link_type,
    required this.link_type_title,
    required this.link_settings,
    required this.comment,
    required this.active,
  });

  factory DeviceLink.fromJson(Map<String, dynamic> json) {
    dprint(json['LINK_SETTINGS'].toString());
    return DeviceLink(
        id: json['ID'] as String,
        device1_id: json['DEVICE1_ID'] ?? '',
        device2_id: json['DEVICE2_ID'] ?? '',
        device1_title: json['DEVICE1_TITLE'] ?? '',
        device2_title: json['DEVICE2_TITLE'] ?? '',
        link_type: json['LINK_TYPE'] ?? '',
        link_type_title: '',
        comment: json['COMMENT'] ?? '',
        active: (json['IS_ACTIVE'] ?? '0') == '1',
        link_settings: (json['LINK_SETTINGS'] ?? <String, dynamic>{})
            as Map<String, dynamic>);
  }
}

class DeviceAvailableLink {
  final String name;
  final String title;
  final String description;
  final List<DeviceLinkTargetDevice> targetDevices;
  final List<DeviceLinkParam> params;

  DeviceAvailableLink({
    required this.name,
    required this.title,
    required this.description,
    required this.targetDevices,
    required this.params,
  });

  factory DeviceAvailableLink.fromJson(Map<String, dynamic> json) {
    return DeviceAvailableLink(
      name: json['LINK_NAME'] as String,
      title: json['LINK_TITLE'] as String,
      description: (json['LINK_DESCRIPTION'] ?? '') as String,
      targetDevices: (json['TARGET_DEVICES']
          .map<DeviceLinkTargetDevice>(
              (dev_json) => DeviceLinkTargetDevice.fromJson(dev_json))
          .toList()),
      params: json['PARAMS'] != null
          ? (json['PARAMS']
              .map<DeviceLinkParam>(
                  (param_json) => DeviceLinkParam.fromJson(param_json))
              .toList())
          : [],
    );
  }
}

class DeviceLinkTargetDevice {
  final String id;
  final String title;
  final String type;

  DeviceLinkTargetDevice({
    required this.id,
    required this.title,
    required this.type,
  });

  factory DeviceLinkTargetDevice.fromJson(Map<String, dynamic> json) {
    return DeviceLinkTargetDevice(
      id: json['ID'] as String,
      title: json['TITLE'] as String,
      type: json['TYPE'] as String,
    );
  }
}

class DeviceLinkParamOption {
  final String title;
  final String value;

  DeviceLinkParamOption({
    required this.title,
    required this.value,
  });

  factory DeviceLinkParamOption.fromJson(Map<String, dynamic> json) {
    return DeviceLinkParamOption(
      title: json['TITLE'] as String,
      value: json['VALUE'] as String,
    );
  }
}

class DeviceLinkParam {
  final String name;
  final String title;
  final String type;
  final List<DeviceLinkParamOption> options;
  final String visible_condition;
  final String visible_condition_parameter;
  final String visible_condition_value;

  DeviceLinkParam(
      {required this.name,
      required this.title,
      required this.type,
      required this.options,
      required this.visible_condition,
      required this.visible_condition_parameter,
      required this.visible_condition_value});

  factory DeviceLinkParam.fromJson(Map<String, dynamic> json) {
    return DeviceLinkParam(
      name: json['PARAM_NAME'] as String,
      title: json['PARAM_TITLE'] as String,
      type: json['PARAM_TYPE'] as String,
      options: json['PARAM_OPTIONS'] != null
          ? (json['PARAM_OPTIONS']
              .map<DeviceLinkParamOption>(
                  (param_json) => DeviceLinkParamOption.fromJson(param_json))
              .toList())
          : [],
      visible_condition: (json['PARAM_VISIBLE_CONDITION'] != null
          ? (json['PARAM_VISIBLE_CONDITION']['CHECK_PARAM_CONDITION'] ?? '')
          : '') as String,
      visible_condition_parameter: (json['PARAM_VISIBLE_CONDITION'] != null
          ? (json['PARAM_VISIBLE_CONDITION']['CHECK_PARAM_NAME'] ?? '')
          : '') as String,
      visible_condition_value: (json['PARAM_VISIBLE_CONDITION'] != null
          ? (json['PARAM_VISIBLE_CONDITION']['CHECK_PARAM_VALUE'] ?? '')
          : '') as String,
    );
  }
}
