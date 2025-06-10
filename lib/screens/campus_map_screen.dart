// ✅ 리팩터링된 campus_map_screen.dart 전문
// QR, BLE 기능을 menu.dart 방식과 동일하게 구조 통일
import 'package:flutter/material.dart';
import '../widgets/locate_button.dart';
import '../widgets/navigate_button.dart';
import '../widgets/search_bar_with_results.dart';
import '../widgets/qr_button.dart';
import '../screens/lecture_schedule_screen.dart';
import '../data/lecture_data.dart';
import '../screens/home_screen.dart';
import '../screens/menu.dart';
import 'AppDrawer.dart';
import '../screens/navigate_result_screen.dart';

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
      setState(() {});
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

  void _handleFloorDetected(int floor) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MenuScreen(initialFloor: floor)),
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
                  // ✅ 캠퍼스 버튼들
                  Positioned(
                    left: 440,
                    top: 110,
                    child: campusButton(context, '본관', const HomeScreen()),
                  ),
                  Positioned(
                    left: 800,
                    top: 100,
                    child: campusButton(
                      context,
                      'IT융합대학',
                      const MenuScreen(initialFloor: 1),
                    ),
                  ),
                  Positioned(
                    left: 650,
                    top: 270,
                    child: campusButton(context, '중앙 도서관', const HomeScreen()),
                  ),
                  Positioned(
                    left: 20,
                    top: 250,
                    child: campusButton(context, '사회/사범대학', const HomeScreen()),
                  ),
                  Positioned(
                    left: 420,
                    top: 440,
                    child: campusButton(context, '미술대학', const HomeScreen()),
                  ),
                  Positioned(
                    left: 950,
                    top: 630,
                    child: campusButton(context, '제1공과대학', const HomeScreen()),
                  ),
                  Positioned(
                    left: 1025,
                    top: 150,
                    child: campusButton(context, '제2공과대학', const HomeScreen()),
                  ),
                  Positioned(
                    left: 800,
                    top: 45,
                    child: campusButton(context, '법과/경상대학', const HomeScreen()),
                  ),
                  Positioned(
                    left: 1070,
                    top: 500,
                    child: campusButton(context, '체육대학', const HomeScreen()),
                  ),
                  Positioned(
                    left: 1170,
                    top: 430,
                    child: campusButton(context, '자연과학대학', const HomeScreen()),
                  ),
                  Positioned(
                    left: 950,
                    top: 380,
                    child: campusButton(context, '의과대학', const HomeScreen()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          // ✅ BLE 감지 버튼 (SizedBox로 정렬 통일)
          Positioned(
            right: 70,
            bottom: 3,
            child: SizedBox(
              width: 56,
              height: 56,
              child: LocateButton(onFloorDetected: _handleFloorDetected),
            ),
          ),
          // ✅ QR 팝업 버튼 (SizedBox 적용)
          Positioned(
            right: 5,
            bottom: 3,
            child: SizedBox(
              width: 56,
              height: 56,
              child: QrButton(onFloorDetected: _handleFloorDetected),
            ),
          ),
          // ✅ 경로안내 버튼 (기본 FAB도 동일한 사이즈로 감싸기)
          /*Positioned(
            right: 5,
            bottom: 3,
            child: SizedBox(
              width: 56,
              height: 56,
              child: FloatingActionButton(
                heroTag: 'campus-navigate',
                backgroundColor: const Color(0xFF1E88E5),
                child: const Icon(Icons.navigation),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => const NavigateResultScreen(
                            startRoom: '',
                            endRoom: '',
                            pathSteps: [],
                          ),
                    ),
                  );
                },
              ),
            ),
          ),*/
        ],
      ),
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
