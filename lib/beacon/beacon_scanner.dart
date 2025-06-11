import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BeaconScanner {
  // ✅ 정확한 타입 지정
  StreamSubscription<List<ScanResult>>? _scanSubscription;

  Future<void> startScanning({
    required void Function(String mac, int rssi, int minor) onBeaconDetected,
  }) async {
    // ✅ 스캔 시작 (static 메서드)
    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 4),
      androidUsesFineLocation: true,
    );

    // ✅ scanResults는 List<ScanResult>
    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        final mac = r.device.remoteId.toString(); // MAC 주소
        final rssi = r.rssi;

        final advData = r.advertisementData.manufacturerData;
        if (advData.isNotEmpty) {
          final data = advData.values.first;
          if (data.length >= 4) {
            final minor = (data[2] << 8) | data[3]; // minor 추출
            onBeaconDetected(mac, rssi, minor);
          }
        }
      }
    });
  }

  void stopScanning() {
    _scanSubscription?.cancel();
    FlutterBluePlus.stopScan(); // ✅ 스캔 정지 (static 메서드)
  }
}
