import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rfid_reader/models/device.dart';
import 'package:rfid_reader/providers/globalstate.dart';

class DeviceCard extends StatelessWidget {
  final DeviceData device;

  const DeviceCard({
    Key? key,
    required this.device,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _globalState = Provider.of<GlobalStateProvider>(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            Row(
              children: [
                SizedBox(
                  height: 160,
                  width: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: device.images.length,
                    itemBuilder: (ctx, id) {
                      return Image.network(
                        device.images[id],
                        height: 140,
                        width: 100,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 15),
                SizedBox(
                  height: 160,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            device.id,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            device.name,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.timelapse,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${device.position.timestamp!.year}-${device.position.timestamp!.month.toString().padLeft(2, '0')}-${device.position.timestamp!.day.toString().padLeft(2, '0')}",
                                style: const TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                "${device.position.timestamp!.hour.toString().padLeft(2, '0')}-${device.position.timestamp!.minute.toString().padLeft(2, '0')}",
                                style: const TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_city,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            device.location,
                            style: const TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            color: Colors.black54,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "lat: ${device.position.latitude.toStringAsFixed(3)}",
                                style: const TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                "long: ${device.position.longitude.toStringAsFixed(3)}",
                                style: const TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Confirm Delete?"),
                          InkWell(
                            onTap: () async => await _globalState.removeDevice(
                                device.id, device.images),
                            child: const Text(
                              "Confirm",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: const Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
