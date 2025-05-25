// lib/widgets/ble_debug_popup.dart

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../screens/ble_floor_detector.dart';

class BleDebugPopup {
  static bool _alreadyShown = false;

  static void show(BuildContext context) async {
    if (_alreadyShown) return;
    _alreadyShown = true;

    final ble = BleFloorDetector();
    final resultLines = <String>[];

    // ✅ 감지된 MAC → RSSI → 건물/층 정보 매핑
    await ble.detectStrongestBeaconFloorWithLog((mac, rssi, floor) {
      final beaconInfo = ble.beaconMap[mac.toUpperCase()];
      final building = beaconInfo?.building ?? '미등록';
      final floorStr = floor != null ? '$floor층' : '미확인';

      resultLines.add("• $mac ($building) / RSSI: $rssi / 층수: $floorStr");
    });

    // ✅ 팝업 출력
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("📡 BLE 감지 결과"),
          content: Text(resultLines.isEmpty
              ? "❌ 등록된 비콘이 감지되지 않았습니다."
              : resultLines.join("\n")),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("확인"),
            ),
          ],
        ),
      );
    }
  }
}
