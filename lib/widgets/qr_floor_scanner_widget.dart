import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../data/room_floor_table.dart'; // ✅ 강의실 → 층수 매핑 테이블

class QrFloorScannerWidget extends StatelessWidget {
  final void Function(int)? onFloorDetected; // ✅ 외부에서 처리할 수 있도록 콜백

  const QrFloorScannerWidget({super.key, this.onFloorDetected});

  // ✅ QR 텍스트에서 강의실 번호(숫자) 추출 후 층수 매핑
  int? extractFloorFromRoom(String qrText) {
    final match = RegExp(r'\d{3,5}').firstMatch(qrText); // 예: 3108, 10210
    if (match != null) {
      final room = match.group(0);
      return roomToFloorMap[room]; // ✅ room_floor_table.dart 참조
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('QR 코드로 층 인식'),
      content: SizedBox(
        width: 300,
        height: 300,
        child: MobileScanner(
          onDetect: (capture) {
            for (final barcode in capture.barcodes) {
              final value = barcode.rawValue;
              if (value != null) {
                final floor = extractFloorFromRoom(value); // ✅ 층수 추출

                if (floor != null && onFloorDetected != null) {
                  Navigator.of(context).pop(); // ✅ 먼저 팝업 닫고

                  // ✅ context 안정화 이후 push 호출
                  Future.delayed(const Duration(milliseconds: 300), () {
                    onFloorDetected!(floor); // ✅ 정확한 층수 전달
                  });
                  break;
                }
              }
            }
          },
        ),
      ),
    );
  }
}
