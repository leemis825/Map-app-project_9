import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../screens/ble_floor_detector.dart';
import 'qr_floor_scanner_widget.dart';

class LocateButton extends StatelessWidget {
  final void Function(int floor)? onFloorDetected;

  const LocateButton({super.key, this.onFloorDetected});

  // ✅ BLE 스캔 + 로딩 다이얼로그 처리
  void _handleScanAndNavigate(BuildContext context) async {
    final isBluetoothOn = await FlutterBluePlus.isOn;

    // ✅ 블루투스 꺼진 경우 알림 팝업
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

    // ✅ 로딩 다이얼로그 띄우기
    _showLoadingDialog(context);

    // ✅ BLE 비콘 감지 시작
    final result = await BleFloorDetector().detectStrongestBeacon(context: context);

    // ✅ 로딩 다이얼로그 닫기
    Navigator.of(context).pop();

    // ✅ 감지 실패
    if (result == null || result.floor == -1) {
      showSingleSnackBar(context, "❌ 비콘 감지 실패\nQR로 재인식 화면으로 이동합니다.");
      Future.delayed(const Duration(seconds: 2), () {
        _showQrScanDialog(context);
      });
      return;
    }

    // ✅ 지원되지 않는 건물
    if (result.building != "IT융합대학") {
      showSingleSnackBar(context, "⚠ ${result.building} 비콘은 현재 지원되지 않습니다");
      return;
    }

    // ✅ 감지 성공 → 사용자 확인 팝업
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

  // ✅ 로딩 다이얼로그 UI
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // 뒤로 가기 금지
      barrierColor: Colors.black.withOpacity(0.4), // 반투명 배경
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          width: 200,
          height: 160,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(color: Color(0xFF0054A7)),
              SizedBox(height: 16),
              Text(
                '비콘을 찾는 중입니다...',
                style: TextStyle(fontSize: 14, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ QR로 재설정 팝업
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

  // ✅ QR 스캐너 위젯 호출
  void _showQrScanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => QrFloorScannerWidget(
        onFloorDetected: onFloorDetected,
      ),
    );
  }

  // ✅ Locate 버튼 UI
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'home-locate-fab',
      backgroundColor: const Color(0xFF0054A7),
      onPressed: () => _handleScanAndNavigate(context),
      child: const Icon(Icons.my_location, color: Colors.white),
    );
  }
}

// ✅ 중복 방지용 스낵바 유틸 함수
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
