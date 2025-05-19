import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BleFloorDetector {
  final Map<String, int> beaconRssiMap = {
    'C3:00:00:3F:47:51': -100,
    'C3:00:00:3F:47:50': -100,
    'C3:00:00:3F:47:3F': -100,
    'C3:00:00:3F:47:47': -100,
    'C3:00:00:3F:47:45': -100,
    'C3:00:00:3F:47:41': -100,
    'C3:00:00:3F:47:4D': -100,
  };

  final Map<String, int> beaconFloorMap = {
    'C3:00:00:3F:47:51': 1,
    'C3:00:00:3F:47:50': 1,
    'C3:00:00:3F:47:3F': 2,
    'C3:00:00:3F:47:47': 2,
    'C3:00:00:3F:47:45': 3,
    'C3:00:00:3F:47:41': 3,
    'C3:00:00:3F:47:4D': 4,
  };

  Future<int?> detectStrongestBeaconFloor() async {
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.location.request();

    await FlutterBluePlus.startScan(timeout: Duration(seconds: 4));

    final results = await FlutterBluePlus.scanResults.first;

    for (ScanResult r in results) {
      String id = r.device.id.id;
      if (beaconRssiMap.containsKey(id)) {
        beaconRssiMap[id] = r.rssi;
      }
    }

    final strongest = beaconRssiMap.entries.reduce((a, b) => a.value > b.value ? a : b);

    return beaconFloorMap[strongest.key];
  }
}
