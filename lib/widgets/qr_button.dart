// ✅ qr_button.dart - QR 버튼 눌렀을 때 팝업으로 카메라 띄우고 도면 이동
import 'package:flutter/material.dart';
import 'qr_floor_scanner_widget.dart'; // ✅ QR 스캐너 팝업 위젯 import

class QrButton extends StatelessWidget {
  final void Function(int)? onFloorDetected; // ✅ 상위에 결과 전달

  const QrButton({super.key, this.onFloorDetected});

  void _showQrScanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (_) => QrFloorScannerWidget(
            onFloorDetected: onFloorDetected, // ✅ 콜백 전달
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'qr-fab',
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF0054A7),
      onPressed: () => _showQrScanDialog(context),
      child: const Icon(Icons.qr_code_scanner, size: 28),
    );
  }
}
