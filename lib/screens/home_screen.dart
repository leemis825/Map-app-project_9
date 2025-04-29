import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart';
import '../data/lecture_data.dart';
import 'search_bar_with_results.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    LectureDataManager.loadLectureData().then((_) {
      setState(() {}); // ✅ 데이터 로드 후 위젯 갱신 보장
    });
  }

  void _showHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("여기는 본관 / IT융합대학 설명 페이지입니다.")),
    );
  }

  void _moveToCurrentLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("현재 위치 기능은 준비 중입니다.")),
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF004098),
        title: const Text('조선대학교 실내 지도 앱'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: _showHelp,
          ),
        ],
      ),
      body: Column(
        children: [
          SearchBarWithResults(
            initialText: '',
            onRoomSelected: (room) {
              _navigateToRoom(room);
            },
          ),
          const SizedBox(height: 16),
          const Expanded(
            child: Center(
              child: Text(
                '여기는 본관 / IT융합대학 설명 페이지!',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: _moveToCurrentLocation,
            backgroundColor: const Color(0xFF004098),
            child: const Icon(Icons.my_location),
          ),
        ),
      ),
    );
  }
}
