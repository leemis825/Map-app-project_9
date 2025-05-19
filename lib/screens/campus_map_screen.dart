import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart';
import '../data/lecture_data.dart';
import 'home_screen.dart';
import 'menu.dart';
import 'AppDrawer.dart';
import '../widgets/search_bar_with_results.dart';
import 'ble_floor_detector.dart';
import 'it_building_1f_screen.dart';
import 'it_building_2f_screen.dart';
import 'it_building_3f_screen.dart';
import 'it_building_4f_screen.dart';

class CampusMapScreen extends StatefulWidget {
  const CampusMapScreen({super.key});

  @override
  _CampusMapScreenState createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  bool isDarkMode = false;
  final BleFloorDetector bleDetector = BleFloorDetector();

  @override
  void initState() {
    super.initState();
    LectureDataManager.loadLectureData().then((_) {
      setState(() {}); // ✅ 데이터 로딩 후 위젯 갱신
    });
  }

  void moveToCurrentLocation() async {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("현재 위치로 이동 중입니다.")));

    int? detectedFloor = await bleDetector.detectStrongestBeaconFloor();

    if (detectedFloor != null) {
      Widget targetScreen;

      if (detectedFloor == 1)
        targetScreen = ItBuilding1fScreen();
      else if (detectedFloor == 2)
        targetScreen = ItBuilding2fScreen();
      else if (detectedFloor == 3)
        targetScreen = ItBuilding3fScreen();
      else if (detectedFloor == 4)
        targetScreen = ItBuilding4fScreen();
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("해당 층 정보를 찾을 수 없습니다.")),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => targetScreen),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("비콘을 감지하지 못했습니다.")),
      );
    }
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
                    child: campusButton(
                      context,
                      'IT융합대학',
                      MenuScreen(),
                    ), //MenuScreen()),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 32.0, bottom: 16.0),
          child: FloatingActionButton(
            onPressed: moveToCurrentLocation,
            backgroundColor: Color(0xFF0054A7),
            child: const Icon(Icons.my_location, color: Colors.white),
          ),
        ),
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
