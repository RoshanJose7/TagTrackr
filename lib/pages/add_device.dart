import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rfid_reader/models/device.dart';
import 'package:rfid_reader/providers/globalstate.dart';
import 'package:rfid_reader/utils/getfiles.dart';
import 'package:rfid_reader/utils/location.dart';

class AddDevicePage extends StatefulWidget {
  const AddDevicePage({Key? key}) : super(key: key);

  @override
  State<AddDevicePage> createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  final _formKey = GlobalKey<FormState>();
  String _id = "";
  String _name = "";
  final List<File> _files = [];

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () async {
                      FilePickerResult? res = await getfiles();

                      if (res != null) {
                        List<File> files =
                            res.paths.map((path) => File(path!)).toList();

                        setState(() {
                          _files.addAll(files);
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.file_open,
                      color: Colors.grey,
                    ),
                  ),
                  const Text("Upload Device Image"),
                ],
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
                        itemBuilder: (ctx, idx) {
                          return Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: Image(
                              image: FileImage(_files[idx]),
                            ),
                          );
                        },
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
            print(pos);

            _formKey.currentState?.save();

            DeviceData newDevice =
                DeviceData(id: _id, name: _name, position: pos, images: _files);
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
