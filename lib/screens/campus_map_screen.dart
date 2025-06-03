import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'dart:async';

import 'ble_floor_detector.dart';
import '../widgets/locate_button.dart';
import '../widgets/navigate_button.dart';
import '../widgets/search_bar_with_results.dart';
import '../widgets/qr_button.dart';
import '../screens/lecture_schedule_screen.dart';
import '../data/lecture_data.dart';
import '../screens/home_screen.dart';
import '../screens/menu.dart';
import 'AppDrawer.dart';
import '../widgets/qr_floor_scanner_widget.dart';
import '../screens/navigate_result_screen.dart';

class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({super.key});

  @override
  _CampusMapScreenState createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  bool isDarkMode = false;
  bool _beaconFound = false;
  bool _debugPopupShown = false;

  @override
  void initState() {
    super.initState();
    LectureDataManager.loadLectureData().then((_) {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startBeaconScan(context);
      showBeaconDebugPopupOnce(context);
    });
  }

  void _showQrScanDialog() {
    showDialog(
      context: context,
      builder: (_) => QrFloorScannerWidget(
        onFloorDetected: (floor) {
          Navigator.of(context).pop();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MenuScreen(initialFloor: floor)),
          );
        },
      ),
    );
  }

  void showBeaconDebugPopupOnce(BuildContext context) async {
    if (_debugPopupShown) return;
    _debugPopupShown = true;

    final ble = BleFloorDetector();
    final results = <String>[];

    await ble.detectStrongestBeaconFloorWithLog((mac, rssi, floor) {
      results.add("• $mac / RSSI: $rssi / 층수: ${floor ?? '미확인'}");
    });

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("📡 BLE 비콘 감지 결과"),
        content: Text(results.isEmpty
            ? "❌ 등록된 비콘이 감지되지 않았습니다."
            : results.join("\n")),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("확인"),
          ),
        ],
      ),
    );
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
      showSingleSnackBar(context, "⚠️ BLE 스캔에 필요한 권한이 부족합니다.");
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

            showSingleSnackBar(context, "✅ 비콘 인식됨\nMAC: $mac\nminor: $minor");

            FlutterBluePlus.stopScan();
            subscription?.cancel();
            break;
          }
        }
      }
    });

    await Future.delayed(const Duration(seconds: 5));

    if (!beaconDetected && !_beaconFound) {
      showSingleSnackBar(context, "❌ 근처에서 감지된 비콘이 없습니다.");
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
                    top: 110,
                    child: campusButton(context, '본관', const HomeScreen()),
                  ),
                  Positioned(
                    left: 800,
                    top: 100,
                    child: campusButton(
                      context,
                      'IT융합대학',
                      const MenuScreen(initialFloor: 1),
                    ),
                  ),
                  Positioned(
                    left: 650,
                    top: 270,
                    child: campusButton(context, '중앙 도서관', const HomeScreen()),
                  ),
                  Positioned(
                    left: 20,
                    top: 250,
                    child: campusButton(context, '사회/사범대학', const HomeScreen()),
                  ),
                  Positioned(
                    left: 420,
                    top: 440,
                    child: campusButton(context, '미술대학', const HomeScreen()),
                  ),
                  Positioned(
                    left: 950,
                    top: 630,
                    child: campusButton(context, '제1공과대학', const HomeScreen()),
                  ),
                  Positioned(
                    left: 1025,
                    top: 150,
                    child: campusButton(context, '제2공과대학', const HomeScreen()),
                  ),
                  Positioned(
                    left: 800,
                    top: 45,
                    child: campusButton(context, '법과/경상대학', const HomeScreen()),
                  ),
                  Positioned(
                    left: 1070,
                    top: 500,
                    child: campusButton(context, '체육대학', const HomeScreen()),
                  ),
                  Positioned(
                    left: 1170,
                    top: 430,
                    child: campusButton(context, '자연과학대학', const HomeScreen()),
                  ),
                  Positioned(
                    left: 950,
                    top: 380,
                    child: campusButton(context, '의과대학', const HomeScreen()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            left: 10,
            bottom: 3,
            child: FloatingActionButton(
              heroTag: 'campus-locate',
              backgroundColor: const Color(0xFF0054A7),
              child: const Icon(Icons.my_location, color: Colors.white),
              onPressed: () async {
                final detector = BleFloorDetector();
                final result = await detector.detectStrongestBeacon(context: context);

                if (result != null && result.building == "IT융합대학") {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('비콘 감지 결과'),
                      content: Text("현재 ${result.building} ${result.floor}층으로 감지되었습니다.\n맞습니까?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MenuScreen(initialFloor: result.floor),
                              ),
                            );
                          },
                          child: const Text('예'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _showQrScanDialog(); // ✅ QR 팝업 호출
                          },
                          child: const Text('QR로 인식'),
                        ),
                      ],
                    ),
                  );
                } else {
                  showSingleSnackBar(context, "⚠ IT융합대학 비콘이 감지되지 않았습니다.");
                }
              },
            ),
          ),
          Positioned(
            right: 70,
            bottom: 3,
            child: const QrButton(),
          ),
          Positioned(
            right: 5,
            bottom: 3,
            child: FloatingActionButton(
              heroTag: 'campus-navigate',
              backgroundColor: const Color(0xFF1E88E5),
              child: const Icon(Icons.navigation),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NavigateResultScreen(
                      startRoom: '',
                      endRoom: '',
                      pathSteps: [],
                    ),
                  ),
                );
              },
            ),
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
