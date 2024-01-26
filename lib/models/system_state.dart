
class SystemState {
  final String id;
  final String object;
  final String details;
  final String color;

  const SystemState({
    required this.id,
    required this.object,
    required this.details,
    required this.color,
  });

  factory SystemState.fromJson(Map<String, dynamic> json) {
    return SystemState(
      id: json['id'] as String,
      object: json['object'] as String,
      details: json['stateDetails'] as String,
      color: json['stateColor'] as String,
    );
  }
}
