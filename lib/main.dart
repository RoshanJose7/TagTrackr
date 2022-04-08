import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rfid_reader/pages/scan_devices.dart';
import 'package:rfid_reader/pages/all_devices.dart';
import 'package:rfid_reader/providers/globalstate.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => GlobalStateProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RFID Reader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _curIdx = 0;
  final _pages = const [
    ScanDevicesPage(),
    AllDevicesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("RFID Reader"),
      ),
      body: _pages[_curIdx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _curIdx,
        onTap: (idx) => setState(() {
          _curIdx = idx;
        }),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.scanner_rounded), label: "Scan"),
          BottomNavigationBarItem(icon: Icon(Icons.devices), label: "Devices"),
        ],
      ),
    );
  }
}
