import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart';
import '../data/lecture_data.dart';
import '../widgets/search_bar_with_results.dart';
import 'AppDrawer.dart';
import '../widgets/locate_button.dart'; // ✅ 위치 추정용 버튼
import '../widgets/qr_button.dart'; // ✅ QR 코드 버튼
import '../beacon/beacon_scanner.dart';
import 'campus_map_screen.dart';
import 'menu.dart'; // ✅ MenuScreen으로 이동하기 위함

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();

    // ✅ 강의실 시간표 데이터 로드
    LectureDataManager.loadLectureData().then((_) {
      setState(() {});
    });

    // ✅ 앱 시작 시 BLE 비콘 스캔 및 팝업 출력 (디버깅용)
    /*
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scanBeaconsAndShowPopup(context);
    });
    */
  }

  // ✅ BLE 비콘 5개 정보 디버깅 팝업 함수 (선택적으로 주석 처리됨)
  Future<void> _scanBeaconsAndShowPopup(BuildContext context) async {
    final scanner = BeaconScanner();

    Map<String, int> rssiMap = {};
    Map<String, int> minorMap = {};

    await scanner.startScanning(
      onBeaconDetected: (mac, rssi, minor) {
        rssiMap[mac] = rssi;
        minorMap[mac] = minor;
      },
    );

    await Future.delayed(const Duration(seconds: 4));
    scanner.stopScanning();

    if (rssiMap.isEmpty) return;

    final entries = rssiMap.entries
        .map((e) {
          final mac = e.key;
          final rssi = e.value;
          final minor = minorMap[mac];
          return "• MAC: $mac | RSSI: $rssi | minor: $minor";
        })
        .join('\n');

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('감지된 BLE 비콘 (최대 5개)'),
          content: SingleChildScrollView(child: Text(entries)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        ),
      );
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

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // ✅ 그림자 제거
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '실내 지도',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 상단 검색 바
            SearchBarWithResults(
              initialText: '',
              onRoomSelected: (room) => _navigateToRoom(room),
            ),

            const SizedBox(height: 16),

            // 🏛️ 본문 내용 영역 (업데이트 예정 문구)
            const Expanded(
              child: Center(
                child: Text('업데이트 예정입니다.', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),

      // 📍 BLE 버튼 및 QR 버튼 (CampusMapScreen과 동일한 위치에 배치)
      floatingActionButton: Stack(
        children: [
          Positioned(
            right: 70,
            bottom: 3,
            child: SizedBox(
              width: 56,
              height: 56,
              child: LocateButton(
                // ✅ BLE 감지 후 MenuScreen으로 전환
                onFloorDetected: (floor) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MenuScreen(initialFloor: floor),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            right: 5,
            bottom: 3,
            child: SizedBox(
              width: 56,
              height: 56,
              child: QrButton(
                onFloorDetected: (floor) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MenuScreen(initialFloor: floor),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
