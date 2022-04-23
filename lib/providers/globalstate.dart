import "dart:io";
import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:rfid_reader/models/device.dart';

class GlobalStateProvider extends ChangeNotifier {
  final storageRef = FirebaseStorage.instance.ref();
  final CollectionReference devicesCollection =
      FirebaseFirestore.instance.collection('devices');

  final List<DeviceData> _devices = [];
  final Stream<QuerySnapshot> devicesStream =
      FirebaseFirestore.instance.collection('devices').snapshots();

  List<DeviceData> _deviceDataFromSnapshot(QuerySnapshot snapshot) {
    List<DeviceData> temp = [];

    for (var d in snapshot.docs) {
      temp.add(DeviceData(
        id: d['id'],
        name: d['name'],
        images: d['images'],
        position: GeoPosition(
          latitude: d['position']['latitude'],
          longitude: d['position']['longitude'],
          timestamp:
              DateTime.parse(d['position']['timestamp'].toDate().toString()),
        ),
        location: d['location'],
      ));
    }

    return temp;
  }

  Stream<List<DeviceData>> get deviceCollectionStream {
    return devicesCollection.snapshots().map(_deviceDataFromSnapshot);
  }

  List<DeviceData> get devices => _devices;

  List<Map<String, dynamic>> toJSON() {
    List<Map<String, dynamic>> data = [];

    for (var element in _devices) {
      data.add(element.toJson());
    }

    return data;
  }

  Future<DeviceData> getDevice(String id) async {
    final dev = await devicesCollection.where('id', isEqualTo: id).get();
    return _deviceDataFromSnapshot(dev).first;
  }

  Future<List<DeviceData>> queryData(
      String queryCategory, String queryString) async {
    var devs = await devicesCollection
        .where(queryCategory, isGreaterThanOrEqualTo: queryString)
        .where(queryCategory, isLessThanOrEqualTo: queryString + '\uf8ff')
        .get();

    notifyListeners();
    return _deviceDataFromSnapshot(devs);
  }

  Future<bool> duplicateDeviceCheck(String id) async {
    var devRef = await devicesCollection.where('id', isEqualTo: id).get();

    try {
      if (devRef.docs[0].exists) return true;
    } catch (err) {
      print(err);
      return false;
    }

    notifyListeners();
    return false;
  }

  void addDevice(DeviceData device) async {
    _devices.add(device);
    List<String> images = [];

    for (var image in device.images) {
      final Reference imgRef =
          storageRef.child("images/" + image.split("/").last);
      final task = imgRef.putFile(File(image));

      final snapshot = await task.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      images.add(downloadUrl);
    }

    await devicesCollection
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

    var doc = await devicesCollection.where('id', isEqualTo: id).get();

    await doc.docs[0].reference.delete().catchError((err) {
      print(err);
    });

    notifyListeners();
  }
}
