import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../data/room_floor_table.dart'; // ✅ 강의실 → 층수 매핑 테이블

class QrFloorScannerWidget extends StatefulWidget {
  final void Function(int)? onFloorDetected;

  const QrFloorScannerWidget({super.key, this.onFloorDetected});

  @override
  State<QrFloorScannerWidget> createState() => _QrFloorScannerWidgetState();
}

class _QrFloorScannerWidgetState extends State<QrFloorScannerWidget> {
  DateTime? lastErrorTime; // ✅ 마지막 오류 메시지 시각 저장

  // ✅ QR 코드 텍스트에서 강의실 번호를 추출하고, 해당 층 정보를 반환
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
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: 320,
        height: 400,
        child: Column(
          children: [
            // ✅ 안내 문구
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 12),
              child: Text(
                'QR 코드를 사각형 안에 맞춰주세요',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // ✅ QR 스캐너와 가이드 박스
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 260,
                  height: 260,
                  child: MobileScanner(
                    onDetect: (capture) {
                      bool validQrFound = false;

                      for (final barcode in capture.barcodes) {
                        final value = barcode.rawValue;
                        if (value != null) {
                          final floor = extractFloorFromRoom(value);
                          if (floor != null && widget.onFloorDetected != null) {
                            Navigator.of(context).pop(); // ✅ 다이얼로그 닫기
                            Future.delayed(const Duration(milliseconds: 300), () {
                              widget.onFloorDetected!(floor);
                            });
                            validQrFound = true;
                            break;
                          }
                        }
                      }

                      // ✅ 유효한 QR이 하나도 없을 경우 → SnackBar 중복 방지
                      if (!validQrFound) {
                        final now = DateTime.now();
                        if (lastErrorTime == null ||
                            now.difference(lastErrorTime!) > const Duration(seconds: 3)) {
                          lastErrorTime = now;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("❌ 유효한 QR을 인식하시오."),
                              backgroundColor: Colors.redAccent,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),

                // ✅ 녹색 테두리 가이드 박스
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

            // ✅ 닫기 버튼
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
