import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart'; // ✅ BLE 사용
import 'package:permission_handler/permission_handler.dart'; // ✅ 권한 요청 패키지

import 'screens/login_screen.dart'; // ✅ 로그인 화면
import 'data/lecture_data.dart'; // ✅ 강의 시간표 데이터 로딩
import 'widgets/responsive_layout.dart'; // ✅ 다양한 화면 대응
import 'screens/qr_navigate_screen.dart'; // ✅ QR로 경로 탐색
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
//import 'screens/campus_map_screen.dart';
import 'screens/login_screen.dart'; // ✅ 로그인 화면 추가
import 'data/lecture_data.dart'; // ✅ 강의시간표 데이터 추가 (new)
import 'firebase.dart';
import 'widgets/responsive_layout.dart'; // ✅ 반응형 UI
import 'firebase_options.dart';
import 'user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ 비동기 코드 실행 보장

  // ✅ 강의 시간표 데이터 미리 로드
  await LectureDataManager.loadLectureData();

  // ✅ BLE 및 위치 권한 요청
  await initializeBLEPermissions();

  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Flutter 비동기 초기화 (반드시 필요)
  await LectureDataManager.loadLectureData(); // ✅ classroom_schedule_final.json 파일 읽기
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await uploadStudentsFromJson();
  runApp(
    ChangeNotifierProvider(create: (_) => UserProvider(), child: const MyApp()),
  );
}

// ✅ 블루투스 및 위치 권한 요청 함수
Future<void> initializeBLEPermissions() async {
  // ✅ 블루투스 켜기
  await FlutterBluePlus.turnOn();

  // ✅ BLE 및 위치 권한 요청
  var scanStatus = await Permission.bluetoothScan.request();
  var connectStatus = await Permission.bluetoothConnect.request();
  var locationStatus = await Permission.locationWhenInUse.request(); // ✅ 위치 권한

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
        '/qr_navigate': (context) => const QrNavigateScreen(), // ✅ QR 경로 탐색
        // ❌ '/qr_floor_scan': 제거됨
      },
    );
  }
}
