import 'package:flutter/material.dart';
import '../models/device.dart';

class DeviceCard extends StatelessWidget {
  final DeviceData device;

  const DeviceCard({
    Key? key,
    required this.device,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            SizedBox(
              height: 130,
              width: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: device.images.length,
                itemBuilder: (ctx, id) {
                  return Image(
                    height: 130,
                    width: 100,
                    image: FileImage(device.images[id]),
                  );
                },
              ),
            ),
            const SizedBox(width: 15),
            SizedBox(
              height: 130,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    device.id,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    device.name,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            "${device.position.timestamp!.year.toString()}-${device.position.timestamp!.month.toString().padLeft(2, '0')}-${device.position.timestamp!.day.toString().padLeft(2, '0')}",
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            "lat: " + device.position.latitude.toString(),
                            style: const TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            "long" + device.position.longitude.toString(),
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
      ),
    );
  }
}
