import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart'; // ✅ BLE 사용
import 'package:permission_handler/permission_handler.dart'; // ✅ 권한 요청 패키지

import 'screens/login_screen.dart'; // ✅ 로그인 화면
import 'data/lecture_data.dart'; // ✅ 강의 시간표 데이터 로딩
import 'widgets/responsive_layout.dart'; // ✅ 다양한 화면 대응
import 'screens/qr_navigate_screen.dart'; // ✅ QR로 경로 탐색
import 'screens/qr_floor_scan.dart'; // ✅ QR로 층 인식

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ 비동기 코드 실행 보장

  // ✅ 강의 시간표 데이터 미리 로드
  await LectureDataManager.loadLectureData();

  // ✅ BLE 및 위치 권한 요청
  await initializeBLEPermissions();

  runApp(const MyApp());
}

// ✅ 블루투스 및 위치 권한 요청 함수
Future<void> initializeBLEPermissions() async {
  // ✅ 블루투스 켜기
  await FlutterBluePlus.turnOn();

  // ✅ BLE 및 위치 권한 요청
  var scanStatus = await Permission.bluetoothScan.request();
  var connectStatus = await Permission.bluetoothConnect.request();
  var locationStatus = await Permission.locationWhenInUse.request(); // <-- 여기 변경됨

  // ✅ 디버깅용 권한 상태 로그 출력
  print('🔍 BLE 권한 상태');
  print('Scan: ${scanStatus.isGranted}');
  print('Connect: ${connectStatus.isGranted}');
  print('Location: ${locationStatus.isGranted}');
}

// ✅ 앱 루트 위젯
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '조선대학교 캠퍼스 지도',
      builder: (context, child) => ResponsiveLayout(child: child!),
      home: LoginScreen(),

      // ✅ 화면 이동을 위한 라우트 등록
      routes: {
        '/qr_floor_scan': (context) => const QrFloorScanScreen(),
        '/qr_navigate': (context) => const QrNavigateScreen(),
      },
    );
  }
}
