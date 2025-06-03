import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart';
import '../data/lecture_data.dart';
import '../widgets/search_bar_with_results.dart';
import 'AppDrawer.dart';
import '../widgets/locate_button.dart';        // ✅ 위치 추정용 버튼
import '../widgets/navigate_button.dart';     // ✅ 길찾기 버튼
import '../beacon/beacon_scanner.dart';
import 'campus_map_screen.dart';// ✅ 비콘 스캐너 로직 추가

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key}); // 생성자에 추가

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

    // ✅ 앱 시작 시 BLE 비콘 스캔 및 팝업 출력
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scanBeaconsAndShowPopup(context);
    });
  }

  /// ✅ BLE 비콘 5개 스캔 후 팝업으로 정보 표시
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

    if (rssiMap.isEmpty) {
      return;
    }

    // ✅ 감지된 비콘 정보를 정렬 후 텍스트로 정리
    final entries = rssiMap.entries.map((e) {
      final mac = e.key;
      final rssi = e.value;
      final minor = minorMap[mac];
      return "• MAC: $mac | RSSI: $rssi | minor: $minor";
    }).join('\n');

    // ✅ 팝업으로 정보 보여주기
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

  void _showHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("여기는 본관 / IT융합대학 설명 페이지입니다.")),
    );
  }

  void moveToCurrentLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("현재 위치 기능은 준비 중입니다.")),
    );
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
        elevation: 0, // 그림자 없애기
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

            // 🏛️ 건물 설명 텍스트
            const Expanded(
              child: Center(
                child: Text(
                  '업데이트 예정입니다.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),

      // 📍 위치 버튼 + 길찾기 버튼 함께 배치
      floatingActionButton: Stack(
        children: [
          Positioned(
            left: 32,
            bottom: 16,
            child: const LocateButton(), // ✅ BLE 기반 층 추정
          ),
          Positioned(
            right: 32,
            bottom: 16,
            child: const NavigateButton(), // ✅ QR 기반 길찾기
          ),
        ],
      ),
    );
  }
}
