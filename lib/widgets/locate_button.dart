import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../screens/ble_floor_detector.dart';
import 'qr_floor_scanner_widget.dart';

class LocateButton extends StatelessWidget {
  final void Function(int floor)? onFloorDetected;

  const LocateButton({super.key, this.onFloorDetected});

  void _handleScanAndNavigate(BuildContext context) async {
    final isBluetoothOn = await FlutterBluePlus.isOn;
    if (!isBluetoothOn) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('⚠ Bluetooth 꺼짐', style: TextStyle(color: Colors.black)),
          content: const Text('비콘을 감지하려면 블루투스를 켜주세요.', style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF0054A7),
              ),
              child: const Text('확인'),
            ),
          ],
        ),
      );
      return;
    }

    showSingleSnackBar(context, "📡 현재 위치를 확인 중입니다...");

    final result = await BleFloorDetector().detectStrongestBeacon(context: context);

    if (result == null || result.floor == -1) {
      showSingleSnackBar(context, "❌ 비콘 감지 실패\nQR로 재인식 화면으로 이동합니다.");
      Future.delayed(const Duration(seconds: 2), () {
        _showQrScanDialog(context);
      });
      return;
    }

    if (result.building != "IT융합대학") {
      showSingleSnackBar(context, "⚠ ${result.building} 비콘은 현재 지원되지 않습니다");
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('비콘 감지 결과', style: TextStyle(color: Colors.black)),
        content: Text(
          "현재 ${result.building} ${result.floor}층으로 감지되었습니다.\n맞습니까?",
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onFloorDetected != null) {
                onFloorDetected!(result.floor);
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF0054A7),
            ),
            child: const Text('예'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showReconfirmDialog(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF0054A7),
            ),
            child: const Text('아니요'),
          ),
        ],
      ),
    );
  }

  void _showReconfirmDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("위치를 다시 설정할까요?", style: TextStyle(color: Colors.black)),
        content: const Text("원하는 방식으로 위치를 재설정하세요.", style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showQrScanDialog(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF0054A7),
            ),
            child: const Text('QR로 인식'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/floor_selector');
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color(0xFF0054A7),
            ),
            child: const Text('직접 선택'),
          ),
        ],
      ),
    );
  }

  void _showQrScanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => QrFloorScannerWidget(
        onFloorDetected: onFloorDetected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'home-locate-fab',
      backgroundColor: const Color(0xFF0054A7),
      onPressed: () => _handleScanAndNavigate(context),
      child: const Icon(
        Icons.my_location,
        color: Colors.white,
      ),
    );
  }
}

/// ✅ 중복 방지용 스낵바 유틸 함수
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
