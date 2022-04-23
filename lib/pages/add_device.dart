import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

import 'package:rfid_reader/models/device.dart';
import 'package:rfid_reader/utils/getfiles.dart';
import 'package:rfid_reader/utils/location.dart';
import 'package:rfid_reader/providers/globalstate.dart';

class AddDevicePage extends StatefulWidget {
  const AddDevicePage({Key? key}) : super(key: key);

  @override
  State<AddDevicePage> createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  final _formKey = GlobalKey<FormState>();
  bool idTaken = false;

  String _id = "";
  String _name = "";
  String _location = "";

  final List<String> _files = [];

  @override
  Widget build(BuildContext context) {
    final _globalState = Provider.of<GlobalStateProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Add a device")),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Enter a valid id";
                  }

                  if (idTaken) {
                    return "Device ID already taken";
                  }

                  return null;
                },
                onSaved: (val) {
                  if (val != null && val.isNotEmpty) {
                    setState(() {
                      _id = val;
                    });
                  }
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.key),
                  hintText: 'Device ID?',
                  labelText: 'ID *',
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.name,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Enter a valid name";
                  }

                  return null;
                },
                onSaved: (val) {
                  if (val != null && val.isNotEmpty) {
                    setState(() {
                      _name = val;
                    });
                  }
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.computer),
                  hintText: 'Device Name?',
                  labelText: 'Name *',
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.name,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Enter a valid tag";
                  }

                  return null;
                },
                onSaved: (val) {
                  if (val != null && val.isNotEmpty) {
                    setState(() {
                      _location = val;
                    });
                  }
                },
                decoration: const InputDecoration(
                  icon: Icon(Icons.location_on_rounded),
                  hintText: 'Location Tag?',
                  labelText: 'Location Tag *',
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  List<XFile>? results = await getFiles();

                  if (results != null) {
                    setState(() {
                      for(var res in results) {
                        _files.add(res.path);
                      }
                    });
                  }
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.file_open,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      "Select Image *",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Image Preview",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              _files.isEmpty
                  ? const Center(
                      child: Text(
                        "No Images selected!",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : SizedBox(
                      height: 120,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _files.length,
                        itemBuilder: (ctx, idx) => Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: Image.file(File(_files[idx])),
                          ),
                      ),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? validated = _formKey.currentState?.validate();

          if (validated == true && _files.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Saving Data...'),
              ),
            );

            Position pos = await determineLocation();
            _formKey.currentState?.save();

            bool status = await _globalState.duplicateDeviceCheck(_id);

            setState(() {
              idTaken = status;
            });

            if(idTaken) {
              print(idTaken);
              _formKey.currentState?.validate();
              return;
            }

            DeviceData newDevice =
                DeviceData(id: _id, name: _name, location: _location, position: GeoPosition(
                  latitude: pos.latitude,
                  longitude: pos.longitude,
                  timestamp: DateTime.now(),
                ), images: _files);
            _globalState.addDevice(newDevice);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data Saved!'),
              ),
            );

            Navigator.of(context).pop();
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
