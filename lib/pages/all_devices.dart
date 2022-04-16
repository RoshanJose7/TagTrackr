import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:rfid_reader/models/device.dart';

import 'package:rfid_reader/utils/getfiles.dart';
import 'package:rfid_reader/utils/permission.dart';
import 'package:rfid_reader/pages/add_device.dart';
import 'package:rfid_reader/providers/globalstate.dart';
import 'package:rfid_reader/widgets/device_card.dart';

class AllDevicesPage extends StatefulWidget {
  const AllDevicesPage({Key? key}) : super(key: key);

  @override
  State<AllDevicesPage> createState() => _AllDevicesPageState();
}

class _AllDevicesPageState extends State<AllDevicesPage> {
  @override
  Widget build(BuildContext context) {
    final _globalstate = Provider.of<GlobalStateProvider>(context);
    final _media = MediaQuery.of(context);

    Future<void> _share() async {
      String? path = await downloadDirPath;

      if (path != null) {
        File file = await createFile(
            path,
            "${DateTime.now().millisecondsSinceEpoch}.json",
            _globalstate.toJSON().toString());

        await FlutterShare.shareFile(
          title: 'JSON Data',
          text: 'Exported JSON Data File',
          filePath: file.path,
        );
      }
    }

    Future<void> _add() async {
      bool status = await getLocationPermission();

      if (!status) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Grant Location Access to move forward!")));

        return;
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const AddDevicePage(),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "All Devices",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _add,
                    icon: const Icon(Icons.add),
                    color: Colors.blueAccent,
                    splashColor: Colors.grey[400],
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: _share,
                    icon: const Icon(Icons.share),
                    color: Colors.blueAccent,
                    splashColor: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: _media.size.height * 0.7,
              child: StreamBuilder<List<DeviceData>>(
                stream: _globalstate.deviceCollectionStream,
                builder: (ctx, AsyncSnapshot<List<DeviceData>> snapshot) {
                  print(snapshot.connectionState);
                  print(snapshot.data);
                  print(snapshot.hasData);

                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return const Text('Something went wrong');
                  } else if (snapshot.hasData) {
                    List<DeviceData> devs = snapshot.data!;

                    return devs.isEmpty
                        ? const Center(
                            child: Text("No Devices Registered!"),
                          )
                        : ListView.builder(
                            itemCount: devs.length,
                            itemBuilder: (context, index) {
                              return DeviceCard(
                                  device: devs[index]);
                            },
                          );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
