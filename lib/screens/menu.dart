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
//import '../widgets/locate_button.dart'; // ✅ 위치 아이콘 공통 위젯

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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("도움말을 확인하세요!")));
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
                Stack(
                  children: [
                    // 층 선택 버튼 (항상 고정 위치)
                    Positioned(
                      top: 5,
                      right: 32,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Color(0xFFE6E6E6),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              showFloorButtons = !showFloorButtons;
                            });
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$selectedFloor층',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Inter',
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                showFloorButtons
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: Colors.black,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 펼쳐지는 층 목록 (버튼 아래에 고정 위치)
                    if (showFloorButtons)
                      Positioned(
                        top: 48,
                        right: 32,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Color(0xFFE6E6E6),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                floors.map((floor) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          selectedFloor = floor;
                                          showFloorButtons = false;
                                        });
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.black,
                                        backgroundColor: Colors.transparent,
                                        padding: EdgeInsets.zero,
                                        textStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                      child: Text('${floor}층'),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      //floatingActionButton: const LocateButton(), // ✅ 위치 아이콘 공통 적용
    );
  }
}
