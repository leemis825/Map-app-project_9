import 'package:flutter_blue_plus/flutter_blue_plus.dart'; // BLE 스캔용
import 'package:permission_handler/permission_handler.dart'; // 권한 요청용
import 'package:flutter/material.dart'; // ✅ SnackBar 표시용 context

// ✅ 감지된 비콘 정보 클래스: MAC + 건물명 + 층수
class BeaconDetectionResult {
  final String mac;
  final String building;
  final int floor;

  const BeaconDetectionResult({
    required this.mac,
    required this.building,
    required this.floor,
  });
}

// ✅ 비콘 정보 클래스: 건물명 + 층수
class BeaconInfo {
  final String building;
  final int floor;

  const BeaconInfo({required this.building, required this.floor});
}

class BleFloorDetector {
  // ✅ MAC → BeaconInfo (건물명 + 층수) 매핑
  final Map<String, BeaconInfo> beaconMap = {
    'C3:00:00:3F:47:49': BeaconInfo(building: "IT융합대학", floor: 1),
    'C3:00:00:3F:47:3C': BeaconInfo(building: "IT융합대학", floor: 1),
    'C3:00:00:3F:47:4B': BeaconInfo(building: "IT융합대학", floor: 1),
    'C3:00:00:3F:47:45': BeaconInfo(building: "IT융합대학", floor: 2),
    'C3:00:00:3F:47:47': BeaconInfo(building: "IT융합대학", floor: 2),
    // 📌 이후 본관, 체대 등 추가 가능
  };

  // ✅ MAC → RSSI 초기값 (-100은 매우 약한 신호)
  final Map<String, int> beaconRssiMap = {
    'C3:00:00:3F:47:49': -100,
    'C3:00:00:3F:47:3C': -100,
    'C3:00:00:3F:47:4B': -100,
    'C3:00:00:3F:47:45': -100,
    'C3:00:00:3F:47:47': -100,
  };

  // ✅ 가장 강한 비콘만 반환 (주요 기능)
  Future<BeaconDetectionResult?> detectStrongestBeacon({BuildContext? context}) async {
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.locationWhenInUse.request();

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));

    final subscription = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        final mac = result.device.id.id;
        final rssi = result.rssi;

        if (beaconMap.containsKey(mac)) {
          beaconRssiMap[mac] = rssi;
          print("📡 감지된 비콘: $mac / RSSI: $rssi");
        }
      }
    });

    await Future.delayed(const Duration(seconds: 4));
    await FlutterBluePlus.stopScan();
    await subscription.cancel();

    final filtered = beaconRssiMap.entries
        .where((e) => beaconMap.containsKey(e.key))
        .where((e) => e.value > -100)
        .toList();

    if (filtered.isEmpty) {
      print("❌ 등록된 비콘 감지 실패");

      // ✅ 사용자에게 메시지 출력
      if (context != null) {
        showSingleSnackBar(context, "❌ 등록된 비콘이 감지되지 않았습니다.");
      }

      return null;
    }

    final strongest = filtered.reduce((a, b) => a.value > b.value ? a : b);
    final strongestMac = strongest.key;
    final beaconInfo = beaconMap[strongestMac]!;

    print("🏁 최종 선택 비콘: $strongestMac, RSSI: ${strongest.value}");
    print("📍 건물: ${beaconInfo.building}, 층: ${beaconInfo.floor}");

    return BeaconDetectionResult(
      mac: strongestMac,
      building: beaconInfo.building,
      floor: beaconInfo.floor,
    );
  }

  // ✅ 여러 비콘 감지 정보를 콜백으로 넘기는 로그용 메서드 (디버깅용)
  Future<void> detectStrongestBeaconFloorWithLog(
    void Function(String mac, int rssi, int? floor) onBeaconDetected,
  ) async {
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.locationWhenInUse.request();

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));

    final subscription = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult result in results) {
        final mac = result.device.id.id;
        final rssi = result.rssi;

        if (beaconMap.containsKey(mac)) {
          final floor = beaconMap[mac]?.floor;
          print("📡 감지된 비콘: $mac / RSSI: $rssi / 층수: $floor");
          onBeaconDetected(mac, rssi, floor);
        }
      }
    });

    await Future.delayed(const Duration(seconds: 4));
    await FlutterBluePlus.stopScan();
    await subscription.cancel();
  }
}

/// ✅ 중복 메시지 방지 + 스낵바 표시 함수
void showSingleSnackBar(BuildContext context, String message, {int seconds = 2}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: seconds),
        behavior: SnackBarBehavior.floating,
      ),
    );
}
