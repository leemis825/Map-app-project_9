import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart';
import 'it_building_1f_screen.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool isDarkMode = false;
  int selectedFloor = 1;
  bool showFloorButtons = false;

  final List<int> floors = [1, 2, 3, 4, 5];
  final Map<int, Color> floorMaps = {
    1: Colors.lightBlue[100]!,
    2: Colors.green[100]!,
    3: Colors.orange[100]!,
    4: Colors.purple[100]!,
    5: Colors.red[100]!,
  };

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
        title: TextField(
          decoration: InputDecoration(
            hintText: "과목명 또는 강의실 번호를 검색하세요",
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: showHelp,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                '메뉴',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('마이페이지'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.schedule),
              title: Text('시간표'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.dark_mode),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('다크모드'),
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
              leading: Icon(Icons.settings),
              title: Text('설정'),
              onTap: () {},
            ),
          ],
        ),
      ),

      // 본문
      body: Stack(
        children: [
          // ✅ 1층 지도 화면 삽입
          if (selectedFloor == 1)
            ItBuilding1fScreen()
          else //다른 층들 아직 적용 안 함
            Container(
              color: floorMaps[selectedFloor],
              child: Center(
                child: Text(
                  '현재 층: $selectedFloor층',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),

          // 층 선택 버튼
          Positioned(
            top: 20,
            left: 20,
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
                    margin: EdgeInsets.only(top: 10),
                    height: 200,
                    width: 80,
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
          padding: EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: moveToCurrentLocation,
            child: Icon(Icons.my_location),
            backgroundColor: Colors.blue,
          ),
        ),
      ),
    );
  }
}
