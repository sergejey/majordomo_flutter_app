class OperationalMode {
  final String id;
  final String title;
  final String object;
  final bool active;
  final Map<String, dynamic> properties;

  const OperationalMode({
    required this.id,
    required this.title,
    required this.object,
    required this.active,
    required this.properties,
  });

  factory OperationalMode.fromJson(Map<String, dynamic> json) {
    return OperationalMode(
      id: json['id'] as String,
      title: json['title'] != '' ? json['title'] : json['object'] as String,
      object: json['object'] as String,
      active: (json['active'] == '1'),
      properties: json,
    );
  }
}
