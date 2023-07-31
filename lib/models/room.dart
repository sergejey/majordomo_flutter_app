class Room {
  final String id;
  final String title;
  final String object;
  final Map<String, dynamic> properties;

  const Room({
    required this.id,
    required this.title,
    required this.object,
    required this.properties,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      title: json['title'] as String,
      object: json['object'] as String,
      properties: json,
    );
  }
}