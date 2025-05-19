import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:campus_map_app/beacon/beacon_scanner.dart';
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

  void _handleScanAndNavigate(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      final isBluetoothOn = await FlutterBluePlus.isOn;
      if (!isBluetoothOn) {
        // ✅ Bluetooth 꺼져 있으면 안내 팝업
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
        const SnackBar(content: Text("현재 위치로 이동 중입니다.")),
      );

      final scanner = BeaconScanner();

      final allowedBeacons = {
        "c3:00:00:3f:47:3c",
        "c3:00:00:3f:47:4b",
        "c3:00:00:3f:47:49",
      };

      Map<String, int> rssiMap = {};
      Map<String, int> minorMap = {};

      await scanner.startScanning(
        onBeaconDetected: (mac, rssi, minor) {
          final lowerMac = mac.toLowerCase();
          if (!allowedBeacons.contains(lowerMac)) {
            print("⛔ 외부 비콘 무시됨: $mac");
            return;
          }

          print("✅ 감지된 비콘: $mac | RSSI: $rssi | minor: $minor");
          rssiMap[mac] = rssi;
          minorMap[mac] = minor;
        },
      );

      await Future.delayed(const Duration(seconds: 4));
      scanner.stopScanning();

      if (rssiMap.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("내 비콘이 감지되지 않았습니다.")),
        );
        return;
      }

      final strongestMac = rssiMap.entries.reduce((a, b) => a.value > b.value ? a : b).key;
      final strongestRssi = rssiMap[strongestMac];
      final detectedMinor = minorMap[strongestMac];

      int? floor;
      switch (detectedMinor) {
        case 1:
          floor = 1;
          break;
        case 2:
          floor = 2;
          break;
        case 3:
          floor = 3;
          break;
        case 4:
          floor = 4;
          break;
        case 5:
          floor = 5;
          break;
        case 6:
          floor = 6;
          break;
        case 7:
          floor = 7;
          break;
        case 8:
          floor = 8;
          break;
        case 9:
          floor = 9;
          break;
        case 10:
          floor = 10;
          break;
        default:
          floor = null;
      }

      if (floor == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("등록된 층이 아닙니다. 감지된 minor: $detectedMinor")),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('비콘 감지 정보'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("MAC 주소: $strongestMac"),
              Text("RSSI 값: $strongestRssi"),
              Text("minor 값: $detectedMinor"),
              Text("이동할 층: ${floor}층"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToFloor(context, floor!);
              },
              child: const Text('확인'),
            )
          ],
        ),
      );
    });
  }

  void _navigateToFloor(BuildContext context, int floor) {
    Widget screen;
    switch (floor) {
      case 1:
        screen = ItBuilding1fScreen();
        break;
      case 2:
        screen = ItBuilding2fScreen();
        break;
      case 3:
        screen = ItBuilding3fScreen();
        break;
      case 4:
        screen = ItBuilding4fScreen();
        break;
      case 5:
        screen = ItBuilding5fScreen();
        break;
      case 6:
        screen = ItBuilding6fScreen();
        break;
      case 7:
        screen = ItBuilding7fScreen();
        break;
      case 8:
        screen = ItBuilding8fScreen();
        break;
      case 9:
        screen = ItBuilding9fScreen();
        break;
      case 10:
        screen = ItBuilding10fScreen();
        break;
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
