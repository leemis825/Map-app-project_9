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
import '../widgets/locate_button.dart';
import '../widgets/qr_button.dart';
import '../screens/navigate_result_screen.dart';

class MenuScreen extends StatefulWidget {
  final int initialFloor;

  const MenuScreen({super.key, this.initialFloor = 1});

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
    selectedFloor = widget.initialFloor;

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
    setState(() {
      selectedFloor = floor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('IT융합대학 ${selectedFloor}층'),
        backgroundColor: const Color(0xFF0054A7),
        automaticallyImplyLeading: false, // 기본 햄버거 버튼 안 보이게
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).maybePop(); // 뒤로 가기 시도
          },
        ),
      ),
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
                  ItBuilding10fScreen()
                else
                  const Center(child: Text('선택된 층이 없습니다')),

                // ✅ 층 전환 버튼
                Positioned(
                  top: 0,
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
      floatingActionButton: Stack(
        children: [
          Positioned(
            left: 10,
            bottom: 3,
            child: LocateButton(onFloorDetected: _handleFloorDetected), // ✅ 콜백 전달
          ),
          Positioned(
            right: 70,
            bottom: 3,
            child: QrButton(onFloorDetected: _handleFloorDetected), // ✅ 콜백 전달
          ),
          Positioned(
            right: 5,
            bottom: 3,
            child: FloatingActionButton(
              heroTag: 'menu-navigate',
              backgroundColor: const Color(0xFF1E88E5),
              child: const Icon(Icons.navigation),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NavigateResultScreen(
                      startRoom: '',
                      endRoom: '',
                      pathSteps: [],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
