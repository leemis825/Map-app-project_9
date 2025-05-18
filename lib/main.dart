import 'package:flutter/material.dart';
import 'screens/campus_map_screen.dart'; // 캠퍼스 맵 메인 화면

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '조선대학교 캠퍼스 맵',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const CampusMapScreen(), // ✅ 앱 시작 시 캠퍼스 맵으로 이동
    );
  }
}
