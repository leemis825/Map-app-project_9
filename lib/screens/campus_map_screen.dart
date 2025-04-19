import 'package:flutter/material.dart';
import 'home_screen.dart'; // ✅ HomeScreen 가져오기
import 'menu.dart'; // ✅ 층 선택 화면 가져오기

class CampusMapScreen extends StatelessWidget {
  const CampusMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('조선대학교 캠퍼스 지도'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // 가로 스크롤 활성화
        child: Row(
          children: [
            Stack(
              children: [
                // 캠퍼스 지도 이미지
                Image.asset(
                  'assets/images/campus_map.png',
                  fit: BoxFit.cover,
                  width: 1500, // 실제 지도의 가로 크기 (필요시 조정)
                  height: MediaQuery.of(context).size.height,
                ),

                // 본관 중앙 버튼
                Positioned(
                  left: 440,
                  top: 100,
                  child: campusButton(
                    context,
                    label: '본관 중앙',
                    destination: const HomeScreen(),
                  ),
                ),

                // IT융합대학 버튼
                Positioned(
                  left: 800,
                  top: 100,
                  child: campusButton(
                    context,
                    label: 'IT융합대학',
                    destination: MenuScreen(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget campusButton(BuildContext context, {required String label, required Widget destination}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }
}
