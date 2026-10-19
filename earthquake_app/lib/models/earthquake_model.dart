
class Earthquake {
  final String id;
  final String place;
  final double magnitude;
  final DateTime time;
  final double latitude;
  final double longitude;
  final double depth;
  final String? url;

  const Earthquake({
    required this.id,
    required this.place,
    required this.magnitude,
    required this.time,
    required this.latitude,
    required this.longitude,
    required this.depth,
    this.url,
  });

  factory Earthquake.fromJson(Map<String, dynamic> json) {
    final properties =
        json['properties'] as Map<String, dynamic>? ?? {};
    final geometry =
        json['geometry'] as Map<String, dynamic>? ?? {};
    final coordinates =
        geometry['coordinates'] as List<dynamic>? ?? [];

    final timestamp = properties['time'] as num?;

    return Earthquake(
      id: json['id']?.toString() ?? '',
      place: properties['place']?.toString() ?? 'Neznáme miesto',
      magnitude: (properties['mag'] as num?)?.toDouble() ?? 0.0,
      time: DateTime.fromMillisecondsSinceEpoch(
        timestamp?.toInt() ?? 0,
        isUtc: true,
      ),
      longitude: coordinates.isNotEmpty
          ? (coordinates[0] as num).toDouble()
          : 0.0,
      latitude: coordinates.length > 1
          ? (coordinates[1] as num).toDouble()
          : 0.0,
      depth: coordinates.length > 2
          ? (coordinates[2] as num).toDouble()
          : 0.0,
      url: properties['url']?.toString(),
    );
  }
}
