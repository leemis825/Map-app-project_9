import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart';
import '../data/lecture_data.dart';
import '../widgets/search_bar_with_results.dart';
import 'AppDrawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    LectureDataManager.loadLectureData().then((_) {
      setState(() {}); // ✅ 데이터 로드 후 위젯 갱신 보장
    });
  }

  void _showHelp() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("여기는 본관 / IT융합대학 설명 페이지입니다.")));
  }

  void moveToCurrentLocation() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("현재 위치 기능은 준비 중입니다.")));
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
      drawer: AppDrawer(
        isDarkMode: isDarkMode,
        onToggleDarkMode: (value) {
          setState(() {
            isDarkMode = value;
          });
        },
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 검색 바
            SearchBarWithResults(
              initialText: '',
              onRoomSelected: (room) => _navigateToRoom(room),
            ),

            // 🔙 뒤로가기 + 본관 제목
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '본관',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
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
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 32.0, bottom: 16.0),
          child: FloatingActionButton(
            onPressed: moveToCurrentLocation,
            backgroundColor: const Color(0xFF0054A7),
            child: const Icon(Icons.my_location, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
