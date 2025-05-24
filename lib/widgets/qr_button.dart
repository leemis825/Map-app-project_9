import 'package:flutter/material.dart';

class QrButton extends StatelessWidget {
  const QrButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'qr-fab',
      backgroundColor: Colors.deepOrange,
      onPressed: () {
        Navigator.pushNamed(context, '/qr_floor_scan'); // QR로 층 재인식 화면으로 이동
      },
      child: const Icon(Icons.qr_code_scanner, size: 28),
    );
  }
}
