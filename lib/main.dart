import 'package:flutter/material.dart';
import 'screens/campus_map_screen.dart'; // ✅ 네가 만든 화면 가져오기

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 오른쪽 위 DEBUG 리본 없애기
      title: '조선대학교 캠퍼스 지도', // 앱 제목
      home: CampusMapScreen(), // ✅ 시작화면을 CampusMapScreen()으로 설정
    );
  }
}
