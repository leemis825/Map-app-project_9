import 'package:flutter/material.dart';
import 'lecture_schedule_screen.dart';

class ItBuilding3fScreen extends StatelessWidget {
  final double imageWidth = 1749; // 도면 원본 가로 크기
  final double imageHeight = 799; // 도면 원본 세로 크기

  final List<RoomInfo> rooms = [
    RoomInfo(name: '3108', left: 405, top: 430),
    RoomInfo(name: '3208', left: 415, top: 100),
    RoomInfo(name: '3210', left: 685, top: 100),
    RoomInfo(name: '3224', left: 1270, top: 100),
    RoomInfo(name: '3228', left: 1480, top: 100),
    RoomInfo(name: '3120', left: 1070, top: 280),
    RoomInfo(name: '3128', left: 1280, top: 280),
  ];

  ItBuilding3fScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IT융합대학 3층 지도'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenHeight = constraints.maxHeight;
          double scale = screenHeight / imageHeight;
          double scaledImageWidth = imageWidth * scale;

          return Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: scaledImageWidth,
                height: screenHeight,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/it_building_3f_map.png',
                      fit: BoxFit.fill,
                      width: scaledImageWidth,
                      height: screenHeight,
                    ),

                    // 클릭 가능한 강의실들
                    ...rooms.map((room) {
                      double left = room.left / imageWidth * scaledImageWidth;
                      double top = room.top / imageHeight * screenHeight;
                      return Positioned(
                        left: left,
                        top: top,
                        child: clickableRoomArea(context, room.name),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // 클릭 가능한 컴포넌트 (텍스트 있는 투명 박스)
  Widget clickableRoomArea(BuildContext context, String roomName) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LectureScheduleScreen(roomName: roomName),
          ),
        );
      },
      child: Container(
        width: 80,
        height: 50,
        alignment: Alignment.center,
        color: Colors.transparent, // 개발 시 확인용: Colors.red.withOpacity(0.3)
        child: Text(
          roomName,
          style: const TextStyle(
            color: Colors.deepPurple,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// 강의실 위치 정보 클래스
class RoomInfo {
  final String name;
  final double left;
  final double top;

  RoomInfo({required this.name, required this.left, required this.top});
}