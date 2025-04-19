import 'package:flutter/material.dart';
import 'screens/login_screen.dart'; // ✅ 로그인 화면 추가
import 'data/lecture_data.dart'; // ✅ 강의시간표 데이터 추가 (new)

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
      debugShowCheckedModeBanner: false, // 오른쪽 위 DEBUG 리본 없애기
      title: '조선대학교 캠퍼스 지도', // 앱 제목
      home: LoginScreen(), // ✅ 시작화면을 LoginScreen으로 유지
    );
  }
}
