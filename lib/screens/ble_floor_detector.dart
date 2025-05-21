import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BleFloorDetector {
  final Map<String, int> beaconRssiMap = {
    'C3:00:00:3F:47:51': -100,
    'C3:00:00:3F:47:50': -100,
    'C3:00:00:3F:47:3F': -100,
    'C3:00:00:3F:47:41': -100,
    'C3:00:00:3F:47:4D': -100,
  };

  final Map<String, int> beaconFloorMap = {
    'C3:00:00:3F:47:51': 1,
    'C3:00:00:3F:47:50': 2,
    'C3:00:00:3F:47:3F': 3,
    'C3:00:00:3F:47:41': 4,
    'C3:00:00:3F:47:4D': 5,
  };

  Future<int?> detectStrongestBeaconFloor() async {
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.location.request();

    await FlutterBluePlus.startScan(timeout: Duration(seconds: 5));

    final subscription = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        String id = result.device.id.id;
        if (beaconRssiMap.containsKey(id)) {
          beaconRssiMap[id] = result.rssi;
          print('✅ 감지된 비콘: $id / RSSI: ${result.rssi}');
        }
      }
    });

    // 5초간 기다리기
    await Future.delayed(Duration(seconds: 3));

    await FlutterBluePlus.stopScan();
    await subscription.cancel();

    // 실제 감지된 비콘만 필터링
    final filtered = beaconRssiMap.entries.where((e) => e.value > -100).toList();

    if (filtered.isEmpty) {
      print("❌ 비콘을 감지하지 못했습니다.");
      return -1; // 감지 실패
    }

    // 가장 강한 비콘 찾기
    final strongest = beaconRssiMap.entries.reduce((a, b) => a.value > b.value ? a : b);
    print("🏁 가장 강한 비콘: ${strongest.key}, RSSI: ${strongest.value}");

    return beaconFloorMap[strongest.key];
  }
}
