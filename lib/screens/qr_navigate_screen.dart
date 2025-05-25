import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

import 'package:campus_map_app/data/room_floor_table.dart'; // ✅ 강의실명 → 층수 매핑 테이블

class QrNavigateScreen extends StatefulWidget {
  final void Function(int floor)? onFloorDetected; // ✅ 메뉴로 층 전달용 콜백

  const QrNavigateScreen({super.key, this.onFloorDetected});

  @override
  State<QrNavigateScreen> createState() => _QrNavigateScreenState();
}

class _QrNavigateScreenState extends State<QrNavigateScreen> {
  String? currentRoom; // ✅ QR로 감지된 출발 강의실
  bool scannerUsed = false;

  // ✅ 경로 안내 팝업창 (출발지 + 도착지 입력 받기)
  void _showRouteInput() async {
    String startInput = currentRoom ?? '';
    String destInput = '';

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("경로 안내"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "출발 강의실 (예: IT1101)"),
                controller: TextEditingController(text: startInput),
                onChanged: (v) => startInput = v,
              ),
              TextField(
                decoration: const InputDecoration(labelText: "도착 강의실 (예: IT3208)"),
                onChanged: (v) => destInput = v,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (startInput.isNotEmpty && destInput.isNotEmpty) {
                  Navigator.pop(context);
                  _loadPathAndNavigate(startInput.trim(), destInput.trim());
                }
              },
              child: const Text("경로 보기"),
            )
          ],
        );
      }
    );
  }

  // ✅ paths.json 로딩 및 경로 탐색 후 화면 전환
  Future<void> _loadPathAndNavigate(String start, String end) async {
    final key = '${start}_${end}';

    try {
      final jsonStr = await rootBundle.loadString('assets/data/paths.json');
      final Map<String, dynamic> pathsData = json.decode(jsonStr);

      if (pathsData.containsKey(key)) {
        final path = pathsData[key]['path'];
        debugPrint("🔽 경로 데이터 불러오기 성공: $key");

        // ✅ 여기서 경로 시각화 전용 화면으로 넘겨야 함 (예: PathResultScreen)
        // Navigator.push(...)

        _showMessage("경로 데이터를 불러왔습니다. (시각화는 다음 화면에서)");

      } else {
        _showMessage("❌ 해당 경로 정보가 없습니다 ($key).");
      }
    } catch (e) {
      _showMessage("❌ 경로 데이터를 불러오는 중 오류 발생");
      debugPrint(e.toString());
    }
  }

  // ✅ 에러 또는 안내 메시지 출력
  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR로 출발 강의실 인식")),
      body: MobileScanner(
        onDetect: (capture) {
          if (scannerUsed) return;

          final barcode = capture.barcodes.first;
          final value = barcode.rawValue;

          if (value != null && value.startsWith("room_")) {
            scannerUsed = true;
            currentRoom = value.replaceFirst("room_", "");
            debugPrint("📍 QR 인식된 현재 강의실: $currentRoom");
            _showRouteInput(); // ✅ 인식 후 경로 안내 창 띄움
          } else {
            _showMessage("❌ 유효한 QR 코드(room_****)가 아닙니다.");
          }
        },
      ),
    );
  }
}
