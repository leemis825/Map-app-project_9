import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Building Navigation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false, // DEBUG 배너 제거
      home: FloorSelectionScreen(),
    );
  }
}

class FloorSelectionScreen extends StatefulWidget {
  @override
  _FloorSelectionScreenState createState() => _FloorSelectionScreenState();
}

class _FloorSelectionScreenState extends State<FloorSelectionScreen> {
  int selectedFloor = 1; // 현재 선택된 층
  bool showFloorButtons = false; // 층 버튼 표시 여부
  final List<int> floors = [1, 2, 3, 4, 5]; // 층 목록

  // 각 층의 임시 지도 (색상으로 구분)
  final Map<int, Color> floorMaps = {
    1: Colors.lightBlue[100]!,
    2: Colors.green[100]!,
    3: Colors.orange[100]!,
    4: Colors.purple[100]!,
    5: Colors.red[100]!,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('조선대학교 캠퍼스 앱')),
      body: Stack(
        children: [
          // 지도 화면 (가로 스크롤 가능)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal, // 가로 스크롤
            child: Container(
              width: 1000, // 지도의 가로 크기
              color: floorMaps[selectedFloor], // 선택한 층의 배경색 적용
              child: Center(
                child: Text(
                  '현재 층: $selectedFloor층',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          // 층 선택 버튼 (왼쪽 상단)
          Positioned(
            top: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showFloorButtons = !showFloorButtons; // 버튼 목록 표시/숨김 토글
                    });
                  },
                  child: Text('$selectedFloor층'), // 현재 선택된 층 표시
                ),

                // 층 선택 버튼 목록 (세로 스크롤)
                if (showFloorButtons)
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    height: 200, // 버튼 리스트 높이 설정
                    width: 80, // 버튼 리스트 너비 설정
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical, // 🔹 세로 스크롤 설정
                      itemCount: floors.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedFloor = floors[index]; // 선택한 층 변경
                                showFloorButtons = false; // 버튼 목록 숨기기
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
    );
  }
}
