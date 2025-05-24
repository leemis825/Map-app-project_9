import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'dart:async'; // ⬅️ 반드시 추가

import '../widgets/locate_button.dart';
import '../widgets/navigate_button.dart';
import '../widgets/qr_button.dart';

import '../widgets/search_bar_with_results.dart';
import '../screens/lecture_schedule_screen.dart';
import '../data/lecture_data.dart';
import '../screens/home_screen.dart';
import '../screens/menu.dart';
import 'AppDrawer.dart';

class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({super.key});

  @override
  _CampusMapScreenState createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  bool isDarkMode = false;
  bool _beaconFound = false;

  @override
  void initState() {
    super.initState();
    LectureDataManager.loadLectureData().then((_) {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startBeaconScan(context);
    });
  }

  Future<List<String>> loadAllowedBeaconMacs() async {
    final jsonString = await rootBundle.loadString('assets/data/beacon_test_sample.json');
    final List<dynamic> beaconList = json.decode(jsonString);
    return beaconList.map((b) => (b['mac'] as String).toLowerCase()).toList();
  }

  Future<void> startBeaconScan(BuildContext context) async {
    final allowedMacs = await loadAllowedBeaconMacs();

    final bluetoothScan = await Permission.bluetoothScan.request();
    final bluetoothConnect = await Permission.bluetoothConnect.request();
    final location = await Permission.locationWhenInUse.request();

    if (!bluetoothScan.isGranted ||
        !bluetoothConnect.isGranted ||
        !location.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ BLE 스캔에 필요한 권한이 부족합니다.")),
      );
      return;
    }

    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
    bool beaconDetected = false;
    StreamSubscription? subscription;

    subscription = FlutterBluePlus.scanResults.listen((results) {
      if (_beaconFound) return;

      for (ScanResult result in results) {
        final mac = result.device.remoteId.toString().toLowerCase();
        final advData = result.advertisementData.manufacturerData;

        if (allowedMacs.contains(mac) && advData.isNotEmpty) {
          final data = advData.values.first;
          if (data.length >= 4) {
            final minor = (data[2] << 8) | data[3];

            setState(() {
              _beaconFound = true;
            });

            beaconDetected = true;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("✅ 비콘 인식됨\nMAC: $mac\nminor: $minor"),
                duration: const Duration(seconds: 4),
              ),
            );

            FlutterBluePlus.stopScan();
            subscription?.cancel();
            break;
          }
        }
      }
    });

    await Future.delayed(const Duration(seconds: 5));

    if (!beaconDetected && !_beaconFound) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("❌ 근처에서 감지된 비콘이 없습니다."),
          duration: Duration(seconds: 3),
        ),
      );
      FlutterBluePlus.stopScan();
      await subscription?.cancel();
    }
  }

  void _navigateToRoom(String roomName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LectureScheduleScreen(roomName: roomName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        isDarkMode: isDarkMode,
        onToggleDarkMode: (value) {
          setState(() {
            isDarkMode = value;
          });
        },
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SearchBarWithResults(
            initialText: '',
            onRoomSelected: (room) => _navigateToRoom(room),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/campus_map.png',
                    width: 1500,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height,
                  ),
                  Positioned(
                    left: 440,
                    top: 100,
                    child: campusButton(context, '본관 중앙', const HomeScreen()),
                  ),
                  Positioned(
                    left: 800,
                    top: 100,
                    child: campusButton(
                      context,
                      'IT융합대학',
                      MenuScreen(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // ✅ Stack으로 FAB 3개를 화면에 띄우기 (Z 플립 최적화)
      floatingActionButton: Stack(
        children: [
          Positioned(
            right: 16,
            bottom: 16,
            child: const LocateButton(),
          ),
          Positioned(
            right: 16,
            bottom: 96,
            child: const QrButton(),
          ),
          Positioned(
            right: 16,
            bottom: 176,
            child: const NavigateButton(),
          ),
        ],
      ),
    );
  }

  Widget campusButton(BuildContext context, String label, Widget destination) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0054A7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
