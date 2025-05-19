import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart';
import '../data/lecture_data.dart';
import 'search_bar_with_results.dart';
import '../widgets/locate_button.dart'; // ✅ 위치 아이콘 공통 위젯

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
      setState(() {}); // ✅ 데이터 로드 후 위젯 갱신
    });
  }

  void _showHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("여기는 본관 / IT융합대학 설명 페이지입니다.")),
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
      appBar: AppBar(title: const Text('본관 지도')),
      body: Column(
        children: [
          /*SearchBarWithResults(
            initialText: '',
            onRoomSelected: (room) {
              _navigateToRoom(room);
            },
          ),*/
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
      floatingActionButton: const LocateButton(), // ✅ 위치 아이콘 공통 위젯 연결
    );
  }
}
