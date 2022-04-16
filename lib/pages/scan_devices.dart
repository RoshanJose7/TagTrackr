import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rfid_reader/providers/globalstate.dart';
import 'package:rfid_reader/widgets/device_card.dart';

class ScanDevicesPage extends StatefulWidget {
  const ScanDevicesPage({Key? key}) : super(key: key);

  @override
  State<ScanDevicesPage> createState() => _ScanDevicesPageState();
}

class _ScanDevicesPageState extends State<ScanDevicesPage> {
  bool _scanMode = false;
  final _controller = TextEditingController(text: "");
  final List _devices = [];

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _media = MediaQuery.of(context);
    final _globalState = Provider.of<GlobalStateProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
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

                      setState(() async {
                        _devices.add(await _globalState.getDevice(val));
                        _controller.clear();
                      });

                      _globalState.getDevice(val);
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
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                _scanMode
                    ? IconButton(
                        onPressed: () => setState(() {
                          _scanMode = false;
                        }),
                        icon: const Icon(
                          Icons.stop_circle_rounded,
                          color: Colors.red,
                          size: 30,
                        ),
                      )
                    : IconButton(
                        onPressed: () => setState(() {
                          _scanMode = true;
                        }),
                        icon: Icon(
                          Icons.qr_code_scanner_rounded,
                          color: _theme.primaryColor,
                          size: 30,
                        ),
                      ),
              ],
            ),
            SizedBox(
              height: _media.size.height * 0.8,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: _devices.isEmpty
                    ? const Center(
                        child: Text("No Devices Found Yet!"),
                      )
                    : ListView.builder(
                        itemCount: _devices.length,
                        itemBuilder: (ctx, idx) => DeviceCard(device: _devices[idx]),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
