import 'package:flutter_blue_plus/flutter_blue_plus.dart';

Future<int?> scanNearestBeaconMinor() async {
  final Set<String> targetMacs = {
    "C3:00:00:3F:47:49",
    "C3:00:00:3F:47:4B",
    "C3:00:00:3F:47:3C",
    // 이후 추가할 MAC 주소들 여기에 확장 가능
  };

  await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));

  final results = await FlutterBluePlus.scanResults.first;

  await FlutterBluePlus.stopScan();

  if (results.isEmpty) return null;

  final filtered = results.where((r) => targetMacs.contains(r.device.remoteId.str)).toList();
  if (filtered.isEmpty) return null;

  filtered.sort((a, b) => b.rssi.compareTo(a.rssi));
  final strongest = filtered.first;

  final mac = strongest.device.remoteId.str;
  final manufacturerData = strongest.advertisementData.manufacturerData;

  int? minor;

  // 제조사 데이터에서 minor 추출 (일반적으로 4~5번째 byte)
  if (manufacturerData.isNotEmpty) {
    final raw = manufacturerData.values.first;
    if (raw.length >= 6) {
      // 2 byte major, 다음 2 byte minor
      minor = (raw[4] << 8) | raw[5]; // 5,6번째 바이트로 minor 계산
    }
  }

  print("📡 MAC: $mac, minor: $minor");

  if (minor == null) return null;

  // ✅ 층 매핑 (확장 가능 구조)
  if (minor == 1) return 2; // minor = 1 → 2층
  if (minor == 2) return 5; // minor = 2 → 5층

  // 🔧 미래 확장 예시:
  // if (minor == 3) return 3; // 3층
  // if (minor == 4) return 4; // 4층
  // if (minor == 5) return 6; // 6층
  // if (minor == 6) return 7; // 7층
  // if (minor == 7) return 8; // 8층
  // if (minor == 8) return 9; // 9층
  // if (minor == 9) return 10; // 10층

  return null;
}
