import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rfid_reader/models/device.dart';
import 'package:rfid_reader/providers/globalstate.dart';

class ScanDevicesPage extends StatefulWidget {
  const ScanDevicesPage({Key? key}) : super(key: key);

  @override
  State<ScanDevicesPage> createState() => _ScanDevicesPageState();
}

class _ScanDevicesPageState extends State<ScanDevicesPage> {
  bool _scanMode = false;
  final _controller = TextEditingController(text: "");
  final List<DeviceData> _devices = [];

  @override
  Widget build(BuildContext context) {
    final _media = MediaQuery.of(context);
    final _globalstate = Provider.of<GlobalStateProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_scanMode)
              Visibility(
                visible: false,
                maintainState: true,
                child: TextFormField(
                  controller: _controller,
                  autofocus: true,
                  onChanged: (val) {
                    if (val.endsWith("\n")) {
                      val = val.substring(0, val.length - 1);

                      setState(() {
                        _devices.add(_globalstate.getDevice(val));
                        _controller.clear();
                      });

                      _globalstate.getDevice(val);
                    }
                  },
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Device List",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                _scanMode
                    ? ElevatedButton(
                        onPressed: () => setState(() {
                          _scanMode = false;
                        }),
                        child: const Text("Stop Scanning"),
                      )
                    : ElevatedButton(
                        onPressed: () => setState(() {
                          _scanMode = true;
                        }),
                        child: const Text("Start Scanning"),
                      ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: SizedBox(
                height: _media.size.height * 0.72,
                child: _devices.isEmpty
                    ? const Center(
                        child: Text("No Devices Found Yet!"),
                      )
                    : ListView.builder(
                        itemCount: _devices.length,
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
                                Text("Id: " + _devices[idx].id),
                                Text("Name: " + _devices[idx].name),
                                Text(
                                  "TimeStamp: " +
                                      _devices[idx]
                                          .position
                                          .timestamp
                                          .toString(),
                                ),
                                Text(
                                  "Position: " +
                                      _devices[idx]
                                          .position
                                          .latitude
                                          .toString() +
                                      ", " +
                                      _devices[idx]
                                          .position
                                          .longitude
                                          .toString(),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height: 100,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _devices[idx].images.length,
                                    itemBuilder: (ctx, id) {
                                      return Image(
                                        height: 100,
                                        width: 100,
                                        image:
                                            FileImage(_devices[idx].images[id]),
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
            ),
          ],
        ),
      ),
    );
  }
}
