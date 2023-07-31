class SimpleDevice {
  final String id;
  final String title;
  final String object;
  final String type;
  final String linkedRoom;
  final Map<String, dynamic> properties;

  const SimpleDevice({
    required this.id,
    required this.title,
    required this.object,
    required this.type,
    required this.linkedRoom,
    required this.properties,
  });

  factory SimpleDevice.fromJson(Map<String, dynamic> json) {
    return SimpleDevice(
      id: json['id'] as String,
      title: json['title'] as String,
      object: json['object'] as String,
      type: json['type'] as String,
      linkedRoom: json['linkedRoom'] as String,
      properties: json,
    );
  }
}