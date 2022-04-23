import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rfid_reader/providers/globalstate.dart';

import '../models/device.dart';
import '../widgets/device_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<DeviceData> _searchDevices = [];
  String _filter = "id";

  @override
  Widget build(BuildContext context) {
    final _globalState = Provider.of<GlobalStateProvider>(context);

    void _search(String? val) async {
      if (val != null) {
        var devices = await _globalState.queryData(_filter, val);
        print(devices);

        setState(() {
          _searchDevices = devices;
        });
      }
    }

    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextFormField(
                  controller: _searchController,
                  onChanged: _search,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    hintStyle: const TextStyle(
                      fontSize: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.blueAccent,
                        width: 5,
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 110,
                        child: ListTile(
                          title: const Text("Id"),
                          leading: Radio(
                            value: "id",
                            groupValue: _filter,
                            onChanged: (String? value) {
                              if (value != null) {
                                setState(() {
                                  _filter = value;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 190,
                        child: ListTile(
                          title: const Text("Device Name"),
                          leading: Radio(
                            value: "name",
                            groupValue: _filter,
                            onChanged: (String? value) {
                              if (value != null) {
                                setState(() {
                                  _filter = value;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: ListTile(
                          title: const Text("Location Tag"),
                          leading: Radio(
                            value: "location",
                            groupValue: _filter,
                            onChanged: (String? value) {
                              if (value != null) {
                                setState(() {
                                  _filter = value;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: _searchDevices.isEmpty
                        ? const Center(
                            child: Text("No Devices Found Yet!"),
                          )
                        : ListView.builder(
                            itemCount: _searchDevices.length,
                            itemBuilder: (ctx, idx) =>
                                DeviceCard(device: _searchDevices[idx]),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
