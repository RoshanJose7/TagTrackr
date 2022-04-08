import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_share/flutter_share.dart';

import 'package:rfid_reader/utils/getfiles.dart';
import 'package:rfid_reader/pages/add_device.dart';
import 'package:rfid_reader/providers/globalstate.dart';

class AllDevicesPage extends StatelessWidget {
  const AllDevicesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _globalstate = Provider.of<GlobalStateProvider>(context);

    Future<void> share() async {
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

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
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
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AddDevicePage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    color: Colors.blueAccent,
                    splashColor: Colors.grey[400],
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: share,
                    icon: const Icon(Icons.share),
                    color: Colors.blueAccent,
                    splashColor: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
          _globalstate.devices.isEmpty
              ? const Center(
                  child: Text("No Devices Found!"),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: _globalstate.devices.length,
                    itemBuilder: (ctx, idx) => Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 30,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Id: " + _globalstate.devices[idx].id),
                            Text("Name: " + _globalstate.devices[idx].name),
                            Text(
                              "TimeStamp: " +
                                  _globalstate.devices[idx].position.timestamp
                                      .toString(),
                            ),
                            Text(
                              "Position: " +
                                  _globalstate.devices[idx].position.latitude
                                      .toString() +
                                  ", " +
                                  _globalstate.devices[idx].position.longitude
                                      .toString(),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    _globalstate.devices[idx].images.length,
                                itemBuilder: (ctx, id) {
                                  return Image(
                                    height: 100,
                                    width: 100,
                                    image: FileImage(
                                        _globalstate.devices[idx].images[id]),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
