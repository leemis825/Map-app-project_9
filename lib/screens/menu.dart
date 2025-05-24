import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart';
import 'AppDrawer.dart';
import '../data/lecture_data.dart';
import '../widgets/search_bar_with_results.dart';
import 'it_building_1f_screen.dart';
import 'it_building_2f_screen.dart';
import 'it_building_3f_screen.dart';
import 'it_building_4f_screen.dart';
import 'it_building_5f_screen.dart';
import 'it_building_6f_screen.dart';
import 'it_building_7f_screen.dart';
import 'it_building_8f_screen.dart';
import 'it_building_9f_screen.dart';
import 'it_building_10f_screen.dart';
import 'ble_floor_detector.dart'; // ✅ BLE 비콘 기능 import

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool isDarkMode = false;
  int selectedFloor = 1;
  bool showFloorButtons = false;
  final List<int> floors = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  @override
  void initState() {
    super.initState();
    LectureDataManager.loadLectureData().then((_) {
      setState(() {});
    });
  }

  void showHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("도움말을 확인하세요!")),
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

  // ✅ BLE 비콘을 통한 현재 층 자동 감지 및 이동
  void moveToCurrentLocation() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("BLE로 현재 위치를 탐지 중입니다...")),
    );

    final bleDetector = BleFloorDetector();
    int? floor = await bleDetector.detectStrongestBeaconFloor();

    if (floor == null || floor <= 0 || floor > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ 유효한 층 정보를 감지하지 못했습니다.")),
      );
      return;
    }

    setState(() {
      selectedFloor = floor;
      showFloorButtons = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("✅ ${floor}층으로 이동합니다.")),
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
      body: Column(
        children: [
          SearchBarWithResults(
            initialText: '',
            onRoomSelected: (room) => _navigateToRoom(room),
          ),
          Expanded(
            child: Stack(
              children: [
                if (selectedFloor == 1)
                  ItBuilding1fScreen()
                else if (selectedFloor == 2)
                  ItBuilding2fScreen()
                else if (selectedFloor == 3)
                  ItBuilding3fScreen()
                else if (selectedFloor == 4)
                  ItBuilding4fScreen()
                else if (selectedFloor == 5)
                  ItBuilding5fScreen()
                else if (selectedFloor == 6)
                  ItBuilding6fScreen()
                else if (selectedFloor == 7)
                  ItBuilding7fScreen()
                else if (selectedFloor == 8)
                  ItBuilding8fScreen()
                else if (selectedFloor == 9)
                  ItBuilding9fScreen()
                else if (selectedFloor == 10)
                  ItBuilding10fScreen(),
                Positioned(
                  top: 5,
                  right: 32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showFloorButtons = !showFloorButtons;
                          });
                        },
                        child: Text('$selectedFloor층'),
                      ),
                      if (showFloorButtons)
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 200,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListView.builder(
                            itemCount: floors.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      selectedFloor = floors[index];
                                      showFloorButtons = false;
                                    });
                                  },
                                  child: Text('${floors[index]}층'),
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // ✅ 위치 버튼에서 BLE 감지 기능 실행
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
