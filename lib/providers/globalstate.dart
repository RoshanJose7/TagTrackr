import "package:flutter/material.dart";
import '../models/device.dart';

class GlobalStateProvider extends ChangeNotifier {
  final List<DeviceData> _devices = [];

  List<DeviceData> get devices => _devices;

  List<Map<String, dynamic>> toJSON() {
    List<Map<String, dynamic>> data = [];

    for (var element in _devices) {
      data.add(element.toJson());
    }

    return data;
  }

  DeviceData getDevice(String id) {
    return _devices.firstWhere((d) => d.id == id);
  }

  void addDevice(DeviceData device) {
    _devices.add(device);
    notifyListeners();
  }

  void removeDevice(String id) {
    DeviceData? device;

    for (var dev in _devices) {
      if (dev.id == id) device = dev;
    }

    if (device != null) {
      _devices.remove(device);
    }

    notifyListeners();
  }
}
