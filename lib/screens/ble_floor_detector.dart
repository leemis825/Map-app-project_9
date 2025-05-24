import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BleFloorDetector {
  final Map<String, int> beaconRssiMap = {
    'C3:00:00:3F:47:49': -100, // 1층
    'C3:00:00:3F:47:3C': -100, // 1층
    'C3:00:00:3F:47:4B': -100, // 1층
    'C3:00:00:3F:47:45': -100, // 2층
    'C3:00:00:3F:47:47': -100, // 2층
  };

  final Map<String, int> beaconFloorMap = {
    'C3:00:00:3F:47:49': 1,
    'C3:00:00:3F:47:3C': 1,
    'C3:00:00:3F:47:4B': 1,
    'C3:00:00:3F:47:45': 2,
    'C3:00:00:3F:47:47': 2,
  };

  Future<int?> detectStrongestBeaconFloor() async {
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.locationWhenInUse.request();

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));

    final subscription = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        String id = result.device.id.id;
        if (beaconRssiMap.containsKey(id)) {
          beaconRssiMap[id] = result.rssi;
          print('✅ 감지된 비콘: $id / RSSI: ${result.rssi}');
        }
      }
    });

    // 충분히 스캔할 시간 확보
    await Future.delayed(const Duration(seconds: 4));
    await FlutterBluePlus.stopScan();
    await subscription.cancel();

    final filtered = beaconRssiMap.entries.where((e) => e.value > -100).toList();

    if (filtered.isEmpty) {
      print("❌ 비콘 감지 실패");
      return -1;
    }

    final strongest = filtered.reduce((a, b) => a.value > b.value ? a : b);
    print("🏁 가장 강한 비콘: ${strongest.key}, RSSI: ${strongest.value}");

    return beaconFloorMap[strongest.key];
  }
}
