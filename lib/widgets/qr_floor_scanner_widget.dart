import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../data/room_floor_table.dart'; // ✅ 강의실 → 층수 매핑 테이블

class QrFloorScannerWidget extends StatelessWidget {
  final void Function(int)? onFloorDetected;

  const QrFloorScannerWidget({super.key, this.onFloorDetected});

  int? extractFloorFromRoom(String qrText) {
    final match = RegExp(r'\d{3,5}').firstMatch(qrText); // 예: 3108, 10210
    if (match != null) {
      final room = match.group(0);
      return roomToFloorMap[room];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white, // ✅ 흰색 배경
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 320,
        height: 400,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 12),
              child: Text(
                'QR 코드를 사각형 안에 맞춰주세요',
                style: TextStyle(
                  color: Colors.black, // ✅ 검정 텍스트
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 260,
                  height: 260,
                  child: MobileScanner(
                    onDetect: (capture) {
                      for (final barcode in capture.barcodes) {
                        final value = barcode.rawValue;
                        if (value != null) {
                          final floor = extractFloorFromRoom(value);
                          if (floor != null && onFloorDetected != null) {
                            Navigator.of(context).pop();
                            Future.delayed(
                              const Duration(milliseconds: 300),
                              () {
                                onFloorDetected!(floor);
                              },
                            );
                            break;
                          }
                        }
                      }
                    },
                  ),
                ),
                // 녹색 가이드 박스
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.greenAccent, width: 2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0054A7),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('닫기'),
            ),
          ],
        ),
      ),
    );
  }
}
