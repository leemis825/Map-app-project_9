import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../screens/ble_floor_detector.dart'; // BLE 감지 클래스

// 각 층별 도면 화면 임포트
import '../screens/it_building_1f_screen.dart';
import '../screens/it_building_2f_screen.dart';
import '../screens/it_building_3f_screen.dart';
import '../screens/it_building_4f_screen.dart';
import '../screens/it_building_5f_screen.dart';
import '../screens/it_building_6f_screen.dart';
import '../screens/it_building_7f_screen.dart';
import '../screens/it_building_8f_screen.dart';
import '../screens/it_building_9f_screen.dart';
import '../screens/it_building_10f_screen.dart';

class LocateButton extends StatelessWidget {
  const LocateButton({super.key});

  // ✅ BLE 감지 및 층 이동 제어
  void _handleScanAndNavigate(BuildContext context) async {
    final isBluetoothOn = await FlutterBluePlus.isOn;
    if (!isBluetoothOn) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('⚠ Bluetooth 꺼짐'),
          content: const Text('비콘을 감지하려면 블루투스를 켜주세요.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("현재 위치를 확인 중입니다...")),
    );

    final floor = await BleFloorDetector().detectStrongestBeaconFloor();

    // ✅ 비콘 감지 실패 시 QR로 이동
    if (floor == null || floor == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ 비콘을 감지하지 못했습니다.\nQR로 재인식 화면으로 이동합니다."),
        ),
      );

      // 잠깐 대기 후 QR 층 재인식 화면으로 자동 이동
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushNamed(context, '/qr_floor_scan');
      });

      return;
    }

    // ✅ 사용자에게 확인 요청 팝업
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('비콘 감지 정보'),
        content: Text("감지된 층수는 ${floor}층입니다.\n현재 위치가 맞습니까?"),
        actions: [
          // 예 → 해당 층 도면으로 이동
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _navigateToFloor(context, floor);
            },
            child: const Text('예'),
          ),
          // 아니요 → QR 또는 직접 선택
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("위치를 다시 설정할까요?"),
                  content: const Text("아래 중 하나를 선택하세요."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/qr_floor_scan');
                      },
                      child: const Text('QR로 인식'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pushNamed(context, '/floor_selector');
                      },
                      child: const Text('직접 선택'),
                    ),
                  ],
                ),
              );
            },
            child: const Text('아니요'),
          ),
        ],
      ),
    );
  }

  // ✅ 감지된 층수에 맞는 도면 화면으로 이동
  void _navigateToFloor(BuildContext context, int floor) {
    Widget screen;
    switch (floor) {
      case 1: screen = ItBuilding1fScreen(); break;
      case 2: screen = ItBuilding2fScreen(); break;
      case 3: screen = ItBuilding3fScreen(); break;
      case 4: screen = ItBuilding4fScreen(); break;
      case 5: screen = ItBuilding5fScreen(); break;
      case 6: screen = ItBuilding6fScreen(); break;
      case 7: screen = ItBuilding7fScreen(); break;
      case 8: screen = ItBuilding8fScreen(); break;
      case 9: screen = ItBuilding9fScreen(); break;
      case 10: screen = ItBuilding10fScreen(); break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("알 수 없는 층입니다: $floor")),
        );
        return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          heroTag: 'home-locate-fab',
          backgroundColor: const Color(0xFF004098),
          onPressed: () => _handleScanAndNavigate(context),
          child: const Icon(Icons.my_location),
        ),
      ),
    );
  }
}
