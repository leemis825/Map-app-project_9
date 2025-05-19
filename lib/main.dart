import 'package:flutter/material.dart';
//import 'screens/campus_map_screen.dart';
import 'screens/login_screen.dart'; // ✅ 로그인 화면 추가
import 'data/lecture_data.dart'; // ✅ 강의시간표 데이터 추가 (new)
import 'widgets/responsive_layout.dart'; // ✅ 반응형 UI

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Flutter 비동기 초기화 (반드시 필요)
  await LectureDataManager.loadLectureData(); // ✅ classroom_schedule_final.json 파일 읽기
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '조선대학교 캠퍼스 지도',
      builder:
          (context, child) =>
              ResponsiveLayout(child: child!), // ✅ 이 줄 추가, 반응형 UI
      home: LoginScreen(),
    );
  }
}
