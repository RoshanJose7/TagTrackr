class GeoPosition {
  final double latitude;
  final double longitude;
  final DateTime? timestamp;

  GeoPosition({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });
}

class DeviceData {
  final String id;
  final String name;
  final List images;
  final GeoPosition position;
  final String location;

  const DeviceData({
    required this.id,
    required this.name,
    required this.images,
    required this.position,
    required this.location,
  });

  factory DeviceData.fromJson(Map<String, dynamic> json) {
    return DeviceData(
      id: json['id'],
      name: json['name'],
      images: json['images'],
      position: json['position'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'location': location,
        'position': position,
        'images': images,
      };
}
