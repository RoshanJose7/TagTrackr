import "dart:io";
import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:rfid_reader/models/device.dart';

class GlobalStateProvider extends ChangeNotifier {
  final storageRef = FirebaseStorage.instance.ref();
  CollectionReference devs = FirebaseFirestore.instance.collection('devices');

  final List<DeviceData> _devices = [];
  final CollectionReference deviceCollection =
      FirebaseFirestore.instance.collection('devices');
  final Stream<QuerySnapshot> devicesStream =
      FirebaseFirestore.instance.collection('devices').snapshots();

  List<DeviceData> get devices => _devices;

  List<Map<String, dynamic>> toJSON() {
    List<Map<String, dynamic>> data = [];

    for (var element in _devices) {
      data.add(element.toJson());
    }

    return data;
  }

  Future<QueryDocumentSnapshot<Object?>> getDevice(String id) async {
    final dev = await devs.where('id', isEqualTo: id).get();
    return dev.docs[0];
  }

  bool duplicateDeviceCheck(String id) {
    for (DeviceData dev in _devices) {
      if (dev.id == id) {
        notifyListeners();
        return true;
      }
    }

    notifyListeners();
    return false;
  }

  void addDevice(DeviceData device) async {
    _devices.add(device);
    List<String> images = [];

    for (var image in device.images) {
      final Reference imgRef = storageRef.child("images/" + image.split("/").last);
      final task = imgRef.putFile(File(image));

      final snapshot = await task.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      images.add(downloadUrl);
    }

    await deviceCollection
        .add({
          'id': device.id,
          'name': device.name,
          'images': images,
          'position': {
            'latitude': device.position.latitude,
            'longitude': device.position.longitude,
            'timestamp': device.position.timestamp,
          },
          'location': device.location,
        })
        .then((value) => print("Device Added"))
        .catchError((error) => print("Failed to add device: $error"));
  }

  Future<void> removeDevice(String id, List images) async {
    for (var img in images) {
      final imgPath = img.split("?")[0].split("%2F")[1];
      await storageRef.child("images/" + imgPath).delete();
    }

    await devs.doc(id).delete().then((value) => print("Device Deleted"))
        .catchError((error) => print("Failed to delete device: $error"));
  }
}
