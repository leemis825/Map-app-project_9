import 'package:flutter/material.dart';
import 'screens/campus_map_screen.dart';  
import 'screens/login_screen.dart'; // ✅ 로그인 화면 추가

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
      home: LoginScreen(), // ✅ 시작화면을 LoginScreen으로 변경
    );
  }
}
