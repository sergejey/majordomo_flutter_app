class SimpleDevice {
  final String id;
  final String title;
  final String object;
  final String type;
  final String linkedRoom;
  final Map<String, dynamic> properties;
  String roomTitle;
  bool favorite;

  SimpleDevice({
    required this.id,
    required this.title,
    required this.object,
    required this.type,
    required this.linkedRoom,
    required this.properties,
    required this.roomTitle,
    required this.favorite,
  });

  factory SimpleDevice.fromJson(Map<String, dynamic> json) {
    return SimpleDevice(
      id: json['id'] as String,
      title: json['title']??'Unknown',
      object: json['object']??'',
      type: json['type']??'',
      linkedRoom: json['linkedRoom']??'',
      properties: json,
      roomTitle: '',
      favorite: false,
    );
  }
}