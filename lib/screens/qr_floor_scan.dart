import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:campus_map_app/data/room_floor_table.dart';
import 'package:campus_map_app/utils/floor_screen_router.dart';

class QrFloorScanScreen extends StatelessWidget {
  const QrFloorScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR로 층 재인식")),
      body: MobileScanner(
        onDetect: (capture) {
          final barcode = capture.barcodes.first;
          final String? code = barcode.rawValue;

          if (code == null) return;

          // ✅ 1. floor_3 같은 직접 층 정보 QR
          if (code.startsWith("floor_")) {
            final floorStr = code.split("_").last;
            final floor = int.tryParse(floorStr);

            if (floor != null) {
              final screen = getScreenForFloor(floor);
              if (screen != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => screen),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("❌ 등록되지 않은 층입니다.")),
                );
              }
            }
          }

          // ✅ 2. room_1125 같은 강의실 코드 → 해당 층으로 매핑 이동
          else if (code.startsWith("room_")) {
            final room = code.replaceFirst("room_", "");
            final int? floor = roomToFloorMap[room];

            if (floor != null) {
              final screen = getScreenForFloor(floor);
              if (screen != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => screen),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("❌ 등록되지 않은 층입니다: $floor")),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("❌ 등록되지 않은 강의실입니다: $room")),
              );
            }
          }

          // ✅ 3. 잘못된 형식
          else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("❌ 유효하지 않은 QR 코드입니다.")),
            );
          }
        },
      ),
    );
  }
}
