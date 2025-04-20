import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart'; // 시간표 화면으로 이동
import '../data/lecture_data.dart'; // 검색 함수 사용
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

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool isDarkMode = false;
  int selectedFloor = 1;
  bool showFloorButtons = false;
  final List<int> floors = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    LectureDataManager.loadLectureData(); // ✅ 데이터 미리 로드
  }

  void _handleSearch(String keyword) {
    if (keyword.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final isRoom = LectureDataManager.getLecturesForRoom(keyword).isNotEmpty;

    if (isRoom) {
      // 바로 강의실로 이동
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LectureScheduleScreen(roomName: keyword),
        ),
      );
    } else {
      // 추천 리스트 보여주기
      setState(() {
        _searchResults = LectureDataManager.searchLecturesByKeyword(keyword);
        if (_searchResults.isEmpty) {
          _searchResults = [
            {'subject': '검색 결과 없음', 'professor': '', 'roomName': '', 'day': '', 'start': '', 'end': ''}
          ];
        }
      });
    }
  }

  void _handleSearchTap(Map<String, dynamic> item) {
    String roomName = item['roomName'];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LectureScheduleScreen(roomName: roomName),
      ),
    );
  }

  void showHelp() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("도움말을 확인하세요!")),
    );
  }

  void moveToCurrentLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("내 위치로 이동합니다!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF004098),
        title: TextField(
          controller: _searchController,
          onChanged: _handleSearch,
          decoration: const InputDecoration(
            hintText: "📘 과목명 / 👨‍🏫 교수명 / 📍 강의실 검색",
            hintStyle: TextStyle(color: Colors.white60),
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white, // 깜빡이는 커서 표시
        ),
        actions: [
          IconButton(icon: const Icon(Icons.help_outline), onPressed: showHelp),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('메뉴', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('마이페이지'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('시간표'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('다크모드'),
                  Switch(
                    value: isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        isDarkMode = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('설정'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // 🔲 층별 화면
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

          // ✅ 검색 결과 추천 리스트
          if (_searchResults.isNotEmpty)
            Positioned(
              top: 60,
              left: 16,
              right: 16,
              child: Card(
                elevation: 4,
                color: const Color(0xFFF9F5FC),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _searchResults.length.clamp(0, 3),
                  itemBuilder: (context, index) {
                    final result = _searchResults[index];
                    if (result['subject'] == '검색 결과 없음') {
                      return const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text('🔍 결과가 없습니다.', style: TextStyle(color: Colors.black87)),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: ListTile(
                          title: Text('📘 ${result['subject']} (${result['roomName']}호)'),
                          subtitle: Text('👨‍🏫 ${result['professor']} | ${result['day']} ${result['start']}~${result['end']}'),
                          onTap: () => _handleSearchTap(result),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

          // ⬇️ 층 전환 버튼
          Positioned(
            top: 5,
            left: 310,
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
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: moveToCurrentLocation,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.my_location),
          ),
        ),
      ),
    );
  }
}
