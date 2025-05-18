import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BeaconPosition {
  final String macAddress;
  final int rssi;

  BeaconPosition({required this.macAddress, required this.rssi});
}

class BeaconScanner {
  Future<bool> checkPermissions() async {
    final locationStatus = await Permission.locationWhenInUse.request();
    if (!locationStatus.isGranted) return false;

    if (await Permission.bluetoothScan.isDenied) {
      await Permission.bluetoothScan.request();
    }
    if (await Permission.bluetoothConnect.isDenied) {
      await Permission.bluetoothConnect.request();
    }

    return true;
  }

  Future<BeaconPosition?> scanStrongestBeacon({Duration scanDuration = const Duration(seconds: 3)}) async {
    final hasPermission = await checkPermissions();
    if (!hasPermission) {
      print("🔒 권한 거부됨: BLE 스캔 불가");
      return null;
    }

    final Map<String, BeaconPosition> beaconMap = {};

    // 1. 스캔 시작 (최신 버전은 static 호출)
    await FlutterBluePlus.startScan(timeout: scanDuration);

    // 2. 결과 수신
    final subscription = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        final device = result.device;
        final rssi = result.rssi;

        final mac = device.remoteId.str.toUpperCase();

        const allowedMacs = [
          'C3:00:00:3F:47:49',
          'C3:00:00:3F:47:4B',
          'C3:00:00:3F:47:3C',
        ];

        if (allowedMacs.contains(mac)) {
          beaconMap[mac] = BeaconPosition(macAddress: mac, rssi: rssi);
          print("📡 감지된 비콘: $mac, RSSI: $rssi");
        }
      }
    });

    // 3. 대기 후 스캔 중지
    await Future.delayed(scanDuration);
    await FlutterBluePlus.stopScan();
    await subscription.cancel();

    if (beaconMap.isEmpty) {
      print("📡 비콘을 찾을 수 없습니다.");
      return null;
    }

    // 4. 가장 강한 비콘 선택
    final sorted = beaconMap.values.toList()
      ..sort((a, b) => b.rssi.compareTo(a.rssi));
    return sorted.first;
  }
}
