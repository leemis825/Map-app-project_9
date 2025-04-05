import 'package:flutter/material.dart';
import 'home_screen.dart'; // ✅ HomeScreen 가져오기
import 'floor_selector_screen.dart'; // ✅ 층 선택 화면 가져오기

class CampusMapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('조선대학교 캠퍼스 지도'),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/campus_map.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          //  본관 중앙 버튼 
          Positioned(
            left: 290,
            top: 100,
            child: campusButton(
              context,
              label: '본관 중앙',
              destination: const HomeScreen(),
            ),
          ),

          //  IT융합대학 버튼 
          Positioned(
            left: 530,
            top: 90,
            child: campusButton(
              context,
              label: 'IT융합대학',
              destination: FloorSelectorScreen(), // ✅ 여기 바뀜!
            ),
          ),
        ],
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
