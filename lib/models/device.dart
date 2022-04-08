import 'dart:io';

import 'package:geolocator/geolocator.dart';

class DeviceData {
  final String id;
  final String name;
  final Position position;
  final List<File> images;

  const DeviceData({
    required this.id,
    required this.name,
    required this.position,
    required this.images,
  });

  factory DeviceData.fromJson(Map<String, dynamic> json) {
    return DeviceData(
      id: json['name'],
      name: json['age'],
      position: json['hobby'],
      images: json['images'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'position': position,
        'images': images,
      };
}
