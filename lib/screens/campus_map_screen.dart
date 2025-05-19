import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart';
import '../data/lecture_data.dart';
import 'home_screen.dart';
import 'menu.dart';
import 'AppDrawer.dart';
import 'search_bar_with_results.dart';
import '../widgets/locate_button.dart'; // ✅ 추가된 공통 위치 아이콘 위젯

class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({super.key});

  @override
  _CampusMapScreenState createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    LectureDataManager.loadLectureData().then((_) {
      setState(() {}); // ✅ 데이터 로딩 후 위젯 갱신
    });
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
      floatingActionButton: const LocateButton(), // ✅ 위치 아이콘 공통 적용
    );
  }

  Widget campusButton(BuildContext context, String label, Widget destination) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0054A7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
