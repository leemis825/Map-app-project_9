import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart';
import '../data/lecture_data.dart';
import 'home_screen.dart';
import 'menu.dart';
import 'search_bar_with_results.dart';

class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({super.key});

  @override
  _CampusMapScreenState createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  @override
  void initState() {
    super.initState();
    LectureDataManager.loadLectureData().then((_) {
      setState(() {}); // ✅ 데이터 로딩 후 위젯 갱신
    });
  }

  void showHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("자주 묻는 질문을 확인하세요!")),
    );
  }

  void moveToCurrentLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("현재 위치로 이동 중입니다.")),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF004098),
        title: const Text("조선대학교 캠퍼스 지도"),
        actions: [
          IconButton(icon: const Icon(Icons.help_outline), onPressed: showHelp),
        ],
      ),
      body: Column(
        children: [
          SearchBarWithResults(
            initialText: '',
            onRoomSelected: (room) => _navigateToRoom(room),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/campus_map.png',
                    width: 1500,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height,
                  ),
                  Positioned(
                    left: 440,
                    top: 100,
                    child: campusButton(context, '본관 중앙', const HomeScreen()),
                  ),
                  Positioned(
                    left: 800,
                    top: 100,
                    child: campusButton(context, 'IT융합대학', MenuScreen()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: moveToCurrentLocation,
        backgroundColor: const Color(0xFF004098),
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget campusButton(BuildContext context, String label, Widget destination) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF004098),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
